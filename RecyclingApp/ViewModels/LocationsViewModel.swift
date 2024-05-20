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

struct YandexMapView: UIViewRepresentable {
    @Binding var userLocation: YMKPoint?
    let mapView = YMKMapView()
    let locationManager = CLLocationManager()
    var userLocationLayer: YMKUserLocationLayer?

    class Coordinator: NSObject, CLLocationManagerDelegate, YMKUserLocationObjectListener {
        var parent: YandexMapView
        var locationManager: CLLocationManager
        var userLocationLayer: YMKUserLocationLayer
        var isFirstLocationUpdate = true

        init(parent: YandexMapView) {
            self.parent = parent
            self.locationManager = CLLocationManager()
            self.userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: parent.mapView.mapWindow)
            super.init()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            self.userLocationLayer.setVisibleWithOn(true)
            self.userLocationLayer.isHeadingEnabled = true
            self.userLocationLayer.setObjectListenerWith(self)
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                parent.userLocation = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                print("location manager | location | \(location.coordinate.latitude) | \(location.coordinate.longitude)")
                print("location manager | parent | \(parent.userLocation?.latitude) | \(parent.userLocation?.longitude)")
            }
        }

        // YMKUserLocationObjectListener методы
        func onObjectAdded(with view: YMKUserLocationView) {
            view.pin.setIconWith(UIImage(named: "Arrow")!)
            view.pin.setIconStyleWith(YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 0,
                flat: false,
                visible: true,
                scale: 0.15,
                tappableArea: nil
            ))
            view.accuracyCircle.fillColor = UIColor(red: 30.0 / 255, green: 70.0 / 255, blue: 200.0 / 255, alpha: 0.3)

            // Зумируем к текущему местоположению пользователя при первом обновлении
            if let userLocation = parent.userLocation, isFirstLocationUpdate {
                let cameraPosition = YMKCameraPosition(target: userLocation, zoom: 15, azimuth: 0, tilt: 0)
                parent.mapView.mapWindow.map.move(with: cameraPosition,
                                                   animation: .init(type: .smooth, duration: 1.5),
                                                   cameraCallback: nil)
                isFirstLocationUpdate = false
            }
        }

        func onObjectRemoved(with view: YMKUserLocationView) {
            // Обработка удаления объекта местоположения пользователя (если необходимо)
        }

        func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
            guard isFirstLocationUpdate else {
                return
            }
            isFirstLocationUpdate = false
            
            if let location = userLocationLayer.cameraPosition()?.target {
                // Плавный зум к местоположению пользователя
                parent.mapView.mapWindow.map.move(
                    with: YMKCameraPosition(target: location, zoom: 14, azimuth: 0, tilt: 0),
                    animation: YMKAnimation(type: .smooth, duration: 1.5),
                    cameraCallback: nil
                )
                print("TYPE: ", type(of: location))
                parent.userLocation = location
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> YMKMapView {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = context.coordinator
        locationManager.startUpdatingLocation()

        YMKMapKit.setApiKey("885d509d-26a1-46bc-ae25-e9075e46bea0")
        YMKMapKit.sharedInstance()

        return mapView
    }

    func updateUIView(_ uiView: YMKMapView, context: Context) {}

    func getMapView() -> YMKMapView {
        return mapView
    }
}

class LocationsViewModel: ObservableObject {
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
    
    @Published var userLocation: YMKPoint? {
        didSet {
            updateUserLocation(userLocation!)
        }
    }
    
    // New binding for userLocation
    @Binding var userLocationBinding: YMKPoint?
    
    // Reference to the YandexMapView
    var mapView: YandexMapView
    
    
    init(userLocationBinding: Binding<YMKPoint?>, mapView: YandexMapView) {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self._userLocationBinding = userLocationBinding
        self.mapView = mapView
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location) {
        print("In func updateMapRegion")
        withAnimation(.easeInOut) {
            mapRegion = YMKPoint(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude)
        }
        print("Map region latitude \(mapRegion.latitude) longitude \(mapRegion.longitude)")
    }
    
    func updateUserLocation(_ location: YMKPoint) {
            userLocation = location
            mapView.userLocation = location
        }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList = !showLocationsList
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
        let cameraPosition = YMKCameraPosition(target: YMKPoint(latitude: location.coordinates.latitude,
                                                                longitude: location.coordinates.longitude),
                                               zoom: 15, azimuth: 0, tilt: 0)
        mapView.getMapView().mapWindow.map.move(with: cameraPosition,
                                                animation: .init(type: .smooth, duration: 1.5),
                                                cameraCallback: nil)
    }
}
