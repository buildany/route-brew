//
//  SearchTextField.swift
//  RouteBrew
//
//  Created by km on 14/10/2022.
//

import CoreLocation
import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String
    var fetchedPlaces: [CLPlacemark]?
    var onSelect: (CLPlacemark) -> Void
    var placeholder: String
    var placemark: CLPlacemark?
    var deletePlace: () -> Void
    var label: String
    var canUseCurrentLocation: Bool
    var onSelectCurrentLocation: () -> Void

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    Image(systemName: "\(label).circle")
                        .foregroundColor(placemark == nil ? .gray.opacity(0.5) : .green.opacity(0.5))
                        .padding(.leading)
                       
                    
                    TextField(placeholder, text: $searchText)
                        .padding(.top)
                        .padding(.bottom)
                        .foregroundColor(.primary)
                        .frame(alignment: .leading)
                       
                        

                    HStack {
                        if let _ = placemark {
                            Button {
                                deletePlace()
                            } label: {
                                Label {} icon: {
                                    Image(systemName: "xmark")
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .frame(alignment: .leading)
                        }
                        
                        if canUseCurrentLocation {
                            Button {
                                onSelectCurrentLocation()
                            } label: {
                                Image(systemName: "location.fill")
                                    .padding()
                                    
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.trailing)
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.gray, lineWidth: 1)
                    .shadow(radius: 4)
            )
            
            if let places = fetchedPlaces, !places.isEmpty, placemark == nil {
                List {
                    ForEach(places, id: \.self) { place in
                        Button(action: {
                            if let _ = place.location?.coordinate {
                                onSelect(place)
                            }
                        }) {
                            HStack(spacing: 15) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(place.name ?? "")
                                        .font(.title3.bold())
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .cornerRadius(7)
                    }
                }
                .listStyle(.plain)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
        .background(.white)
        .cornerRadius(7)
    }
}
