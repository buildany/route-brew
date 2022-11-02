//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import CoreLocation
import LocalAuthentication
import MapKit
import SwiftUI

enum Mode {
    case new, edit
}

struct RouteConfigurationView: View {
    @EnvironmentObject var form: TripReactiveFormModel
    var mode: Mode

    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Picker("Transport type", selection: $form.trip.transportType) {
                        ForEach(form.trip.availableTransportTypes, id: \.self) {
                            TransportTypeView(transportType: MKDirectionsTransportType(rawValue: $0))
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: form.trip.transportType) { _ in
                        Task {
                            await MainActor.run(body: {
                                form.requestDirections()
                            })
                        }
                    }
                    SearchTextField(searchText: $form.startSearchText, fetchedPlaces: form.startFetchedPlaces, onSelect: form.addStartPin, placeholder: "Start location", placemark: form.trip.startPlacemark,
                                    deletePlace: form.clearStartPlacemark, label: "a",
                                    canUseCurrentLocation: form.canUseCurrentLocation,
                                    onSelectCurrentLocation: form.addCurrentLocationPinAsStart)

                    SearchTextField(searchText: $form.endSearchText, fetchedPlaces: form.endFetchedPlaces, onSelect: form.addEndPin, placeholder: "Final location", placemark: form.trip.endPlacemark,
                                    deletePlace: form.clearEndPlacemark, label: "b",
                                    canUseCurrentLocation: form.canUseCurrentLocation,
                                    onSelectCurrentLocation: form.addCurrentLocationPinAsEnd)

                    if form.trip.isValid {
                        TripRoutesView(trip: form.trip)
                    }
                }.padding()
            }.background(.white)

            MapView(routes: $form.trip.routes, mkMapView: form.mapView)
                .ignoresSafeArea()
        }
    }
}

struct RouteConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        return RouteConfigurationView(mode: .new)
    }
}
