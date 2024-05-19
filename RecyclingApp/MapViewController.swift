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
    var cllocationManager: CLLocationManager!
    var isFirstLocationUpdate = true
    private var locationManager: YMKLocationManager?

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
        cllocationManager = CLLocationManager()
        cllocationManager.delegate = self
        cllocationManager.requestWhenInUseAuthorization() // Запрос разрешения на использование геолокации
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
        
        guard let mapWindow = mapView.mapWindow else {
                return
            }
        
        let currentZoom = mapWindow.map.cameraPosition.zoom
        
        // Установка масштаба пина в зависимости от текущего масштаба карты
        let pinScale = NSNumber(value: Double(currentZoom) / 10.0) // Примерное соотношение масштаба пина и масштаба карты

        
        view.pin.setIconWith(UIImage(named: "Arrow")!)
        view.pin.setIconStyleWith(YMKIconStyle(
            anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
            rotationType: YMKRotationType.rotate.rawValue as NSNumber,
            zIndex: 0,
            flat: false,
            visible: true,
            scale: 0.15,
            tappableArea: nil))
        view.pin.direction = 90
        
//        view.arrow.setIconWith(UIImage(named: "Arrow")!)
//        
//        view.arrow.setIconStyleWith(YMKIconStyle(
//            anchor: CGPoint(x: 0.0, y: 0.0) as NSValue,
//            rotationType: 1,
//            zIndex: 0,
//            flat: false,
//            visible: true,
//            scale: 0.1,
//            tappableArea: nil))
//        view.arrow.direction = 180
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
