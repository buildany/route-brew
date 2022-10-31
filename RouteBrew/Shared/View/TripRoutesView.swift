//
//  TripRoutesView.swift
//  RouteBrew
//
//  Created by km on 28/10/2022.
//

import SwiftUI

struct TripRoutesView: View {
    @Binding var routes: [Route]
    var toggleRouteCallback: (UUID) -> Void
    
   
    var body: some View {
        VStack {
            HStack {
                Text("Preferred routes".uppercased())
                    .foregroundColor(.gray.opacity(0.75))
                    .font(.caption)
                    .padding(.top)
                Spacer()
            }
            
            ForEach($routes) { route in
                RouteView(route: route, routeToggled: toggleRouteCallback)
            }
        }
    }
    
}
