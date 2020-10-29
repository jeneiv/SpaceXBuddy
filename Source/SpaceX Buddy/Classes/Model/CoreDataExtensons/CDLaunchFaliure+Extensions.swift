//
//  CDLaunchFaliure+Extensions.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 10. 29..
//

import Foundation
import CoreData

extension CDLaunchFailure {
    static func from(_ failure: SpaceXBuddy.Launch.Failure, in context: NSManagedObjectContext) -> CDLaunchFailure {
        let cdFailure = CDLaunchFailure(context: context)
        cdFailure.time = failure.time
        cdFailure.altitude = failure.altitude ?? 0.0
        cdFailure.reason = failure.reason
        return cdFailure
    }
}
