//
//  RouteSelectionCardView.swift
//  RouteBrew
//
//  Created by km on 13/10/2022.
//

import SwiftUI

struct RouteSelectionCardView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var startPlaceName: String {
        guard let startPlace = locationViewModel.routeStartPlacemark else { return "undefined" }
        guard let name = startPlace.name else { return "undefined" }
        
        return name
    }
    
    var startPlaceLocality: String {
        guard let startPlace = locationViewModel.routeStartPlacemark else { return "undefined" }
        guard let locality = startPlace.locality else { return "undefined" }
        
        return locality
    }
    
    var endPlaceName: String {
        guard let endPlace = locationViewModel.routeEndPlacemark else { return "undefined" }
        guard let name = endPlace.name else { return "undefined" }
        
        return name
    }
    
    var endPlaceLocality: String {
        guard let endPlace = locationViewModel.routeEndPlacemark else { return "undefined" }
        guard let locality = endPlace.locality else { return "undefined" }
        
        return locality
    }

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(startPlaceName)
                                .font(.title3)
                            Text(startPlaceLocality)
                                .font(.caption)
                        }
                        Spacer()
                        Button {
                            // delete start location
                        } label: {
                            Label {} icon: {
                                Image(systemName: "trash.circle")
                            }
                        }
                        .font(.title)
                        .foregroundColor(.gray)
                        .background(.white.opacity(0.5))
                    }
                    .padding()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(endPlaceName)
                                .font(.title3)
                            Text(endPlaceLocality)
                                .font(.caption)
                        }
                        Spacer()
                        Button {
                            // delete end location
                        } label: {
                            Image(systemName: "trash.circle")
                        }
                        .foregroundColor(.gray)
                        .font(.title)
                    }.padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
         
            VStack {
                Button {
//                    saveNewRoute()
                    dismiss()
                } label: {
                    Text("Confirm route selection")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.green.opacity(0.75))
                .foregroundColor(.white)
                .cornerRadius(7)
            }
            .padding()
        }
        .background(.white)
        .cornerRadius(14)
        .padding()
        .shadow(radius: 4)
    }
}

struct RouteSelectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()
        RouteSelectionCardView().environmentObject(viewModel)
    }
}
