//
//  WeatherReport.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 22/02/2024.
//

import SwiftUI

struct WeatherReport: Identifiable, Hashable, Decodable, Encodable {
    var id: UUID = UUID()
    var date: Date
    var weather: Weather
    var temperature : Float
    var altitude : Int = -1
}

enum WeekDayFR: String {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    var toFr: String {
        switch self {
        case .Monday:
            return "Lundi"
        case .Tuesday:
            return "Mardi"
        case .Wednesday:
            return "Mercredi"
        case .Thursday:
            return "Jeudi"
        case .Friday:
            return "Vendredi"
        case .Saturday:
            return "Samedi"
        case .Sunday:
            return "Dimanche"
        }
    }
}

enum Weather: String, CaseIterable, Hashable, Decodable, Encodable {
    case sunny, Clouds, Rain, Snow, windy, stormy, foggy, overcast, partlyCloudyDay, partlyCloudyNight, Clear, clearNight, hail, sleet, gust, tornado, dust, smoky, earthquake, fire

    var symbol: String {
        switch self {
        case .sunny, .Clear:
            return "sun.max.fill"
        case .Clouds, .partlyCloudyDay, .partlyCloudyNight:
            return "cloud.fill"
        case .Rain:
            return "cloud.rain.fill"
        case .Snow:
            return "snow"
        case .windy, .gust:
            return "wind"
        case .stormy, .tornado:
            return "tropicalstorm"
        case .foggy:
            return "cloud.fog.fill"
        case .overcast:
            return "cloud.fill"
        case .clearNight:
            return "moon.stars.fill"
        case .hail:
            return "cloud.hail.fill"
        case .sleet:
            return "cloud.sleet.fill"
        case .dust:
            return "sun.dust.fill"
        case .smoky:
            return "smoke.fill"
        case .earthquake:
            return "waveform.path.ecg"
        case .fire:
            return "flame.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .hail:
            return .orange
        case .fire, .earthquake:
            return .red
        default:
            return .gray
        }
    }
}
