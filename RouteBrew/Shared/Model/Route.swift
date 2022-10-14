//
//  Route.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Foundation
import CoreLocation

struct Route: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var start: Location
    var end: Location
    var color: String?

    static func ==(route1: Route, route2: Route) -> Bool {
        route1.id == route2.id
    }

    static let example = Route(id: UUID(), name: "Home", start: Location(id: UUID(), label: "Home", latitude: 52.211525, longitude: 5.924628), end: Location(id: UUID(), label: "Work", latitude: 52.0057008, longitude: 5.8265593))
}
