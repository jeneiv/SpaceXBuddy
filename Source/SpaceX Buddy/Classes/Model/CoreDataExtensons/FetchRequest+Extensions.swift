//
//  FetchRequest+Extensions.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 11. 19..
//

import Foundation
import CoreData
import SwiftUI

extension FetchRequest {
    static func launchFetchReqest(launchListType : LaunchListView.LaunchListType) -> FetchRequest<CDLaunch> {
        let sortDescriptor = NSSortDescriptor(key: "localDate", ascending: launchListType == .past ? false : true)
        let predicate = NSPredicate(format: "localDate \(launchListType == .upcoming ? ">=" : "<=") %@", Date() as NSDate)
        return FetchRequest<CDLaunch>(entity: CDLaunch.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
    }
}
