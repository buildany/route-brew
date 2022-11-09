//
//  LocationEntity+CoreDataProperties.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var pin: Int16
    @NSManaged public var trip: TripEntity?

}

extension LocationEntity : Identifiable {

}
