//
//  LocationDetailView.swift
//  RecyclingApp
//
//  Created by Вячеслав Кузеванов on 21.05.2024.
//

import SwiftUI

struct LocationDetailView: View {
    @EnvironmentObject var vm: LocationsViewModel
    
    let location: Location
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.3), radius: 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    //Divider()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                //.background(Color.red)
                .padding()
            }
            
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

extension LocationDetailView {
    private var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8){
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16){
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read more...", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            vm.sheetLocation = nil
        }, label: {
            Image(systemName: "xmark")
        })
        .font(.headline)
        .padding(16)
        .foregroundColor(Color(red: 154 / 255, green: 181 / 255, blue: 107 / 255))
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 4)
        .padding()
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
}
