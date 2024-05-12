//
//  BaseMapViewController.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 12.05.2024.
//

import Foundation
import UIKit
import Foundation
import YandexMapsMobile


class BaseMapViewController : UIViewController {
    
    
    @IBOutlet var baseMapView: BaseMapView!
    
    var mapView: YMKMapView! {
        get {
            return baseMapView.mapView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
