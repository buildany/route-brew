//
//  ContentView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = TripsViewModel()
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                TripsView()
                    .environmentObject(vm)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
