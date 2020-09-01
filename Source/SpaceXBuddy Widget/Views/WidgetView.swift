//
//  WidgetView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 28..
//

import SwiftUI
import WidgetKit

extension SpaceXBuddy {
    struct WidgetContainerView : View {
        @Environment(\.widgetFamily) var family: WidgetFamily
        
        var entry: Provider.Entry

        var body: some View {
            if let launch = entry.launch {
                switch family {
                case .systemMedium: SpaceXBuddy.MediumWidgetView(launch: launch)
                case .systemLarge: SpaceXBuddy.LargeWidgetView(launch: launch)
                default: SpaceXBuddy.SmallWidgetView(launch: launch)
                }
            }
            else {
                VStack {
                    Text("SpaceXBuddy")
                        .font(.headline)
                    Text("Failed to load data")
                    Text("We'll try to load it again soon")
                }
                .font(.footnote)
                .padding()
            }
        }
    }

    struct SmallWidgetView : View {
        var launch : SpaceXBuddy.Launch

        var body: some View {
            VStack {
                Text("Next Launch:")
                Image("spaceship_flying")
                    .frame(height: 60)
                Text(launch.localDate, style: .date)
                Text(launch.localDate, style: .time)
            }
            .font(.footnote)
        }
    }

    struct MediumWidgetView : View {
        var launch : SpaceXBuddy.Launch

        var body: some View {
            HStack {
                Image("spaceship_flying")
                    .frame(width: 90)
                VStack (alignment: .leading) {
                    Text("Next Launch:")
                        .font(.headline)
                    Text(launch.name)
                    Text(launch.localDate, style: .date)
                    Text(launch.localDate, style: .time)
                }
                .font(.callout)
                Spacer()
            }
            .padding(.horizontal)
        }
    }

    struct LargeWidgetView : View {
        var launch : SpaceXBuddy.Launch

        var body: some View {
            VStack {
                HStack {
                    Image("spaceship_flying")
                        .frame(width: 120)
                    VStack (alignment: .leading) {
                        Text("Next Launch:")
                            .font(.headline)
                        Text(launch.name)
                        Text(launch.localDate, style: .date)
                        Text(launch.localDate, style: .time)
                    }
                    .font(.callout)
                    Spacer()
                }
                
                Text(launch.details ?? "")
                    .font(.subheadline)
            }
            .padding(.horizontal)
        }
    }
}

struct SpaceXBuddy_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SpaceXBuddy.WidgetContainerView(
                entry: SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.light)

            SpaceXBuddy.WidgetContainerView(
                entry: SpaceXBuddy.SpaceXLaunchEntry(launch: Optional.none, date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .preferredColorScheme(.light)

            SpaceXBuddy.WidgetContainerView(
                entry: SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.light)

            SpaceXBuddy.WidgetContainerView(
                entry: SpaceXBuddy.SpaceXLaunchEntry(launch: Optional.none, date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .preferredColorScheme(.light)

            SpaceXBuddy.WidgetContainerView(
                entry: SpaceXBuddy.SpaceXLaunchEntry(launch: PreviewData.widgetPlaceholderLaunch(), date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.light)

            SpaceXBuddy.WidgetContainerView(
                entry: SpaceXBuddy.SpaceXLaunchEntry(launch: Optional.none, date: Date())
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .preferredColorScheme(.light)

        }
    }
}
