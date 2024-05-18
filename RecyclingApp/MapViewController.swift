//
//  MapViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 18.05.2024.
//

import UIKit
import YandexMapsMobile
import CoreLocation

class MapViewController: UIViewController, YMKUserLocationObjectListener, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: YMKMapView!
    // Подключаем IBOutlet для YMKMapView

    var userLocationLayer: YMKUserLocationLayer!
    var locationManager: CLLocationManager!
    var isFirstLocationUpdate = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Инициализация слоя для отображения местоположения пользователя
        userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true) // Исправлено на вызов метода
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(self)

        // Настройка и отображение карты
//        mapView.mapWindow.map.move(
//            with: YMKCameraPosition(target: YMKPoint(latitude: 55.751244, longitude: 37.618423), zoom: 14, azimuth: 0, tilt: 0)
//        )

        // Настройка CLLocationManager для запроса разрешения на использование геолокации
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Запрос разрешения на использование геолокации
    }

    // CLLocationManagerDelegate методы
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied or restricted")
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
        }
    }

    // YMKUserLocationObjectListener методы
    func onObjectAdded(with view: YMKUserLocationView) {
        view.pin.setIconWith(UIImage(named: "SearchResult")!)
        view.arrow.setIconWith(UIImage(named: "UserArrow")!)
        view.accuracyCircle.fillColor = UIColor(
                                                red: 30.0 / 255,
                                                green: 70.0 / 255,
                                                blue: 200.0 / 255,
                                                alpha: 0.3
                                                )
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
                mapView.mapWindow.map.move(
                    with: YMKCameraPosition(target: location, zoom: 14, azimuth: 0, tilt: 0),
                    animation: YMKAnimation(type: .smooth, duration: 1.5),
                    cameraCallback: nil
                )
            }
        }
}
