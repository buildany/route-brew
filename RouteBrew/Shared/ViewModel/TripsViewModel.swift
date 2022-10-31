//
//  NewTopReactiveForm.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation


class TripsViewModel: ObservableObject {
    @Published var trips: [Trip] = [Trip]()
    
    func removeTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
    }
    
    func addTrip(trip: Trip?) {
        guard let newTrip = trip else { return }
        for route in newTrip.routes {
            print ("name - \(route.name) - \(route.enabled)")
        }
        trips.append(newTrip)
    }
    
}
