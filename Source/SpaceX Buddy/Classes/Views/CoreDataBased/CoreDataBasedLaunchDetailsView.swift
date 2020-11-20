//
//  CoreDataBasedLaunchDetailsView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 11. 20..
//

import SwiftUI

struct CoreDataBasedLaunchDetailsView: View {
    let launch : CDLaunch
    @ObservedObject private var launchNotificationModel : SpaceXBuddy.LaunchNotificationModel

    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    init(launch: CDLaunch) {
        self.launch = launch
        launchNotificationModel = SpaceXBuddy.LaunchNotificationModel(launch: self.launch)
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack (alignment: .center) {
                    LaunchBadgeView(imageURL: launch.links?.patch?.large)
                        .frame(maxWidth: 250)
                    LaunchLinksView(launch: launch)
                }
                
                // Details
                Text(launch.details ?? "")
                
                // Launch Date
                launchDateView(launch: launch)

                notificationSubscriberView()
                
                // Failures
                launchFaliuresView(launch: launch)
                
            }
            .padding()
            .font(.subheadline)
            .navigationBarTitle (Text(launch.name ?? ""))
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

extension CoreDataBasedLaunchDetailsView {
    @ViewBuilder func launchFaliuresView(launch: CDLaunch) -> some View {
        VStack(alignment: .leading) {
            Text("Failures (\(launch.faliuresArray().count))")
                .font(.callout)
            ForEach(launch.faliuresArray()) { (faliure : CDLaunchFailure) in
                HStack (alignment: .top) {
                    Text("•")
                    Text(faliure.reason ?? "")
                }
            }
        }
        .padding(.top)
    }
    
    @ViewBuilder func launchDateView(launch: CDLaunch) -> some View {
        if let launchDate = launch.localDate {
            HStack {
                Text("Local Launch Date/Time")
                Spacer()
                Text(dateFormatter.string(from: launchDate))
            }
            .padding(.top)
            
            if launchDate > Date() {
                HStack {
                    Text("To go:")
                    Spacer()
                    LaunchCountdownView(launchDate: launchDate)
                }
            }

        }
    }
    
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

/*
struct CoreDataBasedLaunchDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataBasedLaunchDetailsView()
    }
}
*/
