//
//  ContentView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 02/02/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bookStations: BookStations = BookStations()
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            MapView()
                .tabItem() {
                    Image(systemName: "location.fill")
                    Text("Explore")
                }
            FavoriteView()
                .badge(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .tabItem() {
                    Image(systemName: "star.fill")
                    Text("Favorite")
                }
        }
    }
}

#Preview {
    ContentView()
}
