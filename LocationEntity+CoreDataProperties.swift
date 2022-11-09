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

    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longtitude: NSNumber?
    @NSManaged public var pin: NSNumber?
    @NSManaged public var trip: TripEntity?

}

extension LocationEntity : Identifiable {

}
