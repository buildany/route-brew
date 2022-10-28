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
    @State private var selection: String = "two"

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
                        .disabled(!form.saveAllowed)
                }
                .padding()
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Picker("Transport type", selection: $form.transportType) {
                            ForEach(form.availableTransportTypes, id: \.self) {
                                TransportTypeView(transportType: MKDirectionsTransportType(rawValue: $0))
                            }
                        }
                        .pickerStyle(.segmented)
                        SearchTextField(searchText: $form.startSearchText, fetchedPlaces: form.startFetchedPlaces, onSelect: form.addStartPin, placeholder: "Start location", placemark: form.routeStartPlacemark,
                                        deletePlace: form.clearStartPlacemark, label: "a",
                                        canUseCurrentLocation: form.canUseCurrentLocation,
                                        onSelectCurrentLocation: form.addCurrentLocationPinAsStart)
                            
                        SearchTextField(searchText: $form.endSearchText, fetchedPlaces: form.endFetchedPlaces, onSelect: form.addEndPin, placeholder: "Final location", placemark: form.routeEndPlacemark,
                                        deletePlace: form.clearEndPlacemark, label: "b",
                                        canUseCurrentLocation: form.canUseCurrentLocation,
                                        onSelectCurrentLocation: form.addCurrentLocationPinAsEnd)
                            
                        if form.saveAllowed {
                            VStack {
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
                            }
                        }
                    }.padding()
                }.background(.white)
                    
                MapView(mkMapView: form.mapView)
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
                            .disabled(!form.saveAllowed)
                        }.padding()
                        VStack {
                            Form {
                                Picker("Time interpretation", selection: $form.timeInterpretation) {
                                    ForEach([TimeInterpretation.departure, TimeInterpretation.arrival], id: \.self) {
                                        TimeInterpretationView(timeInterpretation: $0)
                                    }
                                }
                                .pickerStyle(.segmented)
                                DatePicker(selection: $form.alarmTime, displayedComponents: .hourAndMinute, label: {})
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                
                                NavigationLink {
                                    WeekdaysSelectorView(weekdays: $form.repeatDays)
                                } label: {
                                    HStack {
                                        Text("Repeat")
                                            .foregroundColor(.gray.opacity(0.8))
                                        Spacer()
                                        Text(form.repeatDays.rawValue)
                                    }
                                }
                                
                                HStack {
                                    Text("Label")
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray.opacity(0.8))
                                    Spacer()
                                    TextField("My commute", text: $form.tripLabel).textFieldStyle(.plain)
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
