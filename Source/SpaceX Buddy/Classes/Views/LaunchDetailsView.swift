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
    static var previews: some View {
        Group {
            LaunchDetailsView(launch: PreviewData.mockLaunchWithActiveSocialLinks())
                .preferredColorScheme(.light)
            LaunchDetailsView(launch: PreviewData.mockLaunchInActiveSocialLinks())
                .preferredColorScheme(.light)
            LaunchDetailsView(launch: PreviewData.mockLaunchWithActiveSocialLinks())
                .preferredColorScheme(.dark)
            LaunchDetailsView(launch: PreviewData.mockLaunchInActiveSocialLinks())
                .preferredColorScheme(.dark)
        }
    }
}
