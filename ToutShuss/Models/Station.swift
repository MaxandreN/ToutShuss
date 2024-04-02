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
    var email: String = "NaN"
    var phone: String = "NaN"
}

struct JsonContact: Decodable {
    var email: String = "NaN"
    var phone: String = "NaN"
    
    init(email: String = "NaN", phone: String = "NaN") {
        self.email = email
        self.phone = phone
    }
}

struct Galerie: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var cover: String = "https://img.freepik.com/photos-gratuite/portrait-belle-chaine-montagnes-recouverte-neige-sous-ciel-nuageux_181624-4974.jpg"
    var images: [String] = []
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
            self.contact = contact
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
        let json = self.loadFile()
        
        //si il y a un version en local
        if let loaclStationVersion = UserDefaults.standard.data(forKey: "jsonStationVersion"), let loaclStationVersionDecoded = try? JSONDecoder().decode(Int.self, from: loaclStationVersion){
            //si la version n'est pas la meme en local et dans le fichier json
            if(loaclStationVersionDecoded != json.version){
                
                saveFromFile(json: json)
                
            }else{
                //si l'on chage bien les données en local
                if let jsonStation = UserDefaults.standard.data(forKey: "Station"), let decoded = try? JSONDecoder().decode([Station].self, from: jsonStation) {
                    self.stations = decoded
                }else{
                    //si non on chage le fichier
                    saveFromFile(json: json)
                }
            }
        }else{
            //si il n'y a de version en local on chage les données du fichier
            saveFromFile(json: json)
        }
    }
    
    func saveFromFile(json:JsonFile){
        print("saveFromFile" + String(json.stations.count))
        self.setStations(NewListStations: json.getStation())
        if let donnees = try? JSONEncoder().encode(json.version) {
            UserDefaults.standard.set(donnees, forKey: "jsonStationVersion")
        }
        self.save()
    }
    
    func loadFile() -> JsonFile{
        guard let url = Bundle.main.url(forResource: "data_station_parser", withExtension: "json") else {
            print("json file not found")
            return JsonFile(version: 0, stations: [])
        }
        if let data = try? Data(contentsOf: url),
           let jsonFile = try? JSONDecoder().decode(JsonFile.self, from: data){
                return jsonFile
        }else{
            print("données no conformes")
            do {
                let data = try Data(contentsOf: url)
                _ = try JSONDecoder().decode(JsonFile.self, from: data)
            } catch {
                print("Error info: \(error)")
            }
        }
        return JsonFile(version: 0, stations: [])
    }
    
    func save() {
        if let donnees = try? JSONEncoder().encode(stations) {
            UserDefaults.standard.set(donnees, forKey: "Station")
        }
    }
    
    func toggleFavorite(station: Station) {
        if let index = stations.firstIndex(where: { $0.id == station.id }) {
            stations[index].toggleFavorite()
        }
        self.save()
    }
}

struct JsonFile: Decodable{
    var version : Int
    var stations: [JsonStation]
    
    func getStation() -> [Station]{
        var stations: [Station] = []
        for jsonStation in self.stations{
            stations.append(
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
                    contact: jsonStation.getContact(),
                    isOpen: true,
                    price: jsonStation.price,
                    note: Int(jsonStation.note),
                    isFavorite: false,
                    events: jsonStation.getEvents(),
                    weatherReports: []
                )
            )
        }
        return stations
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
    var event: [JsonEvent]
    var contact : JsonContact = JsonContact()
    
    func getEvents() -> [Event]{
        var events: [Event] = []
        
        for event in self.event{
            events.append(event.getEvent())
        }
        return events
    }
    
    func getContact() -> Contact{
        var contact: Contact = 
            Contact(
                email: self.contact.email,
                phone: self.contact.phone
            )
        return contact
    }
        
    init(name: String, massif: String, minAltitude: Int, maxAltitude: Int, lift: Int, slopeNb: Int, slopeDistance: Int, slopeDistanceNordic: Int, note: Float, domain: String, price: Float, priceWeek: Float, long: Double, lat: Double, cityCode: Int, event: [JsonEvent], contact: JsonContact) {
        self.name = name
        self.massif = massif
        self.minAltitude = minAltitude
        self.maxAltitude = maxAltitude
        self.lift = lift
        self.slopeNb = slopeNb
        self.slopeDistance = slopeDistance
        self.slopeDistanceNordic = slopeDistanceNordic
        self.note = note
        self.domain = domain
        self.price = price
        self.priceWeek = priceWeek
        self.long = long
        self.lat = lat
        self.cityCode = cityCode
        self.event = event.count > 1 ? event : []
        self.contact = contact
    }
}

#Preview {
    ContentView()
}
