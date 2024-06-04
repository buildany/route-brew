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
    
    var wrappedEnabled: Bool {
        get {
            return Bool(truncating: self.enabled ?? 0)
        }
        set(newValue) {
            self.enabled = newValue as NSNumber
        }
    }
    
    var wrappedTravelTime: Double {
        get {
            return Double(truncating: self.travelTime ?? 0)
        }
        set(newValue) {
            self.travelTime = newValue as NSNumber
        }
    }
    
}
