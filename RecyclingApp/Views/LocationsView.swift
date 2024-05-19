//
//  LocationsView.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import SwiftUI
import YandexMapsMobile
import CoreLocation

struct YandexMapView: UIViewRepresentable {
    @Binding var userLocation: YMKPoint?
    let mapView = YMKMapView()
    @State private var isUserLocationPinAdded = false

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
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print("Latitude: \(latitude), Longitude: \(longitude)")
                parent.userLocation = YMKPoint(latitude: latitude, longitude: longitude)
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
        }

        func onObjectRemoved(with view: YMKUserLocationView) {
            // Обработка удаления объекта местоположения пользователя (если необходимо)
        }

        func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
            // Обновление объекта местоположения пользователя (если необходимо)
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
        YMKMapKit.setApiKey("YOUR_API_KEY")
        YMKMapKit.sharedInstance()
        return mapView
    }

    func updateUIView(_ uiView: YMKMapView, context: Context) {
        guard let userLocation = userLocation else { return }
    }

    func getMapView() -> YMKMapView {
        return mapView
    }
}
struct LocationsView: View {
    @State private var userLocation: YMKPoint?
    
    @EnvironmentObject private var vm: LocationViewModel
    
    private enum Layout {
        static let buttonSize: CGFloat = 55.0
        static let buttonMargin: CGFloat = 16.0
        static let buttonBottomOffset: CGFloat = 200.0 // Величина, на которую поднимаем кнопку
    }
    
    var body: some View {
        let mapViewWrapper = YandexMapView(userLocation: $userLocation)
        
        return ZStack {
            mapViewWrapper
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                Button(action: {
                    print("Button tapped")
                    if let userLocation = userLocation {
                        let cameraPosition = YMKCameraPosition(target: userLocation, zoom: 15, azimuth: 0, tilt: 0)
                        mapViewWrapper.getMapView().mapWindow.map.move(with: cameraPosition,
                                                                       animation: .init(type: .smooth, duration: 1.5),
                                                                       cameraCallback: nil)
                    }
                    print("Button tapped ", userLocation?.latitude as Any, userLocation?.longitude as Any)
                }) {
                    Image(systemName: "safari.fill")
                        .foregroundColor(Color(red: 239 / 255, green: 177 / 255, blue: 154 / 255))
                }
                .frame(width: Layout.buttonSize, height: Layout.buttonSize)
                .background(Color(red: 154 / 255, green: 181 / 255, blue: 107 / 255))
                .cornerRadius(10)
                .padding(.trailing, Layout.buttonMargin)
                .padding(.bottom, Layout.buttonBottomOffset) // Используем новый отступ снизу
                .position(x: UIScreen.main.bounds.width - Layout.buttonSize / 2 - Layout.buttonMargin,
                          y: UIScreen.main.bounds.height - Layout.buttonSize / 2 - Layout.buttonBottomOffset)
            }
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationViewModel())
    }
}


#Preview {
    LocationsView()
        .environmentObject(LocationViewModel())
}
