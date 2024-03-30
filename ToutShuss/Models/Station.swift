//
//  Station.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//

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

struct StationDTO: Codable {
    let adresse, numinstallation, codepostal, nominstallation: String
    let newName: String
    let coordonnees: Coordonnees
    let depCode, depNom, regCode, regNom: String

    enum CodingKeys: String, CodingKey {
        case adresse, numinstallation, codepostal, nominstallation
        case newName = "new_name"
        case coordonnees
        case depCode = "dep_code"
        case depNom = "dep_nom"
        case regCode = "reg_code"
        case regNom = "reg_nom"
    }
}

struct Coordonnees: Codable {
    let lon, lat: Double
}


struct Station: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var name: String
    var lift: Int = -1
    var liftOpen: Int = -1
    var slopeDistance: Int = -1
    var slopeDistanceOpen: Int = -1
    var maxAltitude: Int = -1
    var minAltitude: Int = -1
    var galerie: Galerie = Galerie()
    var long: Double? = nil
    var lat: Double? = nil
    var domain: String? = nil
    var cityCode: Int = -1
    var contact: Contact = Contact()
    var isOpen:Bool = true
    var price: Float = -1
    var note: Int = -1
    var isFavorite: Bool
    var travelTime: Int = -1
    var travelDistance: Int = -1
    var events: [Event] = []
    var weatherReports: [WeatherReport]  = []
    var distance: Int = -1
    
    var location: CLLocationCoordinate2D? {
        if let longitude = long, let latitude = lat {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            return nil
        }
    }
    



    init(name: String, lift: Int = -1, liftOpen: Int = -1, slopeDistance: Int = -1, slopeDistanceOpen: Int = -1, maxAltitude: Int = -1, minAltitude: Int = -1, galerie: Galerie = Galerie(), long: Double? = nil, lat: Double? = nil, domain: String? = nil, cityCode: Int = -1, contact: Contact = Contact(), isOpen: Bool = true, price: Float = -1, note: Int = -1, isFavorite: Bool = false, events: [Event] = [], weatherReports: [WeatherReport] = []) {
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
            self.events = events
            self.weatherReports = weatherReports
        }
    
    mutating func toggleFavorite() {
        self.isFavorite = !isFavorite
    }
    
    
    
    func distance(fromLocation: CLLocation) -> Float {
        if ((lat != nil) && (long != nil)){
            let location = CLLocation(latitude: lat!, longitude: long!)
            return Float(location.distance(from: fromLocation)/1000)
        }
        return -1
    }
    
    func getTravelTime(clientLocation: Location, completion: @escaping (Int, Int) -> Void ) {
        if(self.travelTime == -1 && self.travelDistance == -1){
            guard let stationLocation = location else {
                completion(-1, -1)
                return
            }
            clientLocation.fetchTravelTime(from: clientLocation.location, to: stationLocation) { travelTimeInMinutes, distance in
                completion(travelTimeInMinutes, distance)
            }
        }else{
            completion(self.travelTime, self.travelDistance)
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
        for jsonStation in self.loadFile(){
            self.stations.append(
            Station(
                name: jsonStation.name,
                lift: jsonStation.lift,
                liftOpen: -1,
                slopeDistance: jsonStation.slopeDistance,
                slopeDistanceOpen: -1,
                maxAltitude: jsonStation.maxAltitude,
                minAltitude: jsonStation.minAltitude,
                galerie: Galerie(),
                long: jsonStation.long,
                lat: jsonStation.lat,
                domain: jsonStation.domain,
                cityCode: jsonStation.cityCode,
                contact: Contact(),
                isOpen: true,
                price: jsonStation.price,
                note: Int(jsonStation.note),
                isFavorite: false,
                events: [],
                weatherReports: []))
        }
       
        self.save()
    }
    
    func loadFile() -> [JsonStation]{
        guard let url = Bundle.main.url(forResource: "data_station_parser", withExtension: "json") else {
            print("json file not found")
            return []
        }
        if let data = try? Data(contentsOf: url),
           let jsonStations = try? JSONDecoder().decode([JsonStation].self, from: data){
                return jsonStations
        }else{
            print("données no conformes")
        }
        return []
    }
    
    func save() {
        if let donnees = try? JSONEncoder().encode(stations) {
            UserDefaults.standard.set(donnees, forKey: "stations")
        }
    }
    
    func toggleFavorite(station: Station) {
        if let index = stations.firstIndex(where: { $0.id == station.id }) {
            stations[index].toggleFavorite()
        }
    }
}

struct JsonStation: Decodable{
    var name: String
    var massif: String
    var minAltitude: Int
    var maxAltitude: Int
    var lift: Int
    var slopeNb: Int
    var slopeDistance: Int
    var slopeDistanceNordic: Int
    var note: Float
    var domain: String
    var price: Float
    var priceWeek: Float
    var long: Double
    var lat: Double
    var cityCode: Int
    
}

class ReadData: ObservableObject  {
    @Published var stations = [JsonStation]()
    
    init(){
        readJSONFile(forName: "data_station_parser")
    }
    
    func readJSONFile(forName name: String) {
        
            

    }
}


#Preview {
    ContentView()
}
