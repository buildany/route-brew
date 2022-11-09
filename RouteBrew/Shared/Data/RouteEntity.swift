//
//  RouteEntity.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//

import Foundation


extension RouteEntity {
    var wrappedName: String {
        get {
            return name ?? "unknown"
        }
        set(newValue) {
            name = newValue
        }
    }
}
