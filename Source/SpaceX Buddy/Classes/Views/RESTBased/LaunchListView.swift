//
//  LaunchListView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 07. 17..
//

import SwiftUI

/// REST API Based Launch List View
struct LaunchListView: View {
    @ObservedObject var viewModel : SpaceXBuddy.LaunchesViewModel
    
    var body: some View {
        ZStack {
            List (viewModel.launches) { launch in
                NavigationLink(destination: LaunchDetailsView(launch: launch)) {
                    LaunchListItemView(launch: launch)
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationBarTitle(viewModel.dataType.navigationTitle())
        .onAppear {
            viewModel.fetch()
        }
        .onDisappear {
            viewModel.cancel()
        }
    }
}

extension SpaceXBuddy.Launch {
    var humanReadableDate : String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return df.string(from: self.localDate)
    }
}
