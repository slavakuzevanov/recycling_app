//
//  LocationsView.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 19.05.2024.
//

import SwiftUI
import YandexMapsMobile
import CoreLocation

struct LocationsView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    
    private enum Layout {
        static let buttonSize: CGFloat = 55.0
        static let buttonMargin: CGFloat = 16.0
        static let buttonBottomOffset: CGFloat = 200.0 // Величина, на которую поднимаем кнопку
    }
    
    var body: some View {
        return ZStack {
            YandexMapView(cameraPosition: $vm.cameraPosition)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                header
                    .padding(10)
                Spacer()
                
                Button(action: vm.scrollToUserLocation) {
                    Image(systemName: "safari.fill")
                        .foregroundColor(Color(red: 239 / 255, green: 177 / 255, blue: 154 / 255))
                }
                .frame(width: Layout.buttonSize, height: Layout.buttonSize)
                .background(Color(red: 154 / 255, green: 181 / 255, blue: 107 / 255))
                .cornerRadius(10)
                .padding(.trailing, Layout.buttonMargin)
                .padding(.bottom, Layout.buttonBottomOffset) // Используем новый отступ снизу
                .position(x: UIScreen.main.bounds.width - Layout.buttonSize / 2 - Layout.buttonMargin,
                          y: UIScreen.main.bounds.height - Layout.buttonSize / 2 - Layout.buttonBottomOffset)
                
                Button(action: vm.scrollToCurrentRegion) {
                    Image(systemName: "safari.fill")
                        .foregroundColor(Color(red: 239 / 255, green: 177 / 255, blue: 154 / 255))
                }
                .frame(width: Layout.buttonSize, height: Layout.buttonSize)
                .background(Color(red: 154 / 255, green: 0 / 255, blue: 107 / 255))
                .cornerRadius(10)
                .padding(.trailing, Layout.buttonMargin)
                .padding(.bottom, Layout.buttonBottomOffset + 1000) // Используем новый отступ снизу
                .position(x: UIScreen.main.bounds.width - Layout.buttonSize / 2 - Layout.buttonMargin,
                          y: UIScreen.main.bounds.height - Layout.buttonSize / 2 - Layout.buttonBottomOffset)
                
            }
        }
    }
}

extension LocationsView {
    private var header: some View {
        VStack {
            Button(action: vm.toggleLocationsList) {
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(Color(red: 154 / 255, green: 181 / 255, blue: 107 / 255))
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
            }
            
            if vm.showLocationsList {
                LocationsListView()
            }
            //Command CompileAssetCatalog failed with a nonzero exit code
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel(userLocationBinding: .constant(nil)))
}
