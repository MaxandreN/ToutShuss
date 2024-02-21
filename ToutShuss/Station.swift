//
//  Station.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

import Foundation
import SwiftUI
import MapKit

struct Contact: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var email: String = "nan"
    var phone: String = "nan"
}

struct Galerie: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var cover: String = "https://img.freepik.com/photos-gratuite/portrait-belle-chaine-montagnes-recouverte-neige-sous-ciel-nuageux_181624-4974.jpg"
    var images: [String] = []
}


struct Station: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var name: String
    var lift: Int
    var liftOpen: Int
    var slopeDistance: Int
    var slopeDistanceOpen: Int
    var maxAltitude: Int
    var minAltitude: Int
    var galerie: Galerie
    var long: Double?
    var lat: Double?
    var domain: String?
    var cityCode: Int
    var contact: Contact
    var isOpen:Bool?
    var price: Int
    var note: Int
    var isFavorite: Bool
    var travelTime: Int = -1
    var travelDistance: Int = -1
    
    var location: CLLocationCoordinate2D? {
            if let longitude = long, let latitude = lat {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                return nil
            }
        }
    
    init(name: String, lift: Int = -1, liftOpen: Int = -1, slopeDistance: Int = -1, slopeDistanceOpen: Int = -1, maxAltitude: Int = -1, minAltitude: Int = -1, galerie: Galerie = Galerie(), long: Double? = nil, lat: Double? = nil, domain: String? = nil, cityCode: Int = -1, contact: Contact = Contact(), isOpen: Bool? = nil, price: Int = -1, note: Int = -1, isFavorite: Bool = false) {
            self.name = name
            self.lift = lift
            self.liftOpen = liftOpen
            self.slopeDistance = slopeDistance
            self.slopeDistanceOpen = slopeDistanceOpen
            self.maxAltitude = maxAltitude
            self.minAltitude = minAltitude
            self.galerie = galerie
            self.long = long
            self.lat = lat
            self.domain = domain
            self.cityCode = cityCode
            self.contact = contact
            self.isOpen = isOpen
            self.price = price
            self.note = note
            self.isFavorite = isFavorite
        }
    
    mutating func setFavorite() {
        self.isFavorite = !isFavorite
    }
    
    func getTravelTime(clientCoordinate: CLLocationCoordinate2D, completion: @escaping (Int, Int) -> Void ) {
        print(self.travelTime, self.travelDistance)
        if(self.travelTime == -1 && self.travelDistance == -1){
            guard let stationLocation = location else {
                completion(-1, -1)
                return
            }
            print("call")
            fetchTravelTime(from: clientCoordinate, to: stationLocation) { travelTimeInMinutes, distance in
                completion(travelTimeInMinutes, distance)
            }
        }else{
            print("get")
            completion(self.travelTime, self.travelDistance)
        }
        
    }
    
    private func fetchTravelTime(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (Int, Int) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.requestsAlternateRoutes = true
        directionRequest.transportType = .automobile // You can change this to .walking or .transit if needed
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error)")
                }
                completion(-1, -1)
                return
            }
            
            if let route = response.routes.first {
                let travelTimeInMinutes = Int(route.expectedTravelTime / 60)
                let distance = Int(route.distance / 1000)
                completion(travelTimeInMinutes, distance)
            } else {
                completion(-1, -1)
            }
        }
    }
}


class BookStations: ObservableObject {
    @Published var stations: [Station] = []
    
    init() {
        load()
    }
    
    func setStations(NewListStations: [Station]){
        stations = NewListStations
    }
    
    func load() {
        if let donnees = UserDefaults.standard.data(forKey: "stations"),
           let objets = try? JSONDecoder().decode([Station].self, from: donnees) {
                setStations(NewListStations: objets)

        }else{
            setStations(NewListStations:
                            [
                                Station(name: "Val d'Isère", lift: 50, maxAltitude: 3456, minAltitude: 1850),
                                Station(
                                    name: "Tignes",
                                    lift: 39,
                                    liftOpen: 30, // Exemple : 30 remontées mécaniques ouvertes
                                    slopeDistance: 300,
                                    slopeDistanceOpen: 200, // Exemple : 200 km de pistes ouvertes
                                    maxAltitude: 3656,
                                    minAltitude: 1550,
                                    galerie: Galerie(
                                        cover: "https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcR793g2Z8wbHNeemPQk63B0trZftF7hfemC1Dg5AAKWGDe4OB5dkahjjc1R8XnJSMnQe86M1fLoDRw5n6TaTiDPKm1afIg3quFbLDQnrA"),
                                    long: 6.9032,
                                    lat: 45.4698,
                                    domain: "Espace Killy",
                                    isOpen: true, // Exemple : la station est ouverte
                                    price: 50, // Exemple : prix du forfait de ski 50 euros
                                    isFavorite: false
                                ),
                                Station(
                                    name: "Les Arcs",
                                    lift: 53,
                                    liftOpen: 45, // Exemple : 45 remontées mécaniques ouvertes
                                    slopeDistance: 200,
                                    slopeDistanceOpen: 150, // Exemple : 150 km de pistes ouvertes
                                    maxAltitude: 3226,
                                    minAltitude: 810,
                                    galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="),
                                    long: 6.7699,
                                    lat: 45.5726,
                                    domain: "Paradiski",
                                    isOpen: false, // Exemple : la station est fermé
                                    price: 55, // Exemple : prix du forfait de ski 55 euros
                                    isFavorite: false
                                ),
                                Station(name: "La Plagne", lift: 65, maxAltitude: 3250, minAltitude: 1250, galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="), long: 6.7317, lat: 45.5063, domain: "Paradiski"),
                                Station(name: "Les Menuires", lift: 47, maxAltitude: 2850, minAltitude: 1450, galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="), long: 6.5387, lat: 45.3208, domain: "Les 3 Vallées"),
                                Station(name: "Val Thorens", lift: 31, maxAltitude: 3570, minAltitude: 2300, galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="), long: 6.5809, lat: 45.2983, domain: "Les 3 Vallées"),
                                Station(name: "La Rosière", lift: 31, maxAltitude: 2650, minAltitude: 1200, galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="), long: 6.8800, lat: 45.6279, domain: "Espace San Bernardo"),
                                Station(name: "Les Gets", lift: 48, maxAltitude: 2002, minAltitude: 1172, galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="), long: 6.6660, lat: 46.1610, domain: "Les Portes du Soleil"),
                                Station(name: "Morzine", lift: 52, maxAltitude: 2002, minAltitude: 1000, galerie: Galerie(
                                        cover:  "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="), long: 6.7086, lat: 46.1783, domain: "Les Portes du Soleil"),
                                Station(name: "Avoriaz", lift: 51, maxAltitude: 2466, minAltitude: 1800, galerie: Galerie(), long: 6.7736, lat: 46.1958, domain: "Les Portes du Soleil"),
                                Station(name: "Chamonix-Mont-Blanc", lift: 45, maxAltitude: 3842, minAltitude: 1035, galerie: Galerie(), long: 6.8656, lat: 45.9237, domain: "Chamonix"),
                                Station(name: "Flaine", lift: 26, maxAltitude: 2500, minAltitude: 1600, galerie: Galerie(), long: 6.6792, lat: 46.0056, domain: "Grand Massif"),
                                Station(name: "Les Contamines-Montjoie", lift: 48, maxAltitude: 2487, minAltitude: 1150, galerie: Galerie(), long: 6.7260, lat: 45.8222, domain: "Evasion Mont-Blanc"),
                                Station(name: "Chatel", lift: 43, maxAltitude: 2200, minAltitude: 1000, galerie: Galerie(), long: 6.8423, lat: 46.2673, domain: "Portes du Soleil", isFavorite: true)
                            ]

            )
        }
    }
    
    func save() {
        if let donnees = try? JSONEncoder().encode(stations) {
            UserDefaults.standard.set(donnees, forKey: "stations")
        }
    }
}

var bookStations: BookStations = BookStations()


