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
                .decode(type: [SpaceXBuddy.Launch].self, decoder: self.decoder)
                .replaceError(with: [])
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                              receiveOutput: Optional.none,
                              receiveCompletion: { [weak self] _ in self?.onFinish() },
                              receiveCancel: { [weak self] in self?.onFinish() })
                .eraseToAnyPublisher()
                // You can use sink to surface the value in any other way you want to
                .sink(receiveValue: { result in
                    if self.dataType == .next {
                        if let nextLaunch = result.sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                            lhs.dateTimeStamp < rhs.dateTimeStamp
                        }).first {
                            self.launches = [nextLaunch]
                        }
                    }
                    else if self.sortOrder == .ascending {
                        self.launches = result.sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                            lhs.dateTimeStamp < rhs.dateTimeStamp
                        })
                    }
                    else {
                        self.launches = result.sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                            lhs.dateTimeStamp > rhs.dateTimeStamp
                        })
                    }
                })
                /*
                // Use Assign to use the response AS-IS
                .assign(to: \.launches, on: self)
                */
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
