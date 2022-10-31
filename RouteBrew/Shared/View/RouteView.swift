//
//  RouteView.swift
//  RouteBrew
//
//  Created by km on 26/10/2022.
//

import MapKit
import SwiftUI

struct RouteView: View {
    @Binding var route: Route
    var routeToggled: (UUID) -> Void

    var body: some View {
        Toggle(isOn: $route.enabled, label: {
            HStack(spacing: 5) {
                Text(route.name)
                    .bold()
                TransportTypeView(transportType: route.transportType)

                    .foregroundColor(.gray)
                Spacer()

                Text("\(Int(route.travelTime / 60)) min.")
                    .font(.caption)
            }
        })
        .toggleStyle(SwitchToggleStyle(tint: .green.opacity(0.75)))
        .onReceive([route.enabled].publisher.first()) { _ in
            routeToggled(route.id)
        }
    }
}
