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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripsModel: TripsViewModel

    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            VStack {
                VStack {
                    SearchTextField(searchText: $tripsModel.startSearchText, fetchedPlaces: tripsModel.startFetchedPlaces, onSelect: tripsModel.addPin, placeholder: "Start location", value: tripsModel.routeStartPlacemark,
                                    canSelectCurrentLocation: tripsModel.canUseCurrentLocation,
                                    onSelectCurrentLocation: tripsModel.addCurrentLocationPin)
                    
                    SearchTextField(searchText: $tripsModel.endSearchText, fetchedPlaces: tripsModel.endFetchedPlaces, onSelect: tripsModel.addPin, placeholder: "Final location", value: tripsModel.routeEndPlacemark,
                                    canSelectCurrentLocation: tripsModel.canUseCurrentLocation,
                                    onSelectCurrentLocation: tripsModel.addCurrentLocationPin)

                    if let preferredRoute = tripsModel.preferredRoute {
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
        let viewModel = TripsViewModel()
        return AddNewRouteView().environmentObject(viewModel)
    }
}
