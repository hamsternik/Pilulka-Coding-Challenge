//
//  ContentView.swift
//  Pilulka Coding Challenge
//
//  Created by Nikita Khomitsevych on 21.04.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            let networking = Network()
            let listViewModel = AircraftsListViewModel(network: networking)
            AircraftsListView(viewModel: listViewModel).tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
            AircraftsMapView().tabItem {
                Image(systemName: "map.circle.fill")
                Text("Map")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
