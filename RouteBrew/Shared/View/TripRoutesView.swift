//
//  TripRoutesView.swift
//  RouteBrew
//
//  Created by km on 28/10/2022.
//

import SwiftUI

struct TripRoutesView: View {
    @ObservedObject var trip: Trip
    
    
    func updateRoutes(toggled: UUID) {
        for (index, route) in trip.routes.enumerated() {
            if route.id != toggled {
                trip.routes[index].enabled = false
            }
        }
    }
    
    var body: some View {
        VStack {
            if trip.routes.count < 1 {
                Text("No routes found".uppercased())
                    .foregroundColor(.gray.opacity(0.75))
                    .font(.caption)
                    .padding(.top)
             
            } else {
                HStack {
                    Text("Preferred routes".uppercased())
                        .foregroundColor(.gray.opacity(0.75))
                        .font(.caption)
                        .padding(.top)
                    Spacer()
                }
                
                ForEach($trip.routes) { route in
                    RouteView(route: route, routeToggled: updateRoutes)
                }
            }
        }
    }
}
