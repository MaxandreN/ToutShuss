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
    var permissions = Permissions()
    var region: MKCoordinateRegion
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    var baseLocation: CLLocation {
        return CLLocation(latitude: lat, longitude: long)
    }
    
    init() {
        self.long = 0
        self.lat = 0
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: long),
            span: MKCoordinateSpan(
                latitudeDelta: 1,
                longitudeDelta: 1
            )
        )
    }

    
    func fetchTravelTime(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (Int, Int) -> Void) {
        if let currentLocation = permissions.locationManager.location {
            let sourcePlacemark = MKPlacemark(coordinate: source)
            let destinationPlacemark = MKPlacemark(coordinate: destination)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.requestsAlternateRoutes = true
            directionRequest.transportType = .automobile // You can change this to .walking or .transit if needed
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        print("Error calculating directions: \(error)")
                    }
                    completion(-1, -1)
                    return
                }
                
                if let route = response.routes.first {
                    let travelTimeInMinutes = Int(route.expectedTravelTime / 60)
                    let distance = Int(route.distance / 1000)
                    completion(travelTimeInMinutes, distance)
                } else {
                    completion(-1, -1)
                }
            }
        }else{
            completion(-1, -1)
        }
    }
}
