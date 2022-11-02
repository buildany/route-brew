//
//  NewTopReactiveForm.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation

class TripsViewModel: ObservableObject {
    @Published var trips: [Trip] = .init()

    func removeTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
    }

    func saveTrip(trip: Trip?) {
        guard let newTrip = trip else { return }
        
        if let existingTripIndex = trips.firstIndex(where: {$0.id == newTrip.id}) {
            trips[existingTripIndex] = newTrip
        }
        else {
            trips.append(newTrip)
        }
    }
}
