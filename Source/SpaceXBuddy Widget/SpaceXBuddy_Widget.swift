//
//  SpaceXBuddy_Widget.swift
//  SpaceXBuddy Widget
//
//  Created by Jenei Viktor on 2020. 08. 28..
//

import WidgetKit
import SwiftUI

@main
struct SpaceXBuddy_Widget: Widget {
    let kind: String = "SpaceXBuddy_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SpaceXBuddyWidgetTimelineProvider()) { entry in
            SpaceXBuddy.WidgetContainerView(entry: entry)
        }
        .configurationDisplayName("SpaceX Widget")
        .description("Get informed about SpaceX launches")
    }
}

