//
//  Station.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

import Foundation
import SwiftUI

struct Station: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var name: String
    var lift: Int?
    var maxAltitude: Int?
    var minAltitude: Int?
    var image: String?
    var long: Float?
    var lat: Float?
    var isFavorite: Bool = false
    var travelTime: Int?
    
    mutating func setFavorite() {
        self.isFavorite = !isFavorite
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
            if(objets.count > 1){
                setStations(NewListStations: objets)
            }
            else
            {
                setStations(NewListStations:
                                [
                                    Station(name: "Val d'Isère", lift: 50, maxAltitude: 3456, minAltitude: 1850, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.9774, lat: 45.4489, travelTime: 120),
                                    Station(name: "Tignes", lift: 39, maxAltitude: 3656, minAltitude: 1550, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.9032, lat: 45.4698, travelTime: 110),
                                    Station(name: "Les Arcs", lift: 53, maxAltitude: 3226, minAltitude: 810, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.7699, lat: 45.5726, travelTime: 100),
                                    Station(name: "La Plagne", lift: 65, maxAltitude: 3250, minAltitude: 1250, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.7317, lat: 45.5063, travelTime: 130),
                                    Station(name: "Les Menuires", lift: 47, maxAltitude: 2850, minAltitude: 1450, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.5387, lat: 45.3208, travelTime: 90),
                                    Station(name: "Val Thorens", lift: 31, maxAltitude: 3570, minAltitude: 2300, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.5809, lat: 45.2983, travelTime: 120),
                                    Station(name: "La Rosière", lift: 31, maxAltitude: 2650, minAltitude: 1200, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.8800, lat: 45.6279, travelTime: 100),
                                    Station(name: "Les Gets", lift: 48, maxAltitude: 2002, minAltitude: 1172, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.6660, lat: 46.1610, travelTime: 80),
                                    Station(name: "Morzine", lift: 52, maxAltitude: 2002, minAltitude: 1000, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.7086, lat: 46.1783, travelTime: 60),
                                    Station(name: "Avoriaz", lift: 51, maxAltitude: 2466, minAltitude: 1800, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.7736, lat: 46.1958, travelTime: 110),
                                    Station(name: "Chamonix-Mont-Blanc", lift: 45, maxAltitude: 3842, minAltitude: 1035, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.8656, lat: 45.9237, travelTime: 60),
                                    Station(name: "Flaine", lift: 26, maxAltitude: 2500, minAltitude: 1600, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.6792, lat: 46.0056, travelTime: 90),
                                    Station(name: "Les Contamines-Montjoie", lift: 48, maxAltitude: 2487, minAltitude: 1150, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.7260, lat: 45.8222, travelTime: 80),
                                    Station(name: "Chatel", lift: 43, maxAltitude: 2200, minAltitude: 1000, image: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q=", long: 6.8423, lat: 46.2673, isFavorite: true, travelTime: 110),
                                ]
                )
            }
        }
    }
    
    // Fonction pour sauvegarder les données
    func save() {
        if let donnees = try? JSONEncoder().encode(stations) {
            UserDefaults.standard.set(donnees, forKey: "stations")
        }
    }
}

var bookStations: BookStations = BookStations()



#Preview {
    HomeView()
}