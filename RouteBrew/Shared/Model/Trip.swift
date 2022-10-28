//
//  RoutesModel.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation

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
    var id: UUID = UUID()
    var routes: [Route] 
    var label: String
    var timeInterpretation: TimeInterpretation

    static var defaultTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 45
        return Calendar.current.date(from: components) ?? Date.now
    }

    var alarmTime: Date = defaultTime
    var weekdays: Weekdays
    
    static func ==(trip1: Trip, trip2: Trip) -> Bool {
        trip1.id == trip2.id
    }
    
    init(routes: [Route], label: String, alarmTime: Date, weekdays: Weekdays) {
        self.routes = routes
        self.label = label == "" ? "Label" : label
        self.id = UUID()
        self.alarmTime = alarmTime
        self.weekdays = weekdays
        self.timeInterpretation = .departure
    }
}
