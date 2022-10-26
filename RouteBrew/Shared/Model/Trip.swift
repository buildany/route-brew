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

struct Trip: Identifiable, Equatable {
    var routes: [Route] 
    var label: String
    var id: UUID = UUID()
    
    static var defaultDepartureTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 45
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    static var defaultSchedule: [Day] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday]
    
    var departureTime: Date = defaultDepartureTime
    var schedule: [Day] = defaultSchedule
    
    static func ==(trip1: Trip, trip2: Trip) -> Bool {
        trip1.id == trip2.id
    }
}
