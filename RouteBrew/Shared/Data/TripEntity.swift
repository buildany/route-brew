//
//  TripEntity.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//

import Foundation

extension TripEntity {
    var wrappedLabel: String {
        get {
            return label ?? "unknown"
        }
        set(newValue) {
            label = newValue
        }
    }

    var wrappedRoutes: [RouteEntity] {
        return routes.array(of: RouteEntity.self)
    }
    
    var wrappedLocations: [LocationEntity] {
        return locations.array(of: LocationEntity.self)
    }
    
    
    var wrappedId: UUID {
        get {
            return id ?? UUID()
        }
        set (newValue) {
            id = newValue
        }
    }
 

    var wrappedTimeInterpretation: Int {
        get {
            return timeInterpretation?.intValue ?? 0
        }
        set(newValue) {
            timeInterpretation = newValue as NSNumber
        }
    }
    var wrappedTransportType: UInt {
        get {
            return transportType?.uintValue ?? 0
        }
        set(newValue) {
            transportType = newValue as NSNumber
        }
    }
    var wrappedAlarmTime: Date {
        get {
            return alarmTime ?? Date.now
        }
        set(newValue) {
            alarmTime = newValue
        }
    }
    
    var enabledRoute: RouteEntity? {
        return wrappedRoutes.first(where: {
            Bool(truncating: $0.enabled ?? 0)
        })
    }
   
}
