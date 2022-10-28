//
//  Route.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Foundation
import CoreLocation
import MapKit

class Route: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var travelTime: Double
    var enabled: Bool = false
    var transportType: MKDirectionsTransportType

    static func ==(route1: Route, route2: Route) -> Bool {
        route1.id == route2.id
    }

    init(name: String, travelTime: Double, transportType: MKDirectionsTransportType, enabled: Bool = false) {
        self.id = UUID()
        self.name = name
        self.enabled = enabled
        self.transportType = transportType
        self.travelTime = travelTime
    }

    static let example = Route(name: "Home", travelTime: 10000, transportType: .any, enabled: true)
}
