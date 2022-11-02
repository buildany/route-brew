//
//  RoutesView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct TripsView: View {
    @State private var showingSheet = false
    @ObservedObject var tripsModel = TripsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if tripsModel.trips.count < 1 {
                    VStack {
                        Image(systemName: "alarm.fill")
                        Text("No route alarms")
                            .bold()
                    } .foregroundColor(.gray)
                    
                } else {

                    List {
                        ForEach(tripsModel.trips) { trip in
                            NavigationLink {
                                EditTripFormView(trip: trip, save: tripsModel.saveTrip)
                            } label: {
                                TripCard(trip: trip)
                            }
                        }
                        .onDelete(perform: tripsModel.removeTrip)
                       
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitle(Text("Route alarms"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if tripsModel.trips.count > 0 {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .sheet(isPresented: $showingSheet) {
                        NewTripFormView(trip: Trip(), save: tripsModel.saveTrip)
                    }
                }
            }
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        return TripsView()
    }
}
