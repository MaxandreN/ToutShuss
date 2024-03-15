//
//  File.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 11/02/2024.
//

import Foundation
import MapKit
import SwiftUI

class Location: ObservableObject {
    var long: Double
    var lat: Double
    
    init(long: Double, lat: Double) {
        self.long = long
        self.lat = lat
    }

    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func getTravelTime(toLat: Double, toLong: Double){
        let toCoordinate = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
        fetchTravelTime(from: location, to: toCoordinate)
    }
    
    func fetchTravelTime(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile // Vous pouvez modifier le mode de transport ici (automobile, à pied, etc.)
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Erreur de calcul de l'itinéraire :", error)
                }
                return
            }
            
            let travelTime = response.routes.first?.expectedTravelTime ?? 0
            let travelTimeInMinutes = Int(travelTime / 60)
        }
    }
}
