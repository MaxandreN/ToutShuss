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
    
    @StateObject var bookStations: BookStations = BookStations()

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
                        ForEach(bookStations.stations.indices, id: \.self) { index in
                            StationCardView(station: bookStations.stations[index]) {
                                bookStations.stations[index].setFavorite()
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
    
    var searchResults: BookStations {
        if search.isEmpty {
            return bookStations
        } else {
            return bookStations.filterStations(with: search)
        }
    }
}


struct StationCardView: View {
    let station: Station
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack {
//            Image(stationName)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: 200)
//                .clipped()
           
            AsyncImage(url: URL(string: "https://img.freepik.com/photos-gratuite/portrait-belle-chaine-montagnes-recouverte-neige-sous-ciel-nuageux_181624-4974.jpg"))
            { image in
               image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
           } placeholder: {
               ProgressView()
           }.frame(height: 180)
               .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack {
                
                Text(station.name)
                    .font(.title)
                    .padding(.leading, 10)
                
                Spacer()
                
                Button(action: {
                    onFavoriteToggle()
                }) {
                    Image(systemName: station.isFavorite ? "star.fill" : "star")
                        .foregroundColor(station.isFavorite ? .yellow : .gray)
                        .padding()
                }
            }
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}



#Preview {
    HomeView()
}

