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
            Text("List of Available Aircrafts").tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }
            Text("Map of Available Aircrafts").tabItem {
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
