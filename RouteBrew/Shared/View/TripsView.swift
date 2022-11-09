//
//  RoutesView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct TripsView: View {
    @State private var showingSheet = false
    @EnvironmentObject var vm: TripsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.trips.count < 1 {
                    VStack {
                        Image(systemName: "alarm.fill")
                        Text("No route alarms")
                            .bold()
                    } .foregroundColor(.gray)
                    
                } else {

                    ScrollView {
                        ForEach(vm.trips) { trip in
                            NavigationLink {
//                                EditTripFormView(trip: trip, save: vm.saveTrip)
                            } label: {
                                TripCard(trip: trip)
                            }
                        }
                        .onDelete(perform: vm.removeTrip)
                       
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitle(Text("Route alarms"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if vm.trips.count > 0 {
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
                        NewTripFormView(trip: Trip(), save: vm.saveTrip)
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
