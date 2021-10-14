//
//  SpaceX_BuddyApp.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 01..
//

import SwiftUI

@main
struct SpaceX_BuddyApp: App {
    // In case you still need an AppDelegate Instance (e.g. fetch remote notifications), you can register it this way
    @UIApplicationDelegateAdaptor private var appDelegate :  SpaceXBuddyAppDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    init() {
        SpaceXBuddy.PersistencyController.shared.setup { (result: SpaceXBuddy.PersistencyController.SetupResult) in
            switch result {
            case .success:
                SpaceXBuddy.logger.info("Core Data has has been initialised successfully")
                let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
                SpaceXBuddy.logger.info("Chat Data DB Location: \(String(describing: url!))")
            case .error(let error):
                SpaceXBuddy.logger.error("Core Data stack initialised failed with error: \(error.localizedDescription)")
            }
        }
    }
}
