//
//  Launch.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 01..
//

import Foundation

extension SpaceXBuddy {
    struct Launch : Codable, Identifiable {
        let links : Links?
        let details : String?
        let flightNumber : Int
        let name : String
        let upcoming : Bool
        let id : String
        let failures : [String]
        let dateUTC : String
        let dateTimeStamp : Int
        let localDate : Date
        
        enum CodingKeys: String, CodingKey {
            case links
            case details
            case flightNumber = "flight_number"
            case name
            case upcoming
            case id
            case failures
            case dateUTC = "date_utc"
            case dateTimeStamp = "date_unix"
            case localDate = "date_local"
        }
    }
}

extension SpaceXBuddy.Launch {
    struct Links : Codable {
        let patch : Patch
        let webcast : String?
        let wikipedia : String?
        let reddit : RedditLinks
        let flickr : FlickrLinks
    }
    
    struct Patch : Codable {
        let small : String?
        let large : String?
    }
    
    struct RedditLinks : Codable {
        let campaign : String?
        let launch : String?
        let media : String?
        let recovery : String?
    }
    
    struct FlickrLinks : Codable {
        let small : [String]
        let original : [String]
    }
}

