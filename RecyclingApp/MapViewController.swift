//
//  MapViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 18.05.2024.
//

import UIKit
import YandexMapsMobile
import CoreLocation
import Foundation

class MapViewController: UIViewController, YMKUserLocationObjectListener, CLLocationManagerDelegate, YMKClusterListener, YMKClusterTapListener {
    
    // MARK: - Working with UserLocation
    @IBOutlet weak var mapView: YMKMapView!
    // Подключаем IBOutlet для YMKMapView
    var drivingSession: YMKDrivingSession?

    // for user location
    var userLocationLayer: YMKUserLocationLayer!
    var cllocationManager: CLLocationManager!
    var isFirstLocationUpdate = true
    private var locationManager: YMKLocationManager?
    var currentUserLocation: YMKPoint?
    
    // for clustering
    private var imageProvider = UIImage(named: "SearchResult")!
    private let PLACEMARKS_NUMBER = 2000
    private let FONT_SIZE: CGFloat = 15
    private let MARGIN_SIZE: CGFloat = 3
    private let STROKE_SIZE: CGFloat = 3
    
    // for interface on map
    var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Инициализация слоя для отображения местоположения пользователя
        userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true) // Исправлено на вызов метода
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(self)


        // Настройка CLLocationManager для запроса разрешения на использование геолокации
        cllocationManager = CLLocationManager()
        cllocationManager.delegate = self
        cllocationManager.requestWhenInUseAuthorization() // Запрос разрешения на использование геолокации
        
        // Note that application must retain strong references to both
        // cluster listener and cluster tap listener
        let collection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)

        let points = createPoints()
        collection.addPlacemarks(with: points, image: self.imageProvider, style: YMKIconStyle())

        // Placemarks won't be displayed until this method is called. It must be also called
        // to force clusters update after collection change
        collection.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
        
        setupButton()
        setupButton2()
        
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
            currentUserLocation = YMKPoint(latitude: latitude, longitude: longitude)
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
            tappableArea: nil))
        view.pin.direction = 90
        
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
                print("TYPE: ", type(of: location))
                currentUserLocation = location
            }
        }
    
    // MARK: - Working with clusters
    func onClusterAdded(with cluster: YMKCluster) {
        // We setup cluster appearance and tap handler in this method
        cluster.appearance.setIconWith(clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }

    func onClusterTap(with cluster: YMKCluster) -> Bool {
        let alert = UIAlertController(
            title: "Tap",
            message: String(format: "Tapped cluster with %u items", cluster.size),
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)

        // We return true to notify map that the tap was handled and shouldn't be
        // propagated further.
        return true
    }
    
    func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)

        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!

        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));

        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func randomDouble() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }

    func createPoints() -> [YMKPoint]{
        var points = [YMKPoint]()
        for _ in 0..<PLACEMARKS_NUMBER {
            let clusterCenter = Const.clusterCenters.randomElement()!
            let latitude = clusterCenter.latitude + randomDouble()  - 0.5
            let longitude = clusterCenter.longitude + randomDouble()  - 0.5

            points.append(YMKPoint(latitude: latitude, longitude: longitude))
        }

        return points
    }
    
    // MARK: - creating buttons
    private enum Layout {
        static let buttonSize: CGFloat = 55.0
        static let buttonMargin: CGFloat = 16.0
        static let buttonCornerRadius: CGFloat = 8.0
    }
    
    func setupButton() {
        button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "safari.fill"), for: .normal)
        //button.setTitle("Button", for: .normal)
        button.backgroundColor = UIColor(red: 154 / 255,
                                         green: 181 / 255,
                                         blue: 107 / 255,
                                         alpha: 1
                                        )
        //button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = UIColor(red: 239 / 255,
                                   green: 177 / 255,
                                   blue: 154 / 255,
                                   alpha: 1
                                  )
        button.alpha = 1
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.buttonMargin),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: +100),
//            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Layout.buttonSize)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        // Действие при нажатии кнопки
        print("Button tapped")
        if let location = userLocationLayer.cameraPosition()?.target {
            // Плавный зум к местоположению пользователя
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: location, zoom: 14, azimuth: 0, tilt: 0),
                animation: YMKAnimation(type: .smooth, duration: 1.5),
                cameraCallback: nil
            )
        }
    }
    
    func setupButton2() {
        button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "safari.fill"), for: .normal)
        //button.setTitle("Button", for: .normal)
        button.backgroundColor = UIColor(red: 154 / 255,
                                         green: 0 / 255,
                                         blue: 107 / 255,
                                         alpha: 1
                                        )
        //button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = UIColor(red: 239 / 255,
                                   green: 177 / 255,
                                   blue: 154 / 255,
                                   alpha: 1
                                  )
        button.alpha = 1
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.buttonMargin),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: +200),
//            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            button.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Layout.buttonSize)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
    }
    
    @objc func buttonTapped2() {
        // Действие при нажатии кнопки
        print("Button2 tapped")
        if let location = userLocationLayer.cameraPosition()?.target {
            // Плавный зум к местоположению пользователя
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(target: location, zoom: 14, azimuth: 0, tilt: 0),
                animation: YMKAnimation(type: .smooth, duration: 1.5),
                cameraCallback: nil
            )
        }
        
        // Посмтроение маршрута
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(
                point: Const.routeStartPoint, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(
                point: Const.routeEndPoint, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            ]
        
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                print("Получены пути")
                self.onRoutesReceived(routes)
            } else {
                print("НЕ получены пути")
                self.onRoutesError(error!)
            }
        }
        
        let drivingRouter = YMKDirectionsFactory.instance().createDrivingRouter(withType: .combined)
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
        
        print("requested point \(requestPoints[0].point.latitude) \(requestPoints[0].point.longitude)")
    }
}

extension MapViewController {
    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = mapView.mapWindow.map.mapObjects
        for route in routes {
            mapObjects.addPolyline(with: route.geometry)
        }
    }

    func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
