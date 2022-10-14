//
//  RouteCard.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import SwiftUI

struct RouteCard: View {
    var route: Route
    var body: some View {
        VStack(alignment: .leading) {
            Text(route.name)
                .accessibilityAddTraits(.isHeader)
                .font(.title3)
            Spacer()
            HStack {
                Label("31 minutes", systemImage: "clock.arrow.circlepath")
                Spacer()
                Label("Workdays", systemImage: "calendar")
                    .labelStyle(.trailingIcon)
            }
            
        }
        .padding()
    }
}

struct RouteCard_Previews: PreviewProvider {
    static var previews: some View {
        RouteCard(route: Route.example)
    }
}
