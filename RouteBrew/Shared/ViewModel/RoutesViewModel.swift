//
//  ContentView-ViewModel.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Foundation

@MainActor class RoutesViewModel: ObservableObject {
    @Published private(set) var routes = [Route]()
    

    func removeRoute(at offsets: IndexSet) {
        routes.remove(atOffsets: offsets)
    }

    func addRoute(name: String, startLocation: (Double, Double, String), endLocation: (Double, Double, String)) {
        let (startLat, startLong, startLabel) = startLocation
        let (endLat, endLong, endLabel) = endLocation
        let newRoute = Route(id: UUID(),
                             name: name,
                             start: Location(id: UUID(), label: startLabel, latitude: startLat, longitude: startLong),
                             end: Location(id: UUID(), label: endLabel, latitude: endLat, longitude: endLong))
        routes.append(newRoute)
    }
}
