//
//  RoadsterInfo.swift
//  SpaceX Buddy
//
//  Created by Viktor Jenei on 2021. 10. 15..
//

import Foundation

extension SpaceXBuddy {
    struct RoadsterInfo: Codable {
        let speed: Double
        let earthDistance: Double
        let marsDistance: Double

        enum CodingKeys: String, CodingKey {
            case speed = "speed_kph"
            case earthDistance = "earth_distance_km"
            case marsDistance = "mars_distance_km"
        }
    }
}
