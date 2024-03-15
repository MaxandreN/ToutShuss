//
//  File.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 11/02/2024.
//

import Foundation
import MapKit
import SwiftUI

struct Location {
    var long: Double = 0
    var lat: Double = 0

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

var clientLocation: Location = Location(long: 6.11667, lat: 45.9)
