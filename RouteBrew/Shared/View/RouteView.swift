//
//  RouteView.swift
//  RouteBrew
//
//  Created by km on 26/10/2022.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @State var enabled: Bool {
        didSet {
            route.enabled = enabled
        }
    }

    var route: Route

    init(route: Route) {
        self.route = route
        self.enabled = route.enabled
    }


    var body: some View {
        Toggle(isOn: $enabled, label: {
            HStack(spacing: 5) {
                Text(route.name)
                    .bold()
                TransportTypeView(transportType: route.transportType)
                  
                    .foregroundColor(.gray)
                Spacer()
                
                Text("\(Int(route.travelTime/60)) min.")
                    .font(.caption)
            }
        })
        .toggleStyle(SwitchToggleStyle(tint: .green.opacity(0.75)))
    }
}
