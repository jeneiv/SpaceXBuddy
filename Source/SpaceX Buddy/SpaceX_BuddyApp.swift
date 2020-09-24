//
//  SpaceX_BuddyApp.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 01..
//

import SwiftUI

@main
struct SpaceX_BuddyApp: App {
    // In case you still need an AppDelegate Instance (e.g. fetch remote notifications), you can regiter it this way
    @UIApplicationDelegateAdaptor private var appDelegate :  SpaceXBuddyAppDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
