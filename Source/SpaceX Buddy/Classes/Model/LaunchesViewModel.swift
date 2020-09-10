//
//  LaunchesViewModel.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 17..
//

import Foundation
import Combine

extension SpaceXBuddy {
    class LaunchesViewModel : ObservableObject {
        enum DataType {
            case past
            case upcoming
            case all
            case next
        }
                
        enum SortOrder {
            case ascending
            case descending
        }
        
        @Published private (set) var launches = [SpaceXBuddy.Launch]()
        @Published private (set) var isLoading = false
        
        var dataType : DataType
        var sortOrder : SortOrder
        
        private var cancellable: AnyCancellable?
        private var decoder : JSONDecoder {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }
        
        init(dataType : DataType = .all, sortOrder : SortOrder = .descending) {
            self.dataType = dataType
            self.sortOrder = sortOrder
        }
        
        func fetch() {
            self.cancellable = URLSession.shared.dataTaskPublisher(for: self.request(for: self.dataType))
                .map { $0.data }
                .decode(type: [SpaceXBuddy.Launch].self, decoder: API.spaceXJSONDecoder)
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                              receiveOutput: Optional.none,
                              receiveCompletion: { [weak self] _ in self?.onFinish() },
                              receiveCancel: { [weak self] in self?.onFinish() })
                .eraseToAnyPublisher()
                // You can use sink to handle/surface the value in any other way you want to
                .sink(receiveValue: { result in
                    self.handleResult(result)
                })
                /*
                // Use Assign to use the response AS-IS
                .assign(to: \.launches, on: self)
                */
        }
        
        private func handleResult(_ result: [SpaceXBuddy.Launch]) {
            var result = result

            sortResult(&result)
            filterResult(&result)
            
            self.launches = result
        }
        
        private func sortResult(_ result: inout [SpaceXBuddy.Launch]) {
            if self.dataType == .next {
                if let nextLaunch = result.sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                    lhs.dateTimeStamp < rhs.dateTimeStamp
                }).first {
                    result = [nextLaunch]
                }
            }
            else if self.sortOrder == .ascending {
                result = result.sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                    lhs.dateTimeStamp < rhs.dateTimeStamp
                })
            }
            else {
                result = result.sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                    lhs.dateTimeStamp > rhs.dateTimeStamp
                })
            }
        }
        
        private func filterResult(_ result: inout [SpaceXBuddy.Launch]) {
            // Filtering Logic, because the API sometimes provides past launches in the upcoming response and vice versa
            if self.dataType == .upcoming {
                result = result.filter { launch in
                    launch.localDate >= Date()
                }
            }
            else if self.dataType == .past {
                result = result.filter { launch in
                    launch.localDate <= Date()
                }
            }
        }
        
        func cancel() {
            self.cancellable?.cancel()
        }
        
        func onStart() {
            isLoading = true
        }
        
        func onFinish() {
            isLoading = false
        }
        
        private func request(for dataType: DataType) -> URLRequest {
            switch dataType {
            case .past:
                return SpaceXBuddy.API.pastLaunchesRequest()
            case .upcoming, .next:
                return SpaceXBuddy.API.upcomingLaunchesRequest()
            case .all:
                return SpaceXBuddy.API.allLaunchesRequest()
            }
        }
    }
}


extension SpaceXBuddy.LaunchesViewModel.DataType {
    func navigationTitle() -> String {
        switch self {
        case .past:
            return "Past Launches"
        case .upcoming:
            return "Upcoming Launches"
        case .all:
            return "Launches"
        case .next:
            return "Next Launch"
        }
    }
}
