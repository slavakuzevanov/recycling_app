//
//  CustomTabBar.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import SwiftUI

struct CustomTabBar: View {
    @ObservedObject var tabBarState: TabBarState
    
    // Storing each Tab midpoints to animate curve
    @State var tabPoints : [CGFloat] = []
    
    var onTabSelected: ((String) -> Void)?
    
    var body: some View {
        
        ZStack(alignment: .bottom, content: {
            
//            Color(
//                red:  177 / 255,
//                green: 180 / 255,
//                blue: 115 / 255,
//                opacity: 1
//                //alpha: 0.3
//            ).ignoresSafeArea()
            
            HStack(spacing: 0){
                        TabBarButton(image: "house.fill", selectedTab: $tabBarState.selectedTab, tabPoints: $tabPoints, onTabSelected: onTabSelected)
                        TabBarButton(image: "camera.viewfinder", selectedTab: $tabBarState.selectedTab, tabPoints: $tabPoints, onTabSelected: onTabSelected)
                        TabBarButton(image: "map.fill", selectedTab: $tabBarState.selectedTab, tabPoints: $tabPoints, onTabSelected: onTabSelected)
                    }
            .padding()
            .background(Rectangle().fill(Color(red: 124 / 255,
                                               green: 150 / 255,
                                               blue: 54 / 255,
                                               opacity: 1))
                .clipShape(TabCurve(tabPoint: getCurvePoint() - 15)))
            .overlay(
                    Circle()
                        .fill(Color(
                            red: 239 / 255,
                            green: 177 / 255,
                            blue: 154 / 255,
                            opacity: 1
                           ))
                        .frame(width: 10, height: 10)
                        .offset(x: getCurvePoint() - 20)
                    , alignment: .bottomLeading
            )
            .cornerRadius(30)
            .padding(.horizontal)
        })
        
        
        
        
    }
    
    // extracting point ...
    func getCurvePoint() -> CGFloat {
        
        // if tabPoints is empty...
        if tabPoints.isEmpty {
            return 10
        } else {
            switch tabBarState.selectedTab {
            case "house.fill":
                return tabPoints[2]
            case "camera.viewfinder":
                return tabPoints[1]
            default:
                return tabPoints[0]
            }
        }
    }
}

#Preview {
    MainApp()
}

struct TabBarButton: View {
    var image: String
    @Binding var selectedTab: String
    @Binding var tabPoints: [CGFloat]
    var onTabSelected: ((String) -> Void)?
    var tabBarController: TabBarViewController? // Добавьте переменную
    
    var body: some View {
        // For getting mid point of easch button for curve animation
        GeometryReader{reader -> AnyView in
            
            // Extracting mid points and storing
            let midX = reader.frame(in: .global).midX
            
            DispatchQueue.main.async {
                
                // avoiding junk data ...
                if tabPoints.count <= 3 {
                    tabPoints.append(midX)
                }
            }
            
            return AnyView(
                Button(action: {
                // changing tab...
                // spring animation
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)) {
                    selectedTab = image
                    onTabSelected?(image)
                    tabBarController?.handleTabSelection(selectedTab)
                }
            }, label: {
                Image(systemName: image)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(selectedTab == image ?
                                     Color(
                                     red: 239 / 255,
                                     green: 177 / 255,
                                     blue: 154 / 255,
                                     opacity: 1
                                    ) : Color(
                                        red: 53 / 255,
                                        green: 89 / 255,
                                        blue: 92 / 255,
                                        opacity: 1
                                               ))
                // Lifting View ...
                // if its selected
                    .offset(y: selectedTab == image ? -10 : 0)
                
            })
            // Max Frame...
            .frame(maxWidth: .infinity, maxHeight: .infinity))
        }
        // maxHeight ...
        .frame(height: 50)
    }
}
