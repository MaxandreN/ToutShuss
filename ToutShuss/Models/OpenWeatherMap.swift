//
//  OpenWeatherMap.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 18/03/2024.
//

import Foundation
import SwiftUI

// Construit un objet URLComponents avec la base de l'API Unsplash
// Et un query item "client_id" avec la clé d'API retrouvé depuis PListManager
struct OpenWeatherMap {
    let scheme : String = "https"
    let host : String = "api.openweathermap.org"
    let path : String = "/data/2.5/weather"
    
    func ApiBaseUrl() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.queryItems = [
            URLQueryItem(name: "appid", value: ConfigurationManager.instance.plistDictionnary.OpenWeatherMapKey),
        ]
        
        return components
    }
    
    // Par défaut orderBy = "popular" et perPage = 10 -> Lisez la documentation de l'API pour comprendre les paramètres, vous pouvez aussi en ajouter d'autres si vous le souhaitez
    func feedUrl(lat: Float, lon: Float) -> URL? {
        var components = ApiBaseUrl()
        components.path = "/data/2.5/weather"
        components.queryItems! += [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
        ]
        
        return components.url
    }
    
    func feedForecastUrl(lat: Float, lon: Float) -> URL? {
        var components = ApiBaseUrl()
        components.path = "/data/2.5/forecast"
        components.queryItems! += [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
        ]
        
        return components.url
    }
}


