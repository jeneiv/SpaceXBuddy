//
//  RequestBuilder.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 01..
//

import Foundation

extension SpaceXBuddy {
    enum API {}
}

extension SpaceXBuddy.API {
    // API Docs: https://github.com/r-spacex/SpaceX-API/blob/master/docs/v4/README.md
    
    fileprivate static let host = "https://api.spacexdata.com"
    
    fileprivate enum Path : String {
        case upcomingLaunches = "v4/launches/upcoming"
        case pastLaunches = "v4/launches/past"
        case launches = "v4/launches"
        case roadster = "v4/roadster"
    }
    
    static var spaceXJSONDecoder : JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.nonConformingFloatDecodingStrategy = .throw
        return decoder
    }
    
    static func upcomingLaunchesRequest() -> URLRequest {
        URLRequest(url: URL(Path.upcomingLaunches)!)
    }

    static func pastLaunchesRequest() -> URLRequest {
        URLRequest(url: URL(Path.pastLaunches)!)
    }
    
    static func allLaunchesRequest() -> URLRequest {
        URLRequest(url: URL(Path.launches)!)
    }
    
    static func launchRequest(for id: String) -> URLRequest {
        var url = URL(Path.launches)
        url?.appendPathComponent(id)
        return URLRequest(url: url!)
    }

    static func roadsterInfoRequest() -> URLRequest {
        URLRequest(url: URL(Path.roadster)!)
    }
    
    // TODO: Add Later (maybe)
    // - Rockets
    // - Cores
    // - Crew
}

fileprivate extension URL {
    init?(_ path: SpaceXBuddy.API.Path) {
        self.init(string: SpaceXBuddy.API.host)
        self.appendPathComponent(path)
    }
}
