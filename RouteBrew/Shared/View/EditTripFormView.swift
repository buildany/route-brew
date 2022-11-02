//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import MapKit
import SwiftUI

struct EditTripFormView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var form: TripReactiveFormModel
    @State private var selection: String = "one"

    var trip: Trip

    init(trip: Trip, save: @escaping (Trip) -> Void) {
        self.trip = trip
        form = TripReactiveFormModel(trip: self.trip, save: save)
    }

    
    var body: some View {
        VStack {
            RouteConfigurationView(mode: .new).environmentObject(form)
        }
        .navigationBarTitle(Text("Edit Alarm"), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AlarmSettingsConfigurationView().environmentObject(form)
                } label: {
                    Text("Next")
                }
            }
        }
    }
        
}

struct EditTripFormView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTripFormView(trip: Trip(), save: { _ in })
    }
}
