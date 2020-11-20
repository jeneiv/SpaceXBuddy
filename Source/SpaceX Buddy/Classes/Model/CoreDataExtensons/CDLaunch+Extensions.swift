//
//  CDLaunch+Extensions.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 10. 29..
//

import Foundation
import CoreData

extension CDLaunch {
    @discardableResult
    static func from(_ launch: SpaceXBuddy.Launch, in context: NSManagedObjectContext) -> CDLaunch {
        let cdLaunch = CDLaunch(context: context)

        // Direct data transfer from launch itself
        cdLaunch.flightNumber = Int32(launch.flightNumber)
        cdLaunch.launchID = launch.id
        cdLaunch.dateTimeStamp = Int32(launch.dateTimeStamp)
        cdLaunch.dateUTC = launch.dateUTC
        cdLaunch.details = launch.details
        cdLaunch.localDate = launch.localDate
        cdLaunch.name = launch.name
        cdLaunch.upcoming = launch.upcoming
        
        // Launch Failures
        if !launch.failures.isEmpty {
            let cdLaunchFailures = launch.failures.map { failure in
                CDLaunchFailure.from(failure, in: context)
            }
            cdLaunch.failures?.addingObjects(from: cdLaunchFailures)
        }
        
        // Launch Links
        if let links = launch.links {
            cdLaunch.links = CDLaunchLink.from(links, in: context)
        }
        
        return cdLaunch
    }
}
