//
//  RouteEntity+CoreDataProperties.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//
//

import Foundation
import CoreData


extension RouteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RouteEntity> {
        return NSFetchRequest<RouteEntity>(entityName: "RouteEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var travelTime: Double
    @NSManaged public var enabled: Bool
    @NSManaged public var trip: TripEntity?

}

extension RouteEntity : Identifiable {

}
