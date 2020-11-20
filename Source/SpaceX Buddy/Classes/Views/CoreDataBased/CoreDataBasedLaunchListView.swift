//
//  CoreDataBasedLaunchListView.swift
//  SpaceX Buddy
//
//  Created by Jenei Viktor on 2020. 10. 29..
//

import SwiftUI

struct CoreDataBasedLaunchListView: View {
    @Environment(\.managedObjectContext) var viewContext

    // NOTE: you can also go with this solution, but then you can't configure the fetch request
    // @FetchRequest(entity: CDLaunch.entity(), sortDescriptors: [], predicate: Optional.none)
    // var launches: FetchedResults<CDLaunch>

    @FetchRequest<CDLaunch> private var launches: FetchedResults<CDLaunch>
    @ObservedObject var viewModel : SpaceXBuddy.StoredLaunchesViewModel

    enum LaunchListType {
        case upcoming
        case past
    }
    
    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }
    
    init(launchListType: LaunchListType) {
        self._launches = FetchRequest<CDLaunch>.launchFetchReqest(launchListType: launchListType)
        self.viewModel = SpaceXBuddy.StoredLaunchesViewModel(dataType: launchListType == .past ? .past : .upcoming)
    }
    
    var body: some View {
        List (launches) { launch in
            NavigationLink(destination: CoreDataBasedLaunchDetailsView(launch: launch)) {
                LaunchListItemView(launch: launch)
            }
        }
        .navigationBarTitle(viewModel.screenTitle())
        .onAppear() {
            viewModel.fetch()
        }
        .onDisappear() {
            viewModel.cancel()
        }
    }
}

struct CoreDataBasedLaunchListView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataBasedLaunchListView(launchListType: .past)
    }
}
