//
//  LaunchListItemView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 08. 26..
//

import SwiftUI

struct LaunchListItemView : View {
    var launch : CDLaunch
    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    var body: some View {
        HStack {
            LaunchBadgeView(imageURL: launch.links?.patch?.small)
            .frame(width: 60, height: 60, alignment: .center)
                
            VStack (alignment: .leading) {
                Text(launch.name ?? "Unknown")
                Text(dateFormatter.string(from: launch.localDate!))
                Spacer()
            }
            .font(.subheadline)
        }
    }
}
