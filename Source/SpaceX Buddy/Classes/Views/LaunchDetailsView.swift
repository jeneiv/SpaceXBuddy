//
//  LaunchDetailsView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 24..
//

import SwiftUI

// MARK: - Details

struct LaunchDetailsView: View {
    var launch : SpaceXBuddy.Launch
    
    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack (alignment: .center) {
                    LaunchBadgeView(imageURL: launch.links?.patch.large)
                        .frame(maxWidth: 250)
                    LaunchLinksView(launch: launch)
                }
                
                // Details
                Text(launch.details ?? "")
                
                // Launch Date
                HStack {
                    Text("Local Launch Date/Time")
                    Spacer()
                    Text(dateFormatter.string(from: launch.localDate))
                }
                .padding(.top)
                
                if launch.localDate > Date() {
                    HStack {
                        Text("To go:")
                        Spacer()
                        LaunchCountdownView(launchDate: launch.localDate)
                    }
                }

                // Failures
                VStack (alignment: .leading) {
                    Text("Failures (\(launch.failures.count))")
                        .font(.callout)
                    ForEach (launch.failures, id: \.hash) { failure in
                        HStack (alignment: .top) {
                            Text("•")
                            Text(failure)
                        }
                    }
                }
                .padding(.top)
            }
            .padding()
            .font(.subheadline)
            .navigationBarTitle (Text(launch.name))
        }
    }
}

// MARK: - Preview

struct LaunchDetailsView_Previews: PreviewProvider {
    static private func mockLaunchWithActiveSocialLinks() -> SpaceXBuddy.Launch {
        let patch = SpaceXBuddy.Launch.Patch(
            small: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png",
            large: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png"
        )
        let redditLinks = SpaceXBuddy.Launch.RedditLinks(
            campaign: "https://www.reddit.com/r/spacex/comments/ezn6n0/crs20_launch_campaign_thread",
            launch: "https://www.reddit.com/r/spacex/comments/fe8pcj/rspacex_crs20_official_launch_discussion_updates/",
            media: "https://www.reddit.com/r/spacex/comments/fes64p/rspacex_crs20_media_thread_videos_images_gifs/",
            recovery: Optional.none
        )
        let flickrLinks = SpaceXBuddy.Launch.FlickrLinks(
            small: [],
            original: [
                "https://live.staticflickr.com/65535/49635401403_96f9c322dc_o.jpg",
                "https://live.staticflickr.com/65535/49636202657_e81210a3ca_o.jpg",
                "https://live.staticflickr.com/65535/49636202572_8831c5a917_o.jpg",
                "https://live.staticflickr.com/65535/49635401423_e0bef3e82f_o.jpg",
                "https://live.staticflickr.com/65535/49635985086_660be7062f_o.jpg"
            ]
        )
        let links = SpaceXBuddy.Launch.Links(
            patch: patch,
            webcast: "https://www.youtube.com/watch?v=sl2jo1bSxl8",
            wikipedia: "https://en.wikipedia.org/wiki/SpaceX_CRS-20",
            reddit: redditLinks,
            flickr: flickrLinks
        )
        return SpaceXBuddy.Launch(links: links,
                                        details: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eget massa non est aliquam malesuada et sed eros. Mauris sed tellus eros. Vivamus luctus tristique neque et pharetra. Donec non fringilla nunc.", flightNumber: 1,
                                        name: "Mock Launch",
                                        upcoming: true,
                                        id: "0",
                                        failures: [
                                            "engine failure",
                                            "catapult error"
                                        ],
                                        dateUTC: "2006-03-24T22:30:00.000Z",
                                        dateTimeStamp: 1143239400,
                                        localDate:
                                        Date())
    }
    
    static private func mockLaunchInActiveSocialLinks() -> SpaceXBuddy.Launch {
        let patch = SpaceXBuddy.Launch.Patch(
            small: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png",
            large: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png"
        )
        let redditLinks = SpaceXBuddy.Launch.RedditLinks(campaign: Optional.none, launch: Optional.none, media: Optional.none, recovery: Optional.none)
        let flickrLinks = SpaceXBuddy.Launch.FlickrLinks(small: [], original: [])

        let links = SpaceXBuddy.Launch.Links(
            patch: patch,
            webcast: Optional.none,
            wikipedia: Optional.none,
            reddit: redditLinks,
            flickr: flickrLinks
        )
        return SpaceXBuddy.Launch(links: links,
                                        details: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eget massa non est aliquam malesuada et sed eros. Mauris sed tellus eros. Vivamus luctus tristique neque et pharetra. Donec non fringilla nunc.", flightNumber: 1,
                                        name: "Mock Launch",
                                        upcoming: true,
                                        id: "0",
                                        failures: [
                                            "engine failure",
                                            "catapult error"
                                        ],
                                        dateUTC: "2006-03-24T22:30:00.000Z",
                                        dateTimeStamp: 1143239400,
                                        localDate:
                                        Date())
    }
    
    static var previews: some View {
        Group {
            LaunchDetailsView(launch: mockLaunchWithActiveSocialLinks())
                .preferredColorScheme(.light)
            LaunchDetailsView(launch: mockLaunchInActiveSocialLinks())
                .preferredColorScheme(.light)
            LaunchDetailsView(launch: mockLaunchWithActiveSocialLinks())
                .preferredColorScheme(.dark)
            LaunchDetailsView(launch: mockLaunchInActiveSocialLinks())
                .preferredColorScheme(.dark)
        }
    }
}
