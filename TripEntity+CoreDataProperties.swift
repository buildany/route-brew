//
//  TripEntity+CoreDataProperties.swift
//  RouteBrew
//
//  Created by km on 18/11/2022.
//
//

import Foundation
import CoreData


extension TripEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TripEntity> {
        return NSFetchRequest<TripEntity>(entityName: "TripEntity")
    }

    @NSManaged public var alarmTime: Date?
    @NSManaged public var label: String?
    @NSManaged public var timeInterpretation: NSNumber?
    @NSManaged public var transportType: NSNumber?
    @NSManaged public var id: UUID?
    @NSManaged public var locations: NSSet?
    @NSManaged public var repeatDays: WeekdaysEntity?
    @NSManaged public var routes: NSSet?

}

// MARK: Generated accessors for locations
extension TripEntity {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: LocationEntity)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: LocationEntity)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}

// MARK: Generated accessors for routes
extension TripEntity {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: RouteEntity)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: RouteEntity)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}

extension TripEntity : Identifiable {

}
