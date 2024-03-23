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
    var events: [Event]
    var weatherReports: [WeatherReport]
    
    var location: CLLocationCoordinate2D? {
            if let longitude = long, let latitude = lat {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                return nil
            }
        }
    
    init(name: String, lift: Int = -1, liftOpen: Int = -1, slopeDistance: Int = -1, slopeDistanceOpen: Int = -1, maxAltitude: Int = -1, minAltitude: Int = -1, galerie: Galerie = Galerie(), long: Double? = nil, lat: Double? = nil, domain: String? = nil, cityCode: Int = -1, contact: Contact = Contact(), isOpen: Bool? = nil, price: Int = -1, note: Int = -1, isFavorite: Bool = false, events: [Event] = [], weatherReports: [WeatherReport] = []) {
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
        if let donnees = UserDefaults.standard.data(forKey: "stations"),
           let objets = try? JSONDecoder().decode([Station].self, from: donnees), false {
                setStations(NewListStations: objets)
        }else{
            setStations(NewListStations:
                            [
                                Station(
                                        name: "Val d'Isère",
                                        lift: 50,
                                        liftOpen: 45,
                                        slopeDistance: 300,
                                        slopeDistanceOpen: 250,
                                        maxAltitude: 3456,
                                        minAltitude: 1850,
                                        galerie: Galerie(
                                            cover: "https://img.freepik.com/photos-gratuite/portrait-belle-chaine-montagnes-recouverte-neige-sous-ciel-nuageux_181624-4974.jpg",
                                            images: []
                                        ),
                                        long: 6.9815,
                                        lat: 45.4482,
                                        domain: "Espace Killy",
                                        cityCode: 73210,
                                        contact: Contact(
                                            email: "valdisere@example.com",
                                            phone: "+33 4 79 06 06 60"
                                        ),
                                        isOpen: true,
                                        price: 60,
                                        note: 4,
                                        isFavorite: true,
                                        events: [
                                            Event(name: "Ski Contest", date: Date().addingTimeInterval(86400 * 10), activity: .competition, pricing: .paid),
                                            Event(name: "Snowboard Demo", date: Date().addingTimeInterval(86400 * 15), activity: .snowboard, pricing: .free),
                                            Event(name: "Party", date: Date().addingTimeInterval(86400 * 27), activity: .party, pricing: .free)
                                        ],
                                        weatherReports: [
                                            WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -2.0, altitude: 1850),
                                            WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Clouds, temperature: -1.5, altitude: 1850),
                                            WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Rain, temperature: 1.0, altitude: 1850),
                                            WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Snow, temperature: -3.0, altitude: 1850)
                                        ]
                                    ),
                                    Station(
                                        name: "Tignes",
                                        lift: 39,
                                        liftOpen: 30,
                                        slopeDistance: 300,
                                        slopeDistanceOpen: 200,
                                        maxAltitude: 3656,
                                        minAltitude: 1550,
                                        galerie: Galerie(
                                            cover: "https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcR793g2Z8wbHNeemPQk63B0trZftF7hfemC1Dg5AAKWGDe4OB5dkahjjc1R8XnJSMnQe86M1fLoDRw5n6TaTiDPKm1afIg3quFbLDQnrA",
                                            images: [
                                                "https://static.savoie-mont-blanc.com/wp-content/uploads/external/64ce8e3b102d3364c80552085bce1554-14033086-1407x940.jpg",
                                                "https://www.tignes.net/uploads/media/page/0001/60/a252b3504398928aa2256d28c4886026c435c908.jpeg"
                                            ]
                                        ),
                                        long: 6.9032,
                                        lat: 45.4698,
                                        domain: "Espace Killy",
                                        cityCode: 73320,
                                        contact: Contact(
                                            email: "tignes@example.com",
                                            phone: "+33 4 79 40 04 40"
                                        ),
                                        isOpen: true,
                                        price: 55,
                                        note: 4,
                                        isFavorite: false,
                                        events: [
                                            Event(name: "Ski Show", date: Date().addingTimeInterval(86400 * 8), activity: .ski, pricing: .free)
                                        ],
                                        weatherReports: [
                                            WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -1.5, altitude: 1550),
                                            WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .partlyCloudyDay, temperature: -1.0, altitude: 1550),
                                            WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Clouds, temperature: 0.5, altitude: 1550)
                                        ]
                                    ),
                                Station(
                                    name: "Les Arcs",
                                    lift: 53,
                                    liftOpen: 45,
                                    slopeDistance: 200,
                                    slopeDistanceOpen: 150,
                                    maxAltitude: 3226,
                                    minAltitude: 810,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.7699,
                                    lat: 45.5726,
                                    domain: "Paradiski",
                                    cityCode: 73700,
                                    contact: Contact(
                                        email: "lesarcs@example.com",
                                        phone: "+33 4 79 07 12 57"
                                    ),
                                    isOpen: false,
                                    price: 55,
                                    note: 3,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Snowboard Competition", date: Date().addingTimeInterval(86400 * 5), activity: .competition, pricing: .paid)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -1.0, altitude: 810),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Clouds, temperature: -0.5, altitude: 810),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Snow, temperature: -2.0, altitude: 810)
                                    ]
                                ),
                                Station(
                                    name: "La Plagne",
                                    lift: 65,
                                    liftOpen: 50,
                                    slopeDistance: 250,
                                    slopeDistanceOpen: 200,
                                    maxAltitude: 3250,
                                    minAltitude: 1250,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.7317,
                                    lat: 45.5063,
                                    domain: "Paradiski",
                                    cityCode: 73210,
                                    contact: Contact(
                                        email: "laplagne@example.com",
                                        phone: "+33 4 79 09 79 79"
                                    ),
                                    isOpen: true,
                                    price: 60,
                                    note: 4,
                                    isFavorite: true
                                ),
                                Station(
                                    name: "Les Menuires",
                                    lift: 47,
                                    liftOpen: 42,
                                    slopeDistance: 220,
                                    slopeDistanceOpen: 180,
                                    maxAltitude: 2850,
                                    minAltitude: 1450,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.5387,
                                    lat: 45.3208,
                                    domain: "Les 3 Vallées",
                                    cityCode: 73440,
                                    contact: Contact(
                                        email: "lesmenuires@example.com",
                                        phone: "+33 4 79 00 62 75"
                                    ),
                                    isOpen: true,
                                    price: 55,
                                    note: 4,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Ski Lessons", date: Date().addingTimeInterval(86400 * 3), activity: .ski, pricing: .paid),
                                        Event(name: "Après-ski Party", date: Date().addingTimeInterval(86400 * 8), activity: .cycle, pricing: .free)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .Clouds, temperature: -2.0, altitude: 1450),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .sunny, temperature: -1.5, altitude: 1450),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Rain, temperature: 1.0, altitude: 1450),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Snow, temperature: -3.0, altitude: 1450)
                                    ]
                                ),
                                Station(
                                    name: "Val Thorens",
                                    lift: 31,
                                    liftOpen: 28,
                                    slopeDistance: 250,
                                    slopeDistanceOpen: 200,
                                    maxAltitude: 3570,
                                    minAltitude: 2300,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.5809,
                                    lat: 45.2983,
                                    domain: "Les 3 Vallées",
                                    cityCode: 73440,
                                    contact: Contact(
                                        email: "valthorens@example.com",
                                        phone: "+33 4 79 00 08 08"
                                    ),
                                    isOpen: true,
                                    price: 65,
                                    note: 4,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Ski Marathon", date: Date().addingTimeInterval(86400 * 5), activity: .ski, pricing: .paid),
                                        Event(name: "Snowboard Contest", date: Date().addingTimeInterval(86400 * 10), activity: .snowboard, pricing: .free)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -5.0, altitude: 2300),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Clouds, temperature: -4.5, altitude: 2300),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Rain, temperature: -1.0, altitude: 2300),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Snow, temperature: -6.0, altitude: 2300)
                                    ]
                                ),
                                Station(
                                    name: "La Rosière",
                                    lift: 31,
                                    liftOpen: 26,
                                    slopeDistance: 180,
                                    slopeDistanceOpen: 150,
                                    maxAltitude: 2650,
                                    minAltitude: 1200,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.8800,
                                    lat: 45.6279,
                                    domain: "Espace San Bernardo",
                                    cityCode: 73700,
                                    contact: Contact(
                                        email: "larosiere@example.com",
                                        phone: "+33 4 79 06 80 51"
                                    ),
                                    isOpen: true,
                                    price: 50,
                                    note: 4,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Ski Lessons for Beginners", date: Date().addingTimeInterval(86400 * 4), activity: .ski, pricing: .paid),
                                        Event(name: "Torchlight Descent", date: Date().addingTimeInterval(86400 * 9), activity: .snowboard, pricing: .free)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -3.0, altitude: 1200),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .sunny, temperature: -2.5, altitude: 1200),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Rain, temperature: 0.0, altitude: 1200),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Snow, temperature: -4.0, altitude: 1200)
                                    ]
                                ),
                                Station(
                                    name: "Les Gets",
                                    lift: 48,
                                    liftOpen: 40,
                                    slopeDistance: 160,
                                    slopeDistanceOpen: 120,
                                    maxAltitude: 2002,
                                    minAltitude: 1172,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.6660,
                                    lat: 46.1610,
                                    domain: "Les Portes du Soleil",
                                    cityCode: 74260,
                                    contact: Contact(
                                        email: "lesgets@example.com",
                                        phone: "+33 4 50 75 80 80"
                                    ),
                                    isOpen: true,
                                    price: 45,
                                    note: 4,
                                    isFavorite: true,
                                    events: [
                                        Event(name: "Ski Lessons", date: Date().addingTimeInterval(86400 * 2), activity: .ski, pricing: .paid),
                                        Event(name: "Snowboarding Competition", date: Date().addingTimeInterval(86400 * 5), activity: .snowboard, pricing: .reservation)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -2.0, altitude: 1172),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Clouds, temperature: -1.5, altitude: 1172),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Snow, temperature: -2.0, altitude: 1172),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Rain, temperature: 0.5, altitude: 1172)
                                    ]
                                ),
                                Station(
                                    name: "Morzine",
                                    lift: 52,
                                    liftOpen: 45,
                                    slopeDistance: 200,
                                    slopeDistanceOpen: 160,
                                    maxAltitude: 2002,
                                    minAltitude: 1000,
                                    galerie: Galerie(
                                        cover: "https://media.istockphoto.com/id/1169574276/fr/photo/soleil-de-forme-d%C3%A9toile-dans-le-paysage-enneig%C3%A9-de-montagne-dhiver.webp?b=1&s=170667a&w=0&k=20&c=kQbyRWM_eeX4LvMd-2_yYmlE2ymD6YQgMRHHtFNsA7Q="
                                    ),
                                    long: 6.7086,
                                    lat: 46.1783,
                                    domain: "Les Portes du Soleil",
                                    cityCode: 74110,
                                    contact: Contact(
                                        email: "morzine@example.com",
                                        phone: "+33 4 50 79 11 57"
                                    ),
                                    isOpen: true,
                                    price: 50,
                                    note: 4,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Snowshoe Hiking", date: Date().addingTimeInterval(86400 * 3), activity: .cycle, pricing: .free),
                                        Event(name: "Après Ski Party", date: Date().addingTimeInterval(86400 * 6), activity: .competition, pricing: .paid)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .Clouds, temperature: -1.0, altitude: 1000),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .partlyCloudyDay, temperature: 0.5, altitude: 1000),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Rain, temperature: 1.0, altitude: 1000),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .sunny, temperature: 2.0, altitude: 1000)
                                    ]
                                ),
                                Station(
                                    name: "Avoriaz",
                                    lift: 51,
                                    liftOpen: 42,
                                    slopeDistance: 180,
                                    slopeDistanceOpen: 140,
                                    maxAltitude: 2466,
                                    minAltitude: 1800,
                                    galerie: Galerie(),
                                    long: 6.7736,
                                    lat: 46.1958,
                                    domain: "Les Portes du Soleil",
                                    cityCode: 74110,
                                    contact: Contact(
                                        email: "avoriaz@example.com",
                                        phone: "+33 4 50 74 02 11"
                                    ),
                                    isOpen: true,
                                    price: 55,
                                    note: 3,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Torchlight Descent", date: Date().addingTimeInterval(86400 * 4), activity: .ski, pricing: .free),
                                        Event(name: "Fireworks Show", date: Date().addingTimeInterval(86400 * 7), activity: .competition, pricing: .free)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -1.5, altitude: 1800),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .partlyCloudyNight, temperature: -2.0, altitude: 1800),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Snow, temperature: -1.0, altitude: 1800),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Clouds, temperature: 0.5, altitude: 1800)
                                    ]
                                ),
                                Station(
                                    name: "Chamonix-Mont-Blanc",
                                    lift: 45,
                                    liftOpen: 40,
                                    slopeDistance: 220,
                                    slopeDistanceOpen: 180,
                                    maxAltitude: 3842,
                                    minAltitude: 1035,
                                    galerie: Galerie(),
                                    long: 6.8656,
                                    lat: 45.9237,
                                    domain: "Chamonix",
                                    cityCode: 74400,
                                    contact: Contact(
                                        email: "chamonix@example.com",
                                        phone: "+33 4 50 53 00 24"
                                    ),
                                    isOpen: true,
                                    price: 60,
                                    note: 4,
                                    isFavorite: true,
                                    events: [
                                        Event(name: "Ski Film Festival", date: Date().addingTimeInterval(86400 * 2), activity: .competition, pricing: .paid),
                                        Event(name: "Guided Ice Climbing", date: Date().addingTimeInterval(86400 * 5), activity: .cycle, pricing: .paid)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -5.0, altitude: 1035),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Clouds, temperature: -3.0, altitude: 1035),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .partlyCloudyDay, temperature: -2.0, altitude: 1035),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .windy, temperature: -1.5, altitude: 1035)
                                    ]
                                ),
                                Station(
                                    name: "Flaine",
                                    lift: 26,
                                    liftOpen: 22,
                                    slopeDistance: 160,
                                    slopeDistanceOpen: 120,
                                    maxAltitude: 2500,
                                    minAltitude: 1600,
                                    galerie: Galerie(),
                                    long: 6.6792,
                                    lat: 46.0056,
                                    domain: "Grand Massif",
                                    cityCode: 74300,
                                    contact: Contact(
                                        email: "flaine@example.com",
                                        phone: "+33 4 50 90 80 01"
                                    ),
                                    isOpen: true,
                                    price: 50,
                                    note: 3,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Night Skiing", date: Date().addingTimeInterval(86400 * 3), activity: .ski, pricing: .paid),
                                        Event(name: "Snow Sculpture Contest", date: Date().addingTimeInterval(86400 * 6), activity: .competition, pricing: .free)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -4.0, altitude: 1600),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Snow, temperature: -3.0, altitude: 1600),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .windy, temperature: -2.0, altitude: 1600),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Clouds, temperature: -1.5, altitude: 1600)
                                    ]
                                ),
                                Station(
                                    name: "Les Contamines-Montjoie",
                                    lift: 48,
                                    liftOpen: 42,
                                    slopeDistance: 180,
                                    slopeDistanceOpen: 150,
                                    maxAltitude: 2487,
                                    minAltitude: 1150,
                                    galerie: Galerie(),
                                    long: 6.7260,
                                    lat: 45.8222,
                                    domain: "Evasion Mont-Blanc",
                                    cityCode: 74170,
                                    contact: Contact(
                                        email: "lescontamines@example.com",
                                        phone: "+33 4 50 47 01 58"
                                    ),
                                    isOpen: true,
                                    price: 45,
                                    note: 4,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Torchlight Descent", date: Date().addingTimeInterval(86400 * 2), activity: .ski, pricing: .free),
                                        Event(name: "Après-Ski Party", date: Date().addingTimeInterval(86400 * 5), activity: .cycle, pricing: .paid)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .sunny, temperature: -3.0, altitude: 1150),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .Rain, temperature: -1.0, altitude: 1150),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .partlyCloudyDay, temperature: 0.0, altitude: 1150),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Snow, temperature: -2.0, altitude: 1150)
                                    ]
                                ),
                                Station(
                                    name: "Chatel",
                                    lift: 43,
                                    liftOpen: 38,
                                    slopeDistance: 160,
                                    slopeDistanceOpen: 130,
                                    maxAltitude: 2200,
                                    minAltitude: 1000,
                                    galerie: Galerie(),
                                    long: 6.8423,
                                    lat: 46.2673,
                                    domain: "Portes du Soleil",
                                    cityCode: 74390,
                                    contact: Contact(
                                        email: "chatel@example.com",
                                        phone: "+33 4 50 73 22 44"
                                    ),
                                    isOpen: true,
                                    price: 50,
                                    note: 5,
                                    isFavorite: false,
                                    events: [
                                        Event(name: "Ski Cross Competition", date: Date().addingTimeInterval(86400 * 3), activity: .competition, pricing: .paid),
                                        Event(name: "Après-Ski DJ Party", date: Date().addingTimeInterval(86400 * 6), activity: .cycle, pricing: .paid)
                                    ],
                                    weatherReports: [
                                        WeatherReport(date: Date().addingTimeInterval(86400), weather: .Clouds, temperature: -2.0, altitude: 1000),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 2), weather: .partlyCloudyDay, temperature: -1.0, altitude: 1000),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 3), weather: .Rain, temperature: 0.0, altitude: 1000),
                                        WeatherReport(date: Date().addingTimeInterval(86400 * 4), weather: .Snow, temperature: -3.0, altitude: 1000)
                                    ]
                                ),

                            ]


            )
            self.save()
        }
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

class ReadData: ObservableObject  {
    @Published var stations = [Station]()
    
        
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "data_station_parser", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let stations = try? JSONDecoder().decode([Station].self, from: data!)
        self.stations = stations!
        
    }
     
}
