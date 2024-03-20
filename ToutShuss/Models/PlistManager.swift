//
//  PlistManager.swift
//  Unsplash SwiftUI
//
//  Created by Anthony Da cruz on 09/12/2023.
//

import Foundation

struct ConfigData: Codable {
    let OpenWeatherMapKey: String
    
    enum CodingKeys: String, CodingKey {
        case OpenWeatherMapKey = "OpenWeatherMap_Key"
    }
}

class ConfigurationManager {
    
    static var instance = ConfigurationManager()
    
    internal let plistDictionnary: ConfigData
    
    init() {
        let url = Bundle.main.url(forResource: "environnement", withExtension:"plist")!
            do {
                let data = try Data(contentsOf: url)
                let result = try PropertyListDecoder().decode(ConfigData.self, from: data)
                self.plistDictionnary = result
            } catch { fatalError("Could not boot app without configuration plist") }
    }
}
