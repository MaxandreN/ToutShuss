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

    @EnvironmentObject var bookStations: BookStations
    @EnvironmentObject var clientLocation: Location
    
    @State private var selectedFilter: Filter = .filter
    @State private var search: String = ""
    @State private var searchIsActive: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Picker("Filter", selection: $selectedFilter) {
                        Text("Filter").tag(Filter.filter)
                        Text("Open").tag(Filter.open)
                        Text("Close").tag(Filter.close)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(bookStations.stations.filter { station in
                            station.name.lowercased().contains(search.lowercased()) || search.isEmpty
                        }) { station in
                            StationCardView(station: station) 
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            .navigationTitle("Home")
            .searchable(text: $search, isPresented: $searchIsActive, prompt: "Search..")
        }
        .environmentObject(bookStations)
        .environmentObject(clientLocation)
    }
}

#Preview {
    ContentView()
}

