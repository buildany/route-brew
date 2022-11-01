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

enum Tab {
    case one, two
}

struct TripFormView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var form: TripReactiveFormModel
    @State private var selection: String = "one"

    var save: (Trip) -> Void

    var body: some View {
        TabView(selection: $selection) {
            VStack {
                HStack {
                    Button { dismiss() }
                    label: {
                            Text("Cancel")
                        }
                    Spacer()
                    Text("Route selection".uppercased())
                        .foregroundColor(.gray.opacity(0.75))
                    Spacer()
                    Button { self.selection = "two" }
                    label: {
                            Text("Next")
                        }
                        .disabled(!form.trip.isValid)
                }
                .padding()
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
            .tag("one")

            VStack {
                NavigationView {
                    VStack {
                        HStack {
                            Button { self.selection = "one" }
                            label: {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Map")
                                    }
                                }
                            Spacer()
                            Text("Alarm settings".uppercased())
                                .foregroundColor(.gray.opacity(0.75))

                            Spacer()
                            Button {
                                save(form.getTrip())
                                dismiss()
                            }
                            label: {
                                Text("Save")
                            }
                            .disabled(!form.trip.isValid)
                        }.padding()
                        VStack {
                            Form {
                                Picker("Time interpretation", selection: $form.trip.timeInterpretation) {
                                    ForEach([TimeInterpretation.departure, TimeInterpretation.arrival], id: \.self) {
                                        TimeInterpretationView(timeInterpretation: $0)
                                    }
                                }
                                .pickerStyle(.segmented)
                                DatePicker(selection: $form.trip.alarmTime, displayedComponents: .hourAndMinute, label: {})
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()

                                NavigationLink {
                                    WeekdaysSelectorView(weekdays: $form.trip.repeatDays)
                                } label: {
                                    HStack {
                                        Text("Repeat")
                                            .foregroundColor(.gray.opacity(0.8))
                                        Spacer()
                                        Text(form.trip.repeatDays.rawValue)
                                    }
                                }

                                HStack {
                                    Text("Label")
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray.opacity(0.8))
                                    Spacer()
                                    TextField("My commute", text: $form.trip.label).textFieldStyle(.plain)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.red.opacity(0.75))
                                }
                            }
                        }
                    }
                }
            }
            .tag("two")
        }
    }
}

struct TripFormView_Previews: PreviewProvider {
    static var previews: some View {
        return TripFormView(save: { _ in })
    }
}
