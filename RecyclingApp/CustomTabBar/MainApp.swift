//
//  CustomTabBar.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import SwiftUI

struct MainApp: View {
    private var tabBarState = TabBarState()
    @State var selectedTab = "house.fill"
    var body: some View {
        ZStack(alignment: .bottom, content: {
            
            Color(
                red: 159 / 255,
                green: 180 / 255,
                blue: 115 / 255,
                opacity: 1
                //alpha: 0.3
            ).ignoresSafeArea()
            
            // Custom Tab Bar ...
            CustomTabBar(tabBarState: tabBarState)
        })
    }
}

#Preview {
    MainApp()
}
