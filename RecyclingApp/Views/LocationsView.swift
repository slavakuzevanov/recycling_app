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
                    .frame(maxWidth: .infinity, maxHeight: 700, alignment: .topLeading)
                    .padding(10)
                    //.background(Color.orange)
                
                // Right side buttons
                HStack{
                    Spacer()
                    VStack(alignment: .leading) {
                        Spacer()
                        userLocationButton
                        Spacer()
                        mapRegionButton
                    }
                    .padding(8)
                    //.background(Color.black)
                    .frame(maxWidth: .infinity, alignment: .trailing) // Выровнять по правому краю
                }
                .frame(maxWidth: .infinity, maxHeight: 200, alignment: .topLeading)
                //.background(Color.blue)
                
                
                Spacer()
                
                ZStack {
                    ForEach(vm.locations) {location in
                        if vm.mapLocation == location {
                            LocationPreviewView(location: location)
                                .shadow(color: .black.opacity(0.3), radius: 5)
                                .padding()
                                .offset(y: -70)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
                        }
                    }
                }
                //.background(Color.yellow)
                
                
                
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
                    .animation(.none, value: vm.mapLocation)
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
    
    private var userLocationButton: some View {
        Button(action: {
            vm.scrollToUserLocation()
            print("Button tapped \(vm.userLocation?.latitude) \(vm.userLocation?.longitude)")
            print("Button tapped current location \(vm.mapRegion.latitude) \(vm.mapRegion.longitude)")
        }, label: {
            Image(systemName: "safari.fill")
                .foregroundColor(Color(red: 239 / 255, green: 177 / 255, blue: 154 / 255))
        })
        .frame(width: Layout.buttonSize, height: Layout.buttonSize)
        .background(Color(red: 154 / 255, green: 181 / 255, blue: 107 / 255))
        .cornerRadius(10)
        .padding(.leading, Layout.buttonMargin)
//        .padding(.bottom, Layout.buttonBottomOffset) // Используем новый отступ снизу

    }
    
    private var mapRegionButton: some View{
        Button(action: vm.scrollToCurrentRegion) {
            Image(systemName: "safari.fill")
                .foregroundColor(Color(red: 239 / 255, green: 177 / 255, blue: 154 / 255))
        }
        .frame(width: Layout.buttonSize, height: Layout.buttonSize)
        .background(Color(red: 154 / 255, green: 0 / 255, blue: 107 / 255))
        .cornerRadius(10)
        .padding(.leading, Layout.buttonMargin)
//        .padding(.bottom, Layout.buttonBottomOffset) // Используем новый отступ снизу
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel(userLocationBinding: .constant(nil)))
}
