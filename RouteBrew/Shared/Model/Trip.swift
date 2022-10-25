//
//  RoutesModel.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation

enum Day {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

class Trip: Identifiable, Equatable {
    var routes: [Route] = [Route]()
    var id: UUID = UUID()
    
    static var defaultDepartureTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 45
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    static var defaultCommuteDays: [Day] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
    
    var departureTime: Date = defaultDepartureTime
    var commuteDays: [Day] = defaultCommuteDays
    
    static func ==(trip1: Trip, trip2: Trip) -> Bool {
        trip1.id == trip2.id
    }
}
