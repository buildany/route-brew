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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField(placeholder, text: $searchText)
                        .padding()
                        .foregroundColor(.primary)
                
                    Button {} label: {
                        Label {} icon: {
                            Image(systemName: "location.north.circle.fill")
                        }
                    }
                    .font(.title)
                    .foregroundColor(.gray)
                    .background(.white.opacity(0.5))
                    .clipShape(Circle())
                    .shadow(radius: 7)
                }
                .padding(.leading)
                .padding(.trailing)
                .background(.white)
                .cornerRadius(7)
                
            }
          
        
            if let places = fetchedPlaces, !places.isEmpty {
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
    }
}
