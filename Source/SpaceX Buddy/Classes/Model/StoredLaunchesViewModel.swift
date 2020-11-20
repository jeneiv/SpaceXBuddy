//
//  StoredLAunchesViewModel.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 11. 19..
//

import Foundation
import SwiftUI
import Combine
import CoreData

extension SpaceXBuddy {
    class StoredLaunchesViewModel : ObservableObject {
        enum DataType {
            case past
            case upcoming
            case all
            case next
        }

        @Published private (set) var isLoading = false

        private let dataType : DataType
        private var cancellable: AnyCancellable?
        private var decoder : JSONDecoder {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }
        
        init(dataType: DataType) {
            self.dataType = dataType
        }
        
        func fetch() {
            self.cancellable = URLSession.shared.dataTaskPublisher(for: self.request(for: self.dataType))
                .map {
                    $0.data
                }
                .decode(
                    type: [SpaceXBuddy.Launch].self,
                    decoder: API.spaceXJSONDecoder
                )
                .mapError({ (error: Error) -> Error in
                    print("Error Durring Decoding Launches Response: \(error)")
                    return error
                })
                .replaceError(
                    with: []
                )
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                              receiveOutput: Optional.none,
                              receiveCompletion: { [weak self] _ in self?.onFinish() },
                              receiveCancel: { [weak self] in self?.onFinish() })
                // .eraseToAnyPublisher() // This erase only necessary if you're not replacing errors by `.replaceError(:)`
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
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                let context = PersistencyController.shared.backgroundContext
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                
                context.performAndWait {
                    let _ = result.map { launch in
                        CDLaunch.from(launch, in: context)
                    }
                }

                do {
                    try context.save()
                    SpaceXBuddy.logger.info("Save successful")
                }
                catch let e {
                    SpaceXBuddy.logger.critical("Context Save Failed with \(e.localizedDescription)")
                }
                
            }
        }
        
        func cancel() {
            self.cancellable?.cancel()
        }
        
        func screenTitle() -> String {
            switch dataType {
            case .upcoming:
                return "Upcoming launches"
            case .past:
                return "Past launches"
            default:
                return ""
            }
        }
        
        private func onStart() {
            isLoading = true
        }
        
        private func onFinish() {
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
