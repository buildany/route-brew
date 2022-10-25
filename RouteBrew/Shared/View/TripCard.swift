//
//  RouteCard.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import SwiftUI

struct TripCard: View {
    var trip: Trip
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trip to School")
                .accessibilityAddTraits(.isHeader)
                .font(.title3)
           
            
        }
        .padding()
    }
}

struct RouteCard_Previews: PreviewProvider {
    static var previews: some View {
        TripCard(trip: Trip())
    }
}
