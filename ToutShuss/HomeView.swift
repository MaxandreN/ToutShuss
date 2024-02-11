//
//  HomeView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

import SwiftUI

struct HomeView: View {
    
    enum Filter: String, CaseIterable, Identifiable {
        case filter, open, close
        var id: Self { self }
    }

    @StateObject var thisBookStations: BookStations = bookStations
    
    @State private var selectedFlavor: Filter = .filter
    @State private var search: String = ""
    @State private var searchIsActive: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Picker("Flavor", selection: $selectedFlavor) {
                        Text("Filter").tag(Filter.filter)
                        Text("Open").tag(Filter.open)
                        Text("Close").tag(Filter.close)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(thisBookStations.stations.filter { station in
                            station.name.lowercased().contains(search.lowercased()) || search.isEmpty
                        }) { station in
                            StationCardView(station: station) {
                                if let index = thisBookStations.stations.firstIndex(of: station) {
                                    thisBookStations.stations[index].setFavorite()
                                    thisBookStations.save()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Home")
            .searchable(text: $search, isPresented: $searchIsActive, prompt: "Search..")
        }
    }
}

#Preview {
    ContentView()
}

