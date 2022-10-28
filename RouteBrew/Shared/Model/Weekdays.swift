//
//  Weekdays.swift
//  RouteBrew
//
//  Created by km on 27/10/2022.
//

import Foundation

enum Weekday: Int {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    var rawValue: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }

    var longValue: String {
        switch self {
        case .monday: return "Every Monday"
        case .tuesday: return "Every Tuesday"
        case .wednesday: return "Every Wednesday"
        case .thursday: return "Every Thursday"
        case .friday: return "Every Friday"
        case .saturday: return "Every Saturday"
        case .sunday: return "Every Sunday"
        }
    }
}

struct Weekdays {
    var selection: [Bool] = Array(repeating: false, count: 7)

    var rawValue: String {
        let result = selection.enumerated()
            .map { ($0, $1) }
            .filter { $0.1 }
            .map { Weekday(rawValue: $0.0)!.rawValue}
            .joined(separator: ", ")
        if result == "" {
            return "Never"
        }
        
        return result
    }

 
    static var all: [Weekday] {
        return [.monday,
                .tuesday,
                .wednesday,
                .thursday,
                .friday,
                .saturday,
                .sunday]
    }
}
