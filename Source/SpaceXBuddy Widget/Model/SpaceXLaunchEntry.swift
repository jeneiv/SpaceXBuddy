//
//  SpaceXLaunchEntry.swift
//  SpaceXBuddy WidgetExtension
//
//  Created by Jenei Viktor on 2020. 09. 07..
//

import Foundation
import WidgetKit

extension SpaceXBuddy {
    struct SpaceXLaunchEntry: TimelineEntry, Codable {
        static let widgetOverlayTimeInterval : TimeInterval = 60 * 60 * 2 // 2 hours
        static let failureRetryTimeInterval : TimeInterval = 60 * 60 // 1 hour

        let launch : SpaceXBuddy.Launch?
        var date: Date // Just remember, the Entry's date stores FROM WHAT POINT IN TIME the widget is active
    }
}

extension SpaceXBuddy.SpaceXLaunchEntry {
    private static let spaceXBuddyNextLaunchWidgetEntryUserDefaultsKey = "spaceXBuddyNextLaunchWidgetEntryUserDefaultsKey"
    
    func saveToUserDefaults() {
        if let encodedEntry = try? JSONEncoder().encode(self) {
            UserDefaults.standard.setValue(encodedEntry, forKey: SpaceXBuddy.SpaceXLaunchEntry.spaceXBuddyNextLaunchWidgetEntryUserDefaultsKey)
        }
    }
    
    static func fromUserDefaults() -> SpaceXBuddy.SpaceXLaunchEntry? {
        guard let storedData = UserDefaults.standard.object(forKey: SpaceXBuddy.SpaceXLaunchEntry.spaceXBuddyNextLaunchWidgetEntryUserDefaultsKey) as? Data else {
            return Optional.none
        }
        if let decodedEntry = try? JSONDecoder().decode(SpaceXBuddy.SpaceXLaunchEntry.self, from: storedData) {
            return decodedEntry
        }
        else {
            return Optional.none
        }
    }
}
