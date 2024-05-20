//
//  LocationsViewModel.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//
import SwiftUI
import Foundation
import YandexMapsMobile
import CoreLocation

class LocationsViewModel: NSObject, ObservableObject {
    // All loaded locations
    @Published var locations: [Location]
    
    // Current location on map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    // Current region on map
    @Published var mapRegion: YMKPoint = YMKPoint(latitude: 0, longitude: 0)
    
    // Show list of locations
    @Published var showLocationsList: Bool = false
    
    @Published var userLocation: YMKPoint? 
    @Published var cameraPosition: YMKCameraPosition?
    
    private var isFirstLocationUpdate = true
    
    let locationManager = CLLocationManager()
    
    init(userLocationBinding: Binding<YMKPoint?>) {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        super.init()
        self.updateMapRegion(location: mapLocation)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func updateMapRegion(location: Location) {
        print("In func updateMapRegion")
        withAnimation(.easeInOut) {
            mapRegion = YMKPoint(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
        }
        print("Map region latitude \(mapRegion.latitude) longitude \(mapRegion.longitude)")
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList = !showLocationsList
        }
    }
    
    func scrollToUserLocation() {
        if let userLocation {
            cameraPosition = YMKCameraPosition(target: userLocation, zoom: 15, azimuth: 0, tilt: 0)
        }
    }
    
    func scrollToCurrentRegion() {
        cameraPosition = YMKCameraPosition(target: mapRegion, zoom: 15, azimuth: 0, tilt: 0)
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
        cameraPosition = YMKCameraPosition(
            target: YMKPoint(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude), 
            zoom: 15,
            azimuth: 0,
            tilt: 0
        )
    }
}

extension LocationsViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print("location manager | location | \(location.coordinate.latitude) | \(location.coordinate.longitude)")
            
            // Scroll to user location if it's the first update
            if isFirstLocationUpdate, let userLocation = userLocation {
                cameraPosition = YMKCameraPosition(target: userLocation, zoom: 15, azimuth: 0, tilt: 0)
                isFirstLocationUpdate = false
            }
        }
    }
}
