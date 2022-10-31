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
                
                Spacer()

                Text("\(Int(route.travelTime / 60)) min.")
                    .font(.caption)
            }
        })
        .toggleStyle(SwitchToggleStyle(tint: .green.opacity(0.75)))
        .onChange(of: route.enabled) { _isOn in
            if _isOn {
                routeToggled(route.id)
            }
        }
        .disabled(route.enabled)
    }
}
