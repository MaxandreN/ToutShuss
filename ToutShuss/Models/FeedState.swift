//
//  FeedState.swift
//  UnsplashApp
//
//  Created by Maxandre Neveux on 02/02/2024.
//

import Foundation
import SwiftUI

struct APIWeatherReportMain: Decodable {
    var temp: Float
    var temp_min: Float
    var temp_max: Float
}
struct APIWeatherReportWeather: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
struct APIWeatherReportClouds: Decodable {
    var all: Int
}
struct APIWeatherReportWind: Decodable {
    var speed: Float
    var deg: Float
    var gust: Float
}


class APIWeatherReport: Decodable, Identifiable{
    var id: UUID = UUID()
    var dt: Date = Date()
    var main: APIWeatherReportMain
    var weather: [APIWeatherReportWeather]
    var clouds: APIWeatherReportClouds
    var wind: APIWeatherReportWind
    //var visibility: Int = 0
    //var pop: Float = 0
    
    enum CodingKeys: CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        //case visibility
        //case pop
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Date.self, forKey: .dt)
        self.main = try container.decode(APIWeatherReportMain.self, forKey: .main)
        self.weather = try container.decode([APIWeatherReportWeather].self, forKey: .weather)
        self.clouds = try container.decode(APIWeatherReportClouds.self, forKey: .clouds)
        self.wind = try container.decode(APIWeatherReportWind.self, forKey: .wind)
        //self.visibility = Int32(try container.decode(Int.self, forKey: .visibility))
        //self.pop = try container.decode(Float.self, forKey: .pop)
    }
    
    func toWeatherReport () -> WeatherReport {
        let weatherReport = WeatherReport(
            date: dt,
            weather: Weather(rawValue: weather[0].main)!,
            temperature: Float(main.temp) - 273.15
        )
        
        return weatherReport
    }
}

struct APIWeatherBook: Decodable{
    var list:[APIWeatherReport]
    
    enum CodingKeys: CodingKey {
        case list
    }
    
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try container.decode([APIWeatherReport].self, forKey: .list)
  
    }
}
           




class FeedState: ObservableObject {
    @Published var weatherReports: [WeatherReport] = []
    @Published var value: String = "non"

    func fetchWeatherFeed(lat:Float, lon:Float) async {
        do {
            if let url = OpenWeatherMap().feedForecastUrl(lat: lat, lon: lon){

                // Créez une requête avec cette URL
                let request = URLRequest(url: url)
                
                // Faites l'appel réseau
                let (data, _) = try await URLSession.shared.data(for: request)
                print(data)
                // Transformez les données en JSON
                let apiWeatherBook = try JSONDecoder().decode(APIWeatherBook.self, from: data)
                
                var weatherReportbook: [WeatherReport] = []
                
                for apiWeatherReport in apiWeatherBook.list {
                    weatherReportbook.append(apiWeatherReport.toWeatherReport())
                }
                
                weatherReportbook.sort { a, b in
                    a.date > b.date
                }
                
                weatherReports = weatherReportbook
                // Mettez à jour l'état de la vue
            }
        } catch {
            print("Error: \(error)")
        }
    }


}

#Preview {
    ContentView()
}
