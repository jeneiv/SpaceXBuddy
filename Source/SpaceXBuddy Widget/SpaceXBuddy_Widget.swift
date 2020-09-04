//
//  SpaceXBuddy_Widget.swift
//  SpaceXBuddy Widget
//
//  Created by Jenei Viktor on 2020. 08. 28..
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = SpaceXBuddy.SpaceXLaunchEntry
    
    func placeholder(in context: Context) -> Entry {
        SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        // TODO: Replace data for real entry at some point
        let entry = SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
        completion(entry)
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
            }
            else {
                let entry = SpaceXBuddy.SpaceXLaunchEntry(launch: Optional.none, date: Date())
                timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(SpaceXBuddy.SpaceXLaunchEntry.failureRetryTimeInterval)))
            }
            completion(timeline)
        }
    }
}

extension SpaceXBuddy {
    struct SpaceXLaunchEntry: TimelineEntry {
        static let widgetOverlayTimeInterval : TimeInterval = 60 * 60 * 2 // 2 hours
        static let failureRetryTimeInterval : TimeInterval = 60 * 60 // 1 hour

        let launch : SpaceXBuddy.Launch?
        var date: Date // Just remember, the Entry's date stores FROM WHAT POINT IN TIME the widget is active
    }
}

@main
struct SpaceXBuddy_Widget: Widget {
    let kind: String = "SpaceXBuddy_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SpaceXBuddy.WidgetContainerView(entry: entry)
        }
        .configurationDisplayName("SpaceX Widget")
        .description("Get informed about SpaceX launches")
    }
}

