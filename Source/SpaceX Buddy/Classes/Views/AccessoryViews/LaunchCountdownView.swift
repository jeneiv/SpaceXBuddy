//
//  LaunchCountdownView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 26..
//

import SwiftUI

struct LaunchCountdownView: View {
    @State private var currentCountdownText = ""
    
    var launchDate : Date
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        Text(currentCountdownText)
        .onReceive(timer) { timerDate in
            let componenets = CountdownHelper.timeComponenets(in: launchDate.timeIntervalSince(timerDate))
            currentCountdownText = "\(componenets.days) days \(componenets.hours) hours \(componenets.minutes) mins \(componenets.seconds) seconds"
        }
    }
}

struct LaunchCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchCountdownView(launchDate: Date(timeIntervalSinceNow: 320))
                .preferredColorScheme(.light)
            LaunchCountdownView(launchDate: Date(timeIntervalSinceNow: 801661))
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
