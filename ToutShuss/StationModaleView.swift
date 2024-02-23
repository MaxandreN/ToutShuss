//
//  StationModaleView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 21/02/2024.
//

import SwiftUI

struct StationModaleView: View {
    var station: Station
    @State var thisClientLocation: Location = clientLocation
    @State var travelTime: Int = -1
    @State var travelDistance: Int = -1
    let onFavoriteToggle: () -> Void
    @Binding var isShowingModal: Bool
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    // Image de la sataion
                    AsyncImage(url: URL(string: (station.galerie.cover)))
                    { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Nom de la station et nom du domaine skiable
                    VStack{
                        Text(station.name)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Text(station.domain ?? "")
                            .foregroundStyle(Color.gray)
                    }.padding(.horizontal)
                    Spacer()
                    
                    // Topic Ouvert / Fermé
                    StationTopicView(text: "\((station.isOpen ?? nil) == true ? "Ouvert" : "Fermé")", condition: (station.isOpen ?? nil) != nil, color: (station.isOpen ?? nil) == true ? Color.green: Color.red, fontColor: .white, fontWeight: .bold)
                }
                .padding()
                HStack{
                    // liste des Topics
                    VStack{
                        // distance de route
                        HStack{
                            Image(systemName: "map.fill")
                                .foregroundColor(.gray)
                            StationTopicView(text: travelDistance == -1 ? "?" : "\(travelDistance)km", condition: true, color: Color.white)
                            Spacer()
                        }
                        // nb remontées
                        HStack{
                            Image(systemName: "arrow.up.and.person.rectangle.portrait")
                                .foregroundColor(.gray)
                            StationTopicView(text: station.lift == -1 && station.lift == -1 ? "?" : "\(station.liftOpen) / \(station.lift) remontées mécaniques", condition: true, color: Color.white)
                            Spacer()
                        }
                        // km de piste du domain skiable
                        HStack{
                            Image(systemName: "figure.skiing.downhill")
                                .foregroundColor(.gray)
                            StationTopicView(text: station.slopeDistanceOpen == -1 && station.slopeDistance == -1 ? "?" : "\(station.slopeDistanceOpen)km / \(station.slopeDistance)km de piste", condition: true, color: Color.white)
                            Spacer()
                        }
                        // temps de trajet
                        HStack{
                            Image(systemName: "car.fill")
                                .foregroundColor(.gray)
                            StationTopicView(text: travelTime == -1 ? "?" : "\(secondsToHoursMinutesSeconds(travelTime)) de trajet", condition: true, color: Color.white)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "wallet.pass.fill")
                                .foregroundColor(.gray)
                            StationTopicView(text: station.price == -1 ? "?" : "\(station.price)€", condition: true, color: Color.white)
                            Spacer()
                        }
                        Spacer()
                    }.multilineTextAlignment(.trailing)
                    Spacer()
                    VStack{
                        Button(action: {
                            onFavoriteToggle()
                        }) {
                            Image(systemName: station.isFavorite ? "star.fill" : "star")
                                .foregroundColor(station.isFavorite ? .yellow : .gray)
                                .padding(.trailing)
                        }
                        Spacer()
                    }
                }.padding()
                Spacer()
                Button(action: {
                   //isShowingModal = false
                }) {
                    NavigationLink(destination: StationDetailView(station: station,travelTime: travelTime, travelDistance: travelDistance, onFavoriteToggle: onFavoriteToggle)){
                        HStack {
                            Image(systemName: "mountain.2.fill")
                                .foregroundColor(.white)
                                .padding(.trailing)
                            Text("Découvrir la station")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                        
                }
                .padding()
            }
        }
    }

}

#Preview {
    ContentView()
}

