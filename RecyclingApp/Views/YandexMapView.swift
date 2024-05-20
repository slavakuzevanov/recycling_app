//
//  LocationsListView.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.05.2024.
//

import SwiftUI
import Foundation
import YandexMapsMobile
import CoreLocation

struct YandexMapView: UIViewRepresentable {
    @Binding var cameraPosition: YMKCameraPosition?
    let mapView = YMKMapView()
    var userLocationLayer: YMKUserLocationLayer?
    
    class Coordinator: NSObject, YMKUserLocationObjectListener {
        var parent: YandexMapView
        var userLocationLayer: YMKUserLocationLayer
        
        init(parent: YandexMapView) {
            self.parent = parent
            self.userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: parent.mapView.mapWindow)
            super.init()
            
            self.userLocationLayer.setVisibleWithOn(true)
            self.userLocationLayer.isHeadingEnabled = true
            self.userLocationLayer.setObjectListenerWith(self)
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
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> YMKMapView {
        YMKMapKit.setApiKey("885d509d-26a1-46bc-ae25-e9075e46bea0")
        YMKMapKit.sharedInstance()
        return mapView
    }
    
    func updateUIView(_ uiView: YMKMapView, context: Context) {
        if let cameraPosition {
            uiView.mapWindow.map.move(with: cameraPosition,
                                      animation: .init(type: .smooth, duration: 1.5),
                                      cameraCallback: nil)
        }
    }
    
    func getMapView() -> YMKMapView {
        return mapView
    }
}
