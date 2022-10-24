//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import CoreLocation
import LocalAuthentication
import SwiftUI

struct AddNewRouteView: View {
    @State var start = ""
    @State var finish = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationViewModel: LocationViewModel

    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            VStack {
                VStack {
                    SearchTextField(searchText: $locationViewModel.searchText, fetchedPlaces: locationViewModel.fetchedPlaces, onSelect: locationViewModel.addPin, placeholder: "Start location", value: locationViewModel.routeStartPlacemark,
                                    canSelectCurrentLocation: locationViewModel.currentUserLocation != locationViewModel.routeEndLocation,
                                    onSelectCurrentLocation: locationViewModel.addCurrentLocationPin)
                    if locationViewModel.routeStartPlacemark != nil {
                        SearchTextField(searchText: $locationViewModel.searchText, fetchedPlaces: locationViewModel.fetchedPlaces, onSelect: locationViewModel.addPin, placeholder: "Final location", value: locationViewModel.routeEndPlacemark,
                                        canSelectCurrentLocation: locationViewModel.currentUserLocation != locationViewModel.routeStartLocation,
                                        onSelectCurrentLocation: locationViewModel.addCurrentLocationPin)
                    }

                    if let preferredRoute = locationViewModel.preferredRoute {
                        Text(preferredRoute)
                            .padding()
                    }
                }
                .padding()
                .background(.white)

                Spacer()
            }
        }
    }
}

struct AddNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()
        return AddNewRouteView().environmentObject(viewModel)
    }
}
