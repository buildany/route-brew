//
//  Route.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Combine
import Foundation
import SwiftUI

struct Route: Identifiable, Equatable, Hashable {
    var id: UUID
    var name: String
    var travelTime: Double
    var enabled: Bool
    
    init(from: RouteEntity) {
        self.name = from.wrappedName
        self.travelTime = from.wrappedTravelTime
        self.enabled = from.wrappedEnabled
        self.id = from.id ?? UUID()
    }

    init(name: String, travelTime: Double, enabled: Bool) {
        self.id = .init()
        self.name = name
        self.travelTime = travelTime
        self.enabled = enabled
    }

    static func ==(route1: Route, route2: Route) -> Bool {
        route1.id == route2.id
    }
}
