//
//  AuthorizationManager.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import Foundation
import LocalAuthentication


enum AuthorizationState {
    case granted, error, noBiomentrics, undefined
}

@MainActor class AuthorizationManager: ObservableObject {
    @Published private(set) var isUserAccessGranted: AuthorizationState = .undefined
    @Published private(set) var error = false
    
    init() {
        authenticateUserWithBiometrics()
    }


    func authenticateUserWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                if success {
                    Task {
                        @MainActor in
                        self.isUserAccessGranted = .granted
                    }

                } else {
                    self.isUserAccessGranted = .error
                }
            }
        } else {
            self.isUserAccessGranted = .noBiomentrics
        }
    }
}
