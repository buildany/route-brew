//
//  RoutesModel.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation
import MapKit

enum TimeInterpretation {
    case departure, arrival
    
    var rawValue: String {
        switch self {
        case .departure: return "departure"
        case .arrival: return "arrival"
        }
    }
}

struct Trip: Identifiable, Equatable {
    var id: UUID = .init()
    var routes: [Route] = []
    var label: String = "My trip"
    var timeInterpretation: TimeInterpretation = .departure
    var transportType = MKDirectionsTransportType.automobile.rawValue
    static var defaultTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 45
        return Calendar.current.date(from: components) ?? Date.now
    }

    var alarmTime: Date = defaultTime
    var repeatDays = Weekdays()
    
    static func ==(trip1: Trip, trip2: Trip) -> Bool {
        trip1.id == trip2.id
    }
    
    mutating func updateRoutes(toggled: UUID) {
        for (index, route) in routes.enumerated() {
            if route.id != toggled {
                routes[index].enabled = false
            }
        }
    }
}
