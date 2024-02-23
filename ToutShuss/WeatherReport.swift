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
    var temperature : Double
    var altitude : Int = -1
}

enum Weather: String, CaseIterable, Hashable, Decodable, Encodable {
    case sunny, cloudy, rainy, snowy, windy, stormy, foggy, overcast, partlyCloudyDay, partlyCloudyNight, clearDay, clearNight, hail, sleet, gust, tornado, dust, smoky, earthquake, fire

    var symbol: String {
        switch self {
        case .sunny, .clearDay:
            return "sun.max.fill"
        case .cloudy, .partlyCloudyDay, .partlyCloudyNight:
            return "cloud.fill"
        case .rainy:
            return "cloud.rain.fill"
        case .snowy:
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
