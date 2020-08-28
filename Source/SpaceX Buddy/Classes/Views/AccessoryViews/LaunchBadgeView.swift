//
//  LaunchBadgeView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 02..
//

import SwiftUI

struct LaunchBadgeView: View {
    let imageURL : String?
    
    @ViewBuilder
    var body: some View {
        if let badgeURL = imageURL {
            AsyncImageView(url: URL(string: badgeURL)!)
                .shadow(radius: 3)
                .scaleEffect(0.85, anchor: .center)
        }
        else {
            Image("spaceship_flying")
                .resizable()
                .shadow(radius: 3)
                .scaleEffect(0.85, anchor: .center)
        }
    }
}

/*
struct MyShape : Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

        p.addArc(center: CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0),
                 radius: min(rect.size.width, rect.size.height) / 2.0 * 0.95,
                 startAngle: .degrees(0),
                 endAngle: .degrees(360),
                 clockwise: true)

        return p.strokedPath(StrokeStyle.init(lineWidth: 3, dash: [1.5, 6], dashPhase: 10))
    }
}
*/

struct LaunchBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LaunchBadgeView(imageURL: Optional.none)
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 400, height: 400))
            
            LaunchBadgeView(imageURL: Optional.none)
                .preferredColorScheme(.light)
                .previewLayout(.fixed(width: 400, height: 400))
            
            LaunchBadgeView(imageURL: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 400, height: 400))
            
            LaunchBadgeView(imageURL: "https://images2.imgbox.com/be/e7/iNqsqVYM_o.png")
                .preferredColorScheme(.light)
                .previewLayout(.fixed(width: 400, height: 400))

        }
    }
}
