//
//  MapView.swift
//  ToutShuss
//
//  Created by Maxandre Neveux on 10/02/2024.
//  Modifed by Maxandre Neveux on 11/02/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnnotationItem: Identifiable, Equatable {
    var id: UUID
    var lat: Double = 0
    var lon: Double = 0
    var isMonitored: Bool = false
    
    init(id: UUID, lat: Double = 0, lon: Double = 0) {
        self.id = id
        self.lat = lat
        self.lon = lon
    }
}



struct MapView: View {
    @EnvironmentObject var bookStations: BookStations
    @StateObject var permissions = Permissions()
    
    var annotationsItems : [AnnotationItem] {
        get {
            return bookStations.stations.map({
                if let longitude = $0.long, let latitude = $0.lat {
                    AnnotationItem(id: $0.id, lat: latitude, lon: longitude)
                }else{
                    AnnotationItem(id: $0.id, lat: 0, lon: 0)
                }
            })
                
        }
    }
    
    @Binding var selectedItem: AnnotationItem?
    
    @State private var userTrackingMode: MapUserTrackingMode = .none
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 45.91044837855673,
            longitude: 6.143521781870996
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 1,
            longitudeDelta: 1
        )
    )

    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            Map(
                coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: annotationsItems
            ) { item -> MapAnnotation<Button> in
                return MapAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon),
                    anchorPoint: CGPoint(x: 1, y: 1)
                ) {
                    Button(action: {
                        selectedItem = item
                    }, label: {
                        AnyView(
                            Image(systemName: "skis.fill")
                                .padding(4)
                                .background(.purple)
                                .cornerRadius(100)
                                .frame(width: 5, height: 5, alignment: .center)
                                .foregroundColor(.white)
                           
                        )
                            
                    })
                }
            }
            Button(action: {
                if permissions.notificationPermissionState == .denied {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!, options: [:], completionHandler: nil)
                } else {
                    permissions.askForLocalizationPermission()
                    withAnimation(.spring()) {
                        centerRegionOnUser()
                    }
                }
            }, label: {
                Image(systemName: "location.fill.viewfinder")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
            })
            .padding()
            .frame(alignment: .topLeading)
        }.onReceive(permissions.$localizationPermissionState, perform: { _ in
            centerRegionOnUser()
        })
    }
    
    func centerRegionOnUser() {
        if permissions.localizationPermissionState != .denied || permissions.localizationPermissionState == .notDetermined {
            userTrackingMode = .follow
            if let currentLocation = permissions.locationManager.location {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(
                    latitudeDelta: 10,
                    longitudeDelta: 10
                ))
            }
        }
    }
}

#Preview {
    ContentView()
}
