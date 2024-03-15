//
//  ContentView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 02/02/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bookStation: BookStations = BookStations()
    @ObservedObject var clientLocation: Location = Location(long: 6.11667, lat: 45.9)
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            MapView(selectedItem: .constant(nil))
                .tabItem() {
                    Image(systemName: "location.fill")
                    Text("Explore")
                }
            FavoriteView()
                .badge(bookStation.stations.filter { $0.isFavorite }.count)
                .tabItem() {
                    Image(systemName: "star.fill")
                    Text("Favorite")
                }
        }
        .accentColor(.purple)
        .environmentObject(bookStation)
        .environmentObject(clientLocation)
    }
}

#Preview {
    ContentView()
}
