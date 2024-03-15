//
//  FavoriteView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

import SwiftUI

struct FavoriteView: View {
    enum Filter: String, CaseIterable, Identifiable {
        case filter, open, close
        var id: Self { self }
    }
    
    @EnvironmentObject var bookStations: BookStations
    
    @State private var selectedFilter: Filter = .filter
    @State private var search: String = ""
    @State private var searchIsActive: Bool = false
    @State private var viewStations: [Station] = []
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Picker("Filter", selection: $selectedFilter) {
                        Text("Filtre").tag(Filter.filter)
                        Text("Ouvert").tag(Filter.open)
                        Text("Fermé").tag(Filter.close)
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                Text(search)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(bookStations.stations.indices, id: \.self) { index in
                            if (bookStations.stations[index].isFavorite){
                                StationCardView(station: bookStations.stations[index])
                            }
                           
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Favorite")
        }
    }
}

#Preview {
    FavoriteView()
}
