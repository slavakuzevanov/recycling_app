//
//  TabBarState.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import SwiftUI

class TabBarState: ObservableObject {
    @Published var selectedTab: String = "house.fill"
}
