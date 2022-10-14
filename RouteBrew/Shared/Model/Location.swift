//
//  Location.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var label: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    static let example1 = Location(id: UUID(), label: "Home", latitude: 52.211525, longitude: 5.924628)
    static let example2 = Location(id: UUID(), label: "Work", latitude: 52.0057008, longitude: 5.8265593)
}
