//
//  RouteView.swift
//  RouteBrew
//
//  Created by km on 26/10/2022.
//

import MapKit
import SwiftUI
import Foundation

struct RouteView: View {
    @Binding var route: Route
    var routeToggled: (UUID) -> Void
    
    
    func formatInterval(_ timeInterval: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: route.travelTime)!
    }
    
    var body: some View {
        Toggle(isOn: $route.enabled, label: {
            HStack(spacing: 5) {
                Text(route.name)
                    .bold()
                
                Spacer()

                TimeIntervalView(timeInterval: route.travelTime)
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
