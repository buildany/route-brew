//
//  ContentView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var tripsModel = TripsViewModel()
    @ObservedObject var form = TripReactiveFormModel()
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                TripsView()
            }

        }.environmentObject(form)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
