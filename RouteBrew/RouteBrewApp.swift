//
//  RouteBrewApp.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

@main
struct RouteBrewApp: App {
    @StateObject var locationViewModel = LocationViewModel()
 
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(locationViewModel)
        }
    }
}
