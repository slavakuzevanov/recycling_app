//
//  TestViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import Foundation
import UIKit
import SwiftUI
import YandexMapsMobile

class TestViewController: UIViewController, LocationsViewDelegate {
    

    @IBOutlet weak var locationContainerView: UIView!
    
    var drivingSession: YMKDrivingSession?
    var mapView: YandexMapView?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Создаем экземпляр LocationViewModel
        let locationsViewModel = LocationsViewModel(userLocationBinding: .constant(nil))
        locationsViewModel.setMapView(mapView: YandexMapView(cameraPosition: .constant(nil)))
        // Установите делегата
        locationsViewModel.delegate = self
        

        // Создаем представление LocationsView и передаем LocationViewModel как окружение
        let locationView = LocationsView().environmentObject(locationsViewModel)

        // Создаем UIHostingController с LocationViews
        let hostingController = UIHostingController(rootView: locationView)
        
        // Добавляем UIHostingController как дочерний контроллер к нашему контейнерному UIView
        addChild(hostingController)
        locationContainerView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: locationContainerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: locationContainerView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: locationContainerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: locationContainerView.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
        
        // Используем DispatchQueue чтобы подождать, пока view будет полностью инициализировано
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let mapView = locationsViewModel.yandexMapView {
                self.mapView = mapView
            } else {
                print("YandexMapView is not initialized yet")
            }
        }
        
        print("|||||||||||||||||||||||| mapRegion", locationsViewModel.mapRegion.latitude, locationsViewModel.mapRegion.longitude)
        print("|||||||||||||||||||||||| cameraposition first", locationsViewModel.cameraPosition?.target.latitude, locationsViewModel.cameraPosition?.target.longitude)
        print("|||||||||||||||||||||||| cameraposition second", locationsViewModel.cameraPosition?.target.latitude, locationsViewModel.cameraPosition?.target.longitude)
        
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
        
        mapView = locationsViewModel.yandexMapView!
    }
    
    //MARK: Функции делегата LocationsViewDelegate
    func didTapButton() {
        // Обработка нажатия кнопки
        print("Button tapped in TestViewController")
    }
}

extension TestViewController {
    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = mapView!.mapView.mapWindow.map.mapObjects
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

