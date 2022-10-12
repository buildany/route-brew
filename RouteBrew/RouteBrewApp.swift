//
//  RouteBrewApp.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

@main
struct RouteBrewApp: App {
    @StateObject var viewModel = ViewModel()
    
    init() {
        viewModel.authenticateUserWithBiometrics()
    }
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isUserAccessUnlocked {
                ContentView().environmentObject(viewModel)
            } else {
                LockedAppView()
            }
        }
    }
}
