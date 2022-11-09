//
//  NewTopReactiveForm.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import CoreData
import Foundation

class TripsViewModel: ObservableObject {
    @Published var trips: [TripEntity] = []
    let manager = DataController.instance
    
    
    init() {
        getTrips()
    }
    
    func removeTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
    }
    
    func getTrips() {
        let request = NSFetchRequest<TripEntity>(entityName: "TripEntity")
        
        do {
            trips = try manager.context.fetch(request)
            
            
        } catch {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    func save() {
        manager.save()
        print("Save successfully")
    }

    func saveTrip(trip: Trip?) {
//        guard let newTrip = trip else { return }
        
//        if let existingTripIndex = trips.firstIndex(where: {$0.id == newTrip.id}) {
//            trips[existingTripIndex] = newTrip
//        }
//        else {
//            trips.append(newTrip)
//        }
    }
}
