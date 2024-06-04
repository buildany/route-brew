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
        
        getTrips()
    }

    func getWeekdaysEntity(_ weekdays: Weekdays) -> WeekdaysEntity {
        let e = WeekdaysEntity(context: manager.context)
        e.monday = weekdays.selection[0] as NSNumber
        e.tuesday = weekdays.selection[1] as NSNumber
        e.wednesday = weekdays.selection[2] as NSNumber
        e.thursday = weekdays.selection[3] as NSNumber
        e.friday = weekdays.selection[4] as NSNumber
        e.saturday = weekdays.selection[5] as NSNumber
        e.sunday = weekdays.selection[6] as NSNumber
        
        return e
    }


    func saveTrip(trip: Trip?) {
        guard let newTrip = trip else { return }
        
        let newEntity = TripEntity(context: manager.context)
        newEntity.label = newTrip.label
        newEntity.repeatDays = getWeekdaysEntity(newTrip.repeatDays)
        newEntity.transportType  = newTrip.transportType as NSNumber
        newEntity.alarmTime = newTrip.alarmTime
        newEntity.timeInterpretation = newTrip.timeInterpretation.rawValue as NSNumber
        
        for route in newTrip.routes {
            let newRouteEntity = RouteEntity(context: manager.context)
            newRouteEntity.wrappedName = route.name
            newRouteEntity.id = route.id
            newRouteEntity.enabled = route.enabled as NSNumber
            newRouteEntity.travelTime = route.travelTime as NSNumber
            
            newEntity.addToRoutes(newRouteEntity)
        }
        
        if let startCoordinate = newTrip.startPlacemark?.location?.coordinate {
            let startLocation = LocationEntity(context: manager.context)
            startLocation.pin = RoutePin.start.rawValue as NSNumber
            startLocation.latitude = startCoordinate.latitude as NSNumber
            startLocation.longtitude = startCoordinate.longitude as NSNumber
            
            newEntity.addToLocations(startLocation)
        }
        
        
        if let endCoordinate = newTrip.endPlacemark?.location?.coordinate {
            let endLocation = LocationEntity(context: manager.context)
            endLocation.pin = RoutePin.end.rawValue as NSNumber
            endLocation.latitude = endCoordinate.latitude as NSNumber
            endLocation.longtitude = endCoordinate.longitude as NSNumber
            
            newEntity.addToLocations(endLocation)
        }
        
        save()
    }
}
