//
//  StationDetailView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 21/02/2024.
//

import SwiftUI
import MapKit

struct StationDetailView: View {
    @EnvironmentObject var bookStations: BookStations
    var station: Station
    @EnvironmentObject var clientLocation: Location
    @State var travelTime: Int = -1
    @State var travelDistance: Int = -1
    let formatter = DateFormatter()
    @StateObject var feedState = FeedState()
    
    func format(date:Date, format:String = "EEEE, d MMM") -> String {
        // Create Date Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func loadData() async {
        await feedState.fetchWeatherFeed(lat: Float(station.lat ?? 0), lon: Float(station.long ?? 0))
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
                            StationTopicView(text: station.price == -1 ? "--" : "\(station.price)€", condition: true, color: Color.white)
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
                    StationMapView(
                        selectedItem: .constant(AnnotationItem(id: station.id, lat: station.lat!, long: station.long!, station: station))
                    )
                    .frame(width: .infinity, height: 300)
                    // list de météos
                    ScrollView(.horizontal){
                        HStack{
                            if feedState.weatherReports != [] {
                                ForEach(feedState.weatherReports, id: \.self) { weatherReport in
                                    VStack{
                                        Image(systemName: weatherReport.weather.symbol)
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(weatherReport.temperature < -10.1 ? Color.cyan.opacity(0.6) : .gray.opacity(0.6))
                                            .background(weatherReport.temperature < -10.1 ? Color.cyan.opacity(0.2) : weatherReport.weather.color.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 100))
                                        Text("\(String(format: "%.1f", weatherReport.temperature))°")
                                            .foregroundColor( weatherReport.temperature < -5.1 ? Color.blue : weatherReport.temperature < 0.1 ? Color.cyan : weatherReport.temperature < 5.1 ? Color.green : weatherReport.temperature < 10.1 ? Color.gray :  weatherReport.temperature < 20.1 ? Color.orange :  Color.red)
                                        HStack{
                                            Text(WeekDayFR(rawValue:  format(date: weatherReport.date, format: "EEEE"))!.toFr)
                                            Text(format(date: weatherReport.date, format: "dd"))
                                        }
                                        Text(format(date: weatherReport.date, format: "HH:mm"))
                                    }.padding()
                                }
                            } else {
                                // Use a placeholder when data is not available
                                ForEach(0..<3, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 12.0)
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.placeholder)
                                }
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
                        StationTopicView(text: station.liftOpen == -1 || station.liftOpen == -1  ? station.lift == -1  ? "--" : "\(station.lift) remontées mécaniques" : "\(station.liftOpen) / \(station.lift) remontées mécaniques", condition: true, color: Color.white)
                        Spacer()
                    }
                    // km de piste du domain skiable
                    HStack{
                        Image(systemName: "figure.skiing.downhill")
                            .foregroundColor(.gray)
                        StationTopicView(text: station.slopeDistanceOpen == -1 || station.slopeDistance == -1  ? station.slopeDistance == -1  ? "--" : "\(station.slopeDistance) km de piste" : "\(station.slopeDistanceOpen) / \(station.slopeDistance) km de piste", condition: true, color: Color.white)
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
                        Text(station.contact.phone == "nan" && station.contact.email == "nan" ? "": "Contacts")
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Text(station.contact.phone == "nan" ? "": station.contact.phone)
                        Spacer()
                    }
                    HStack{
                        Text(station.contact.phone == "nan" ? "": station.contact.phone)
                        Link(station.contact.email == "nan" ? "":  station.contact.email, destination: URL(string: "mailto:\(station.contact.email)")!)
                        Spacer()
                    }
                }
                .padding(.leading)
                Spacer()
            }
            .navigationTitle(station.name)
            .task {
                do{
                    await loadData()
                }
            }
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
