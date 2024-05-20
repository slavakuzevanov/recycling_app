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

class TestViewController: UIViewController {

    @IBOutlet weak var locationContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Создаем экземпляр LocationViewModel
        let locationsViewModel = LocationsViewModel(userLocationBinding: .constant(nil), mapView: YandexMapView(userLocation: .constant(YMKPoint())))

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
    }
}
