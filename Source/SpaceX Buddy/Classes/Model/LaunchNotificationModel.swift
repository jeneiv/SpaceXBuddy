//
//  NotificationService.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 09. 20..
//

import Foundation
import UserNotifications

extension SpaceXBuddy {
    
    class LaunchNotificationModel : ObservableObject {
        @Published private (set) var hasPendingNotification : Bool = false
        @Published var notificationsDisabled : Bool = false
        
        private let launch : CDLaunch
        private var notificationCenter : UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        init(launch: CDLaunch) {
            self.launch = launch
            getPendingNotificationState()
        }
        
        func toggleNotification() {
            if hasPendingNotification {
                self.removePendingNotification()
            }
            else {
                self.addLaunchNotification()
            }
        }
        
        private func getPendingNotificationState() {
            notificationCenter.getPendingNotificationRequests { (pendingNotificationRequests: [UNNotificationRequest]) in
                DispatchQueue.main.async {
                    self.hasPendingNotification = pendingNotificationRequests.first(where: { (notificationRequest: UNNotificationRequest) -> Bool in
                        notificationRequest.identifier == self.launch.launchID
                    }) != Optional.none
                }
            }
        }
        
        private func addLaunchNotification() {
            SpaceXBuddy.logger.debug("Adding Notification Request")
            guard let launchID = self.launch.launchID, let launchDate = launch.localDate else {
                return
            }
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { (didAllow: Bool, error: Error?) in
                if didAllow {
                    let request = UNNotificationRequest(identifier: launchID, content: UNNotificationContent.build(from: self.launch), trigger: UNCalendarNotificationTrigger.build(from: launchDate))
                    
                    self.notificationCenter.add(request) { (error: Error?) in
                        DispatchQueue.main.async {
                            self.hasPendingNotification = (error == nil)
                        }
                    }
                }
                else {
                    SpaceXBuddy.logger.debug("User should be redirected to notification settings")
                    DispatchQueue.main.async {
                        self.notificationsDisabled = true
                    }
                }
            }
        }
        
        private func removePendingNotification() {
            SpaceXBuddy.logger.debug("Removing Notification Request")
            guard let launchID = self.launch.launchID else {
                return
            }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [launchID])
            hasPendingNotification = false
        }
    }
}


fileprivate extension UNNotificationContent {
    static func build(from launch: CDLaunch) -> UNNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "SpaceX Launch Reminder"
        notificationContent.body = "\(launch.name ?? "Unknown") is about to launch"
        notificationContent.sound = UNNotificationSound.default
        
        return notificationContent
    }
}

fileprivate extension UNCalendarNotificationTrigger {
    static func build(from launchDate: Date) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: launchDate)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }
}
