//
//  StationDetailView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 21/02/2024.
//

import SwiftUI

struct StationDetailView: View {
    @EnvironmentObject var bookStations: BookStations
    var station: Station
    @State var thisClientLocation: Location = clientLocation
    @State var travelTime: Int = -1
    @State var travelDistance: Int = -1
    let formatter = DateFormatter()
    
    func format(date:Date, format:String = "EEEE, d MMM") -> String {
        // Create Date Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    VStack{
                        HStack{
                            Text(station.domain ?? "")
                            Spacer()
                        }.padding(.leading)
                            .padding(.bottom)
                        
                        HStack{
                            Stars(note: station.note)
                            Spacer()
                        }.padding(.leading)
                    }
                    VStack{
                        // ajouter/retirer des favorits
                        Button(action: {
                            bookStations.toggleFavorite(station:station)
                        }) {
                            Spacer()
                            Image(systemName: station.isFavorite ? "star.fill" : "star")
                                .foregroundColor(station.isFavorite ? .yellow : .gray)
                                .padding(.trailing)
                        }
                        // prix dud forfait
                        HStack{
                            Spacer()
                            Image(systemName: "wallet.pass.fill")
                                .foregroundColor(.gray)
                            StationTopicView(text: station.price == -1 ? "?" : "\(station.price)€", condition: true, color: Color.white)
                        }
                    }
                }
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: .infinity, height: 2)
                // list des images
                ScrollView(.horizontal){
                    HStack{
                        AsyncImage(url: URL(string: (station.galerie.cover)))
                        { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }.padding()
                        ForEach(station.galerie.images, id: \.self) { image in
                            AsyncImage(url: URL(string: (image)))
                            { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }.padding()
                        }
                    }.frame(height: 200)
                }
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: .infinity, height: 2)
                
                VStack{
                    // tremps de trajet
                    VStack{
                        HStack{
                            Image(systemName: "map.fill")
                                .foregroundColor(.gray)
                            StationTopicView(text: travelDistance == -1 ? "?" : "\(travelDistance)km de trajet", condition: true, color: Color.white)
                            Spacer()
                        }.padding(.leading)
                    }
                    //afficher la map
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: .infinity, height: 300)
                    // list de météos
                    ScrollView(.horizontal){
                        
                        HStack{
                            ForEach(station.weatherReports, id: \.self) { weatherReport in
                                VStack{
                                    Image(systemName: weatherReport.weather.symbol)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray.opacity(0.6))
                                        .background(weatherReport.weather.color.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 100))
                                    Text(format(date: weatherReport.date, format: "EEEE"))
                                    Text("\(String(format: "%.1f", weatherReport.temperature))°")
                                }.padding()
                            }
                            
                        }
                       
                    }
                }
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: .infinity, height: 2)
                
                //List d'evenement
                Text("Events to come")
                ForEach(station.events, id: \.self) { event in
                    HStack{
                        Image(systemName: event.activity.rawValue)
                            .foregroundColor(event.pricing.color)
                            .padding(.leading)
                        Text("\(format(date: event.date)) : \(event.name)")
                        Spacer()
                    }
                        .frame(width: 350, height: 40)
                        .background(event.pricing.color.opacity(0.2))
                }
               
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: .infinity, height: 2)
                    .padding(.top)
                    .padding(.bottom)
                VStack{
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
                }.padding(.leading)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: .infinity, height: 2)
                    .padding(.bottom)
                
                //affichage du contact
                VStack(alignment: .leading){
                    HStack{
                        Text("Contacts")
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Text(station.contact.phone)
                        Spacer()
                    }
                    HStack{
                        Link(station.contact.email, destination: URL(string: "mailto:\(station.contact.email)")!)
                        Spacer()
                    }
                }
                .padding(.leading)
                Spacer()
            }
            .navigationTitle(station.name)
        }
    }
}


struct Stars: View {
    var note:Int
    var body: some View{
        ForEach((1...5), id: \.self) {
            Image(systemName: note >= $0 ? "star.fill" : "star")
                    .foregroundColor(note >= $0 ? .yellow : .gray)
        }

        
    }
}

#Preview {
    ContentView()
}
