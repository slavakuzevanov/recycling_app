//
//  Location.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    // Identifiable
    var id: String {
        name + cityName
    }
}

