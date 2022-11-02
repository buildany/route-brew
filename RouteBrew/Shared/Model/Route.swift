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
    var id: UUID = .init()
    var name: String
    var travelTime: Double
    var enabled: Bool

    init(name: String, travelTime: Double, enabled: Bool) {
        self.name = name
        self.travelTime = travelTime
        self.enabled = enabled
    }

    static func ==(route1: Route, route2: Route) -> Bool {
        route1.id == route2.id
    }
}
