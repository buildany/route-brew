//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import CoreLocation
import LocalAuthentication
import SwiftUI

struct TripFormView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var form = TripReactiveFormModel()
    var save: (Trip) -> Void

    var body: some View {
        NavigationView {
            ZStack {
                MapView(mkMapView: form.mapView)
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        VStack(alignment: .leading) {
                            SearchTextField(searchText: $form.startSearchText, fetchedPlaces: form.startFetchedPlaces, onSelect: form.addStartPin, placeholder: "Start location", placemark: form.routeStartPlacemark,
                                            deletePlace: form.clearStartPlacemark, label: "a",
                                            canUseCurrentLocation: form.canUseCurrentLocation,
                                            onSelectCurrentLocation: form.addCurrentLocationPinAsStart)

                            SearchTextField(searchText: $form.endSearchText, fetchedPlaces: form.endFetchedPlaces, onSelect: form.addEndPin, placeholder: "Final location", placemark: form.routeEndPlacemark,
                                            deletePlace: form.clearEndPlacemark, label: "b",
                                            canUseCurrentLocation: form.canUseCurrentLocation,
                                            onSelectCurrentLocation: form.addCurrentLocationPinAsEnd)

                            if form.routes.count > 0 {
                                HStack {
                                    Text("Preferred routes".uppercased())
                                        .foregroundColor(.gray.opacity(0.75))
                                        .font(.caption)
                                        .padding(.top)
                                    Spacer()
                                }

                                ForEach(form.routes) { route in
                                    RouteView(route: route)
                                }

                                HStack {
                                    Text("Trip name".uppercased())
                                        .foregroundColor(.gray.opacity(0.75))
                                        .font(.caption)
                                        .padding(.top)
                                    Spacer()
                                }
                                TextField("Commute to school", text: $form.tripLabel)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .foregroundColor(.primary)
                                    .frame(alignment: .leading)
                                    
                            }
                        }.padding()
                    }.background(.white)

                    Spacer()
                }
            }
            .navigationTitle("Add new route")
            .toolbar {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Button("Save") {
                        save(form.getTrip())
                        dismiss()
                    }
                    .disabled(!form.saveAllowed)
                }
            }
        }
    }
}

struct TripFormView_Previews: PreviewProvider {
    static var previews: some View {
        return TripFormView(save: { _ in })
    }
}
