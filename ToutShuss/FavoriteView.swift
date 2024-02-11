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
    
    @StateObject var thisBookStations: BookStations = bookStations
    
    @State private var selectedFilter: Filter = .filter
    @State private var search: String = ""
    @State private var searchIsActive: Bool = false
    @State private var viewStations: [Station] = []
    
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
                Text(search)
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(thisBookStations.stations.indices, id: \.self) { index in
                            if (thisBookStations.stations[index].isFavorite){
                                StationCardView(station: thisBookStations.stations[index]) {
                                    thisBookStations.stations[index].setFavorite()
                                    thisBookStations.save()
                                }
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
