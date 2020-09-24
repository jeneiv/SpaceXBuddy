//
//  LaunchDetailsView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 24..
//

import SwiftUI

// MARK: - Details

struct LaunchDetailsView: View {
    let launch : SpaceXBuddy.Launch
    @ObservedObject private var launchNotificationModel : SpaceXBuddy.LaunchNotificationModel
    
    init(launch: SpaceXBuddy.Launch) {
        self.launch = launch
        launchNotificationModel = SpaceXBuddy.LaunchNotificationModel(launch: self.launch)
    }
    
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
                
                notificationSubscriberView()
                
                // Failures
                VStack (alignment: .leading) {
                    Text("Failures (\(launch.failures.count))")
                        .font(.callout)
                    ForEach (launch.failures, id: \.reason.hash) { failure in
                        HStack (alignment: .top) {
                            Text("•")
                            Text(failure.reason)
                        }
                    }
                }
                .padding(.top)
            }
            .padding()
            .font(.subheadline)
            .navigationBarTitle (Text(launch.name))
            .alert(isPresented: $launchNotificationModel.notificationsDisabled, content: {
                Alert(title: Text("Notification Error"),
                      message: Text("Please turn on notifications for the application"),
                      primaryButton: .destructive(Text("Go to App Settings")) {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: Optional.none)
                        }
                      },
                      secondaryButton: .cancel()
                )
            })
        }
    }
}

extension LaunchDetailsView {
    @ViewBuilder func notificationSubscriberView() -> some View {
        if launch.upcoming {
            // Notification Toggle
            HStack {
                Text("Notify me")
                Spacer()
                Button(action: {
                    launchNotificationModel.toggleNotification()
                }) {
                    if launchNotificationModel.hasPendingNotification {
                        Image(systemName: "text.bubble.fill").font(.largeTitle).foregroundColor(.yellow)
                    }
                    else {
                        Image(systemName: "plus.bubble").font(.largeTitle).foregroundColor(.yellow)
                    }
                }
            }
            .padding(.top)
        }
    }
}

// MARK: - Preview

struct LaunchDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchDetailsView(launch: PreviewData.mockLaunchWithActiveSocialLinks())
                .preferredColorScheme(.light)
            LaunchDetailsView(launch: PreviewData.mockLaunchInActiveSocialLinks(upcoming: false))
                .preferredColorScheme(.light)
            LaunchDetailsView(launch: PreviewData.mockLaunchWithActiveSocialLinks())
                .preferredColorScheme(.dark)
            LaunchDetailsView(launch: PreviewData.mockLaunchInActiveSocialLinks(upcoming: false))
                .preferredColorScheme(.dark)
        }
    }
}
