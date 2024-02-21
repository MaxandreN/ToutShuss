//
//  ContentView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 02/02/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var thisBookStation: BookStations = bookStations
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            MapView(annotationsItems: annotationItemsFromRawRegion, selectedItem: .constant(nil))
                .tabItem() {
                    Image(systemName: "location.fill")
                    Text("Explore")
                }
            FavoriteView()
                .badge(thisBookStation.stations.filter { $0.isFavorite }.count)
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
