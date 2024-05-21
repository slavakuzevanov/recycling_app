//
//  LocationPreviewView.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 20.05.2024.
//

import SwiftUI

struct LocationPreviewView: View {
    @EnvironmentObject var vm: LocationsViewModel
    
    let location: Location
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 16) {
                imageSection
                titleSection
            }
            VStack(spacing: 8) {
                learnMoreButton
                routeButton
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .offset(y: 65)
        )
        .cornerRadius(15)
    }
}

#Preview {
    ZStack{
        Color.green.ignoresSafeArea()
        LocationPreviewView(location: LocationsDataService.locations.first!)
            .environmentObject(LocationsViewModel(userLocationBinding: .constant(nil)))
            .background(Color.white)
            .padding()
    }
}

extension LocationPreviewView {
    
    private var imageSection: some View {
        ZStack {
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
            Text(location.cityName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var learnMoreButton: some View {
        Button(action: {
            vm.sheetLocation = location
        }, label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 35)
        })
        .buttonStyle(.borderedProminent)
    }
    
    private var routeButton: some View {
        Button(action: {
            vm.routeButtonTapped()
            print("Button tapped in LocationsPreviewView")
        }, label: {
            Text("Route")
                .font(.headline)
                .frame(width: 125, height: 35)
        })
        .buttonStyle(.bordered)
    }
}

