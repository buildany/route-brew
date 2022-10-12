//
//  ContentView-ViewModel.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import CoreLocation
import Foundation
import LocalAuthentication

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var isUserAccessUnlocked = false
    @Published private(set) var routes = [Route]()


    func authenticateUserWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                if success {
                    Task {
                        @MainActor in
                        self.isUserAccessUnlocked = true
                    }

                } else {
                    // error
                }
            }
        } else {
            // no biometrics
        }
    }

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
