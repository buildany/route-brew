//
//  TripModel.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Foundation

class TripModel: ObservableObject {
    @Published var trips: [Trip] = [Trip]()
}
