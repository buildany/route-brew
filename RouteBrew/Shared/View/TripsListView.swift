//
//  RoutesListView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct TripsListView: View {
    var trips: [Trip]
    var removeTrip: (_ at: IndexSet) -> Void

    @State private var showingSheet = false

    var body: some View {
        VStack {
            HStack {
                Text("Your tracked routes".uppercased())
                    .bold()
                    .foregroundColor(.red.opacity(0.75))
                    .padding()
                Spacer()
            }

            ForEach(trips) { trip in
                TripCard(trip: trip)
            }
        }
        .padding()
    }
}

struct TripsListView_Previews: PreviewProvider {
    static var previews: some View {
        return TripsListView(trips: [], removeTrip: { _ in })
    }
}
