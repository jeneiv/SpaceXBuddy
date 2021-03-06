//
//  MainView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 02..
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Spacer()
                    Image("SpaceXLogo")
                        .frame(height: 80)
                        .shadow(radius: 10)
                    Spacer()
                }
                NavigationLink(destination: LaunchListView(launchListType: .upcoming)) {
                    Text("Upcoming Launches")
                }
                NavigationLink(destination: LaunchListView(launchListType: .past)) {
                    Text("Past Launches")
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .environment(\.managedObjectContext, SpaceXBuddy.PersistencyController.shared.viewContext)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .preferredColorScheme(.light)
                .environment(\.colorScheme, .light)

            MainView()
                .preferredColorScheme(.dark)
                .environment(\.colorScheme, .dark)
              }
    }
}
