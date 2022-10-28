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
        HStack {
            VStack(alignment: .leading) {
                Text(trip.label)
                    .accessibilityAddTraits(.isHeader)
                    .font(.title3)
                Text(trip.label)
                    .accessibilityAddTraits(.isHeader)
                    .font(.caption)
            }
            Spacer()
            Image(systemName: "trash")
                .foregroundColor(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(7)
        .shadow(radius: 2)
    }
}

struct RouteCard_Previews: PreviewProvider {
    static var previews: some View {
        TripCard(trip: Trip(routes: [], label: "Default trip", alarmTime: Date.now, weekdays: Weekdays()))
    }
}
