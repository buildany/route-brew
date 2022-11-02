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

struct NewTripFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var form: TripReactiveFormModel
    @State private var selection: String = "one"
    
    var trip: Trip

    
    init(trip: Trip, save: @escaping (Trip) -> Void) {
        self.trip = trip
        form = TripReactiveFormModel(trip: self.trip, save: save)
    }

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
                RouteConfigurationView(mode: .new)
            }
            .tag("one")

            VStack {
                NavigationStack {
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
                                form.saveTrip()
                                dismiss()
                            }
                            label: {
                                Text("Save")
                            }
                            .disabled(!form.trip.isValid)
                        }.padding()
                        AlarmSettingsConfigurationView()
                    }
                }
            }
            .tag("two")
        }
        .environmentObject(form)
    }
}

struct NewTripFormView_Previews: PreviewProvider {
    static var previews: some View {
        return NewTripFormView(trip: Trip(), save: {_ in} )
    }
}
