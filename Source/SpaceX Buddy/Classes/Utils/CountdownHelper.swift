//
//  CountdownHelper.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 27..
//

import Foundation

struct CountdownHelper {
    private static let minuteInSeconds : Double = 60
    private static let hourInSeconds : Double = minuteInSeconds * 60
    private static let dayInSeconds : Double = hourInSeconds * 24
    
    private static func days(in timeInterval: TimeInterval) -> Int {
        return Int(timeInterval / dayInSeconds)
    }
    
    private static func hours(in timeInterval: TimeInterval) -> Int {
        return Int(timeInterval / hourInSeconds)
    }
    
    private static func minutes(in timeInterval: TimeInterval) -> Int {
        return Int(timeInterval / minuteInSeconds)
    }
    
    static func timeComponenets(in timeInterval: TimeInterval) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let days = CountdownHelper.days(in: timeInterval)
        var deducted : Double = Double(days) * dayInSeconds
        let hours = CountdownHelper.hours(in: timeInterval - deducted)
        deducted += Double(hours) * hourInSeconds
        let minutes = CountdownHelper.minutes(in: timeInterval - deducted)
        deducted += Double(minutes) * minuteInSeconds
        return (days, hours, minutes, Int(timeInterval - deducted))
    }
}
