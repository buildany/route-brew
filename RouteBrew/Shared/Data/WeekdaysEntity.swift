//
//  WeekdaysEntity.swift
//  RouteBrew
//
//  Created by km on 09/11/2022.
//

import Foundation


extension WeekdaysEntity {
    var isNever: Bool {
        return [monday, tuesday, wednesday, thursday, friday, sunday, saturday].allSatisfy{
            $0 == false
        }
    }
    
    
    var values: [Bool] {
        return [monday, tuesday, wednesday, thursday, friday, sunday, saturday].map {
            $0?.boolValue ?? false
        }
    }
    
    
 
}
