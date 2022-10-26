//
//  Route.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Foundation
import CoreLocation

class Route: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var travelTime: Double
    var enabled: Bool = false

    static func ==(route1: Route, route2: Route) -> Bool {
        route1.id == route2.id
    }

    init(name: String, travelTime: Double, enabled: Bool = false) {
        self.id = UUID()
        self.name = name
        self.enabled = enabled
        self.travelTime = travelTime
    }

    static let example = Route(name: "Home", travelTime: 10000, enabled: true)
}
