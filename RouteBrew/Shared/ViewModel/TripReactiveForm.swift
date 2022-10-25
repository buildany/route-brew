//
//  NewTopReactiveForm.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation


class TripReactiveForm: ObservableObject {
    @Published var trip: Trip = Trip()
    @Published var startSearchText: String = ""
    @Published var endSearchText: String = ""
    
    
    
}
