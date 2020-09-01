//
//  WidgetDataService.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 09. 01..
//

import Foundation

extension SpaceXBuddy {
    struct WidgetDataService {
        static func fetchFutureLaunches(completion: @escaping (Result<[Launch], Error>) -> Swift.Void) {
            let request = API.upcomingLaunchesRequest()
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    do {
                        let result = try API.spaceXJSONDecoder.decode([Launch].self, from: data)
                        // SpaceX API is giving us past launches sometimes. This filter make sure that we ignore those.
                        .filter { launch in
                            launch.localDate >= Date()
                        }
                        .sorted(by: { (lhs : SpaceXBuddy.Launch, rhs : SpaceXBuddy.Launch) -> Bool in
                            lhs.dateTimeStamp < rhs.dateTimeStamp
                        })
                        completion(.success(result))
                    }
                    catch let jsonParseError {
                        completion(.failure(jsonParseError))
                    }
                }
            }
            task.resume()
        }
    }
}
