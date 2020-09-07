//
//  SpaceXBuddyWidgetTimelineProvider.swift
//  SpaceXBuddy WidgetExtension
//
//  Created by Jenei Viktor on 2020. 09. 07..
//

import Foundation
import WidgetKit

struct SpaceXBuddyWidgetTimelineProvider: TimelineProvider {
    typealias Entry = SpaceXBuddy.SpaceXLaunchEntry
    
    func placeholder(in context: Context) -> Entry {
        SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        if let nextEntry = SpaceXBuddy.SpaceXLaunchEntry.fromUserDefaults() {
            completion(nextEntry)
        }
        else {
            let entry = SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        SpaceXBuddy.WidgetDataService.fetchFutureLaunches { (result: Result<[SpaceXBuddy.Launch], Error>) in
            var timeline : Timeline<Entry>
            if case .success(let launches) = result {
                var entryDate = Date()
                var entries : [SpaceXBuddy.SpaceXLaunchEntry] = []
                launches.forEach { (launch: SpaceXBuddy.Launch) in
                    let entry = SpaceXBuddy.SpaceXLaunchEntry(launch: launch, date: entryDate)
                    entryDate = launch.localDate
                    entries.append(entry)
                }
                timeline = Timeline(entries: entries, policy: .atEnd)
                
                // Storing very next entry for `getSnapshot(in: , completion: )`
                if let nextEntry = entries.first {
                    nextEntry.saveToUserDefaults()
                }
            }
            else {
                let entry = SpaceXBuddy.SpaceXLaunchEntry(launch: Optional.none, date: Date())
                timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(SpaceXBuddy.SpaceXLaunchEntry.failureRetryTimeInterval)))
            }
            completion(timeline)
        }
    }
}
