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
    var value: CLPlacemark?
    var canSelectCurrentLocation: Bool
    var onSelectCurrentLocation: () -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    if value == nil {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading)
                            .frame(alignment: .leading)
                        
                        TextField(placeholder, text: $searchText)
                            .padding(.top)
                            .padding(.bottom)
                            .foregroundColor(.primary)
                            .frame(alignment: .leading)
                        if canSelectCurrentLocation {
                            Button {
                                onSelectCurrentLocation()
                            } label: {
                                Label {} icon: {
                                    Image(systemName: "location.north.circle.fill")
                                }
                            }
                            .font(.title)
                            .foregroundColor(.gray)
                            .shadow(radius: 7)
                            .padding(.trailing)
                            .background(.white)
                            .cornerRadius(7)
                            .frame(alignment: .trailing)
                        }
                    }
                    if let place = value {
                        if let selectedPlaceName = place.name,
                           let selectedPlaceLocality = place.locality,
                           let sPostalCode = place.postalCode,
                           let sCountry = place.country
                        {
                            Button {
                                
                            } label: {
                                Label {} icon: {
                                    Image(systemName: "xmark")
                                }
                            }
                            .font(.title3)
                            .foregroundColor(.red.opacity(0.75))
                            .clipShape(Circle())
                            .padding(.leading)
                            .frame(alignment: .leading)
                           
                            
                            Text("\(selectedPlaceName), \(selectedPlaceLocality), \(sPostalCode), \(sCountry)")
                                .truncationMode(.tail)
                                .font(.system(size: 15, weight: .semibold, design: .default))
                                .foregroundColor(.primary)
                                .padding(.top)
                                .padding(.bottom)
                                .padding(.trailing)
                                .lineLimit(1)
                                .frame(alignment: .leading)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
        
                
            }
            
            
            if let places = fetchedPlaces, !places.isEmpty, value == nil {
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
