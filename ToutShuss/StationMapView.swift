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

struct StationMapView: View {
    @EnvironmentObject var bookStations: BookStations
    @EnvironmentObject var clientLocation: Location
    @StateObject var permissions = Permissions()
    @Binding var selectedItem: AnnotationItem
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 45.91044837855673,
            longitude: 6.143521781870996
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.05,
            longitudeDelta: 0.05
        )
    )

    var annotationsItems : [AnnotationItem] {
        get {
            return bookStations.stations.map({
                if let longitude = $0.long, let latitude = $0.lat {
                    AnnotationItem(id: $0.id, lat: latitude, long: longitude, station: $0)
                }else{
                    AnnotationItem(id: $0.id, lat: 0, long: 0, station: $0)
                }
            })
                
        }
    }
    
    @State var sheetSize: CGFloat = 0.6
    @State private var userTrackingMode: MapUserTrackingMode = .none

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
                    coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long),
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
                Image(systemName: userTrackingMode != .follow ? "location.fill.viewfinder" : "skis.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous))
            })
            .padding()
            .frame(alignment: .topLeading)
        }.onAppear(){
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: self.selectedItem.lat,
                    longitude: self.selectedItem.long
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
        }
        .environmentObject(clientLocation)
    }
    
    func centerRegionOnUser() {
        if(userTrackingMode != .follow){
            if permissions.localizationPermissionState != .denied || permissions.localizationPermissionState == .notDetermined {
                userTrackingMode = .follow
                if let currentLocation = permissions.locationManager.location {
                    clientLocation.lat = currentLocation.coordinate.latitude
                    clientLocation.long = currentLocation.coordinate.longitude
                }
            }
        }else{
            userTrackingMode = .none
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: self.selectedItem.lat,
                    longitude: self.selectedItem.long
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )

        }

    }
}

#Preview {
    ContentView()
}
