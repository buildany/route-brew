//
//  DataController.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//

import CoreData
import Foundation

class DataController {
    static let instance = DataController()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "RouteBrewDataContainer")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        context = container.viewContext
        
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("error saving Core Data. \(error.localizedDescription)")
        }
    }
}
