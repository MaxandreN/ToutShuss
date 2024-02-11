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
                        ForEach(thisBookStations.stations.indices, id: \.self) { index in
                            if (thisBookStations.stations[index].name.lowercased().contains(search.lowercased()) || search.isEmpty){
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
            .navigationTitle("Home")
            .searchable(text: $search, isPresented: $searchIsActive, prompt: "Search..")
        }
    }
}


struct StationCardView: View {
    let station: Station
    @State var thisClientLocation: Location = clientLocation
    @State var travelTime: Int = 0
    @State var travelDistance: Int = 0
    let onFavoriteToggle: () -> Void

    var body: some View {
        VStack {
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
            HStack{
                Text("\(secondsToHoursMinutesSeconds(travelTime))")
                Text("\(travelDistance)km")
                    .onAppear {
                        // Lorsque la vue apparaît, récupérer le temps de trajet
                        station.getTravelTime(clientCoordinate: thisClientLocation.location) { travelTime, travelDistance in
                            self.travelTime = travelTime
                            self.travelDistance = travelDistance
                        }
                    }
                
            }.padding(.bottom)
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    func secondsToHoursMinutesSeconds(_ time: Int) -> (String) {
        let h: Int = (time / 60)
        let m: Int = (time % 60) % 60
        return ("\(h)h\(m)")
    }
}



#Preview {
    ContentView()
}

