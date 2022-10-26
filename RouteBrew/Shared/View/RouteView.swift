//
//  RouteView.swift
//  RouteBrew
//
//  Created by km on 26/10/2022.
//

import SwiftUI

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
            HStack {
                Text(route.name)
                    .bold()
                Spacer()
                Text("\(Int(route.travelTime/60)) min.")
                    .font(.caption)
            }
        })
        .toggleStyle(SwitchToggleStyle(tint: .red.opacity(0.75)))
    }
}
