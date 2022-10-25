//
//  RoutesListView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct TripsListView: View {
    @EnvironmentObject var tripsModel: TripsViewModel
    @State private var showingSheet = false

    var body: some View {
        if tripsModel.trips.count == 0 {
            NoRoutesView()
        } else {
            VStack {
                List {
                    ForEach(tripsModel.trips) { trip in
                        TripCard(trip: trip)
                    }.onDelete(perform: removeRoute)
                }
            }
        }
    }

    func removeRoute(at offsets: IndexSet) {
        tripsModel.removeTrip(at: offsets)
    }
}

struct TripsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TripsViewModel()
       
        return TripsListView().environmentObject(viewModel)
    }
}
