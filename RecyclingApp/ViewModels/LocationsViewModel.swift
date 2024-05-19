//
//  LocationsViewModel.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import Foundation

class LocationViewModel: ObservableObject {
    
    @Published var locations: [Location]
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
    }
    
}
