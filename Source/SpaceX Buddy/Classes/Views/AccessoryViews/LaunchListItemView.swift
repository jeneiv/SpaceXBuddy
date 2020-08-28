//
//  LaunchListItemView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 26..
//

import SwiftUI

struct LaunchListItemView : View {
    var launch : SpaceXBuddy.Launch
    
    var body: some View {
        HStack {
            LaunchBadgeView(imageURL: launch.links?.patch.small)
            .frame(width: 60, height: 60, alignment: .center)
                
            VStack (alignment: .leading) {
                Text(launch.name)
                Text(launch.humanReadableDate)
                Spacer()
            }
            .font(.subheadline)
        }
    }
}
