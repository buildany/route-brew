//
//  WeekdaysEntity+CoreDataProperties.swift
//  RouteBrew
//
//  Created by km on 18/11/2022.
//
//

import Foundation
import CoreData


extension WeekdaysEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeekdaysEntity> {
        return NSFetchRequest<WeekdaysEntity>(entityName: "WeekdaysEntity")
    }

    @NSManaged public var friday: NSNumber?
    @NSManaged public var monday: NSNumber?
    @NSManaged public var saturday: NSNumber?
    @NSManaged public var sunday: NSNumber?
    @NSManaged public var thursday: NSNumber?
    @NSManaged public var tuesday: NSNumber?
    @NSManaged public var wednesday: NSNumber?
    @NSManaged public var trip: TripEntity?

}

extension WeekdaysEntity : Identifiable {

}
