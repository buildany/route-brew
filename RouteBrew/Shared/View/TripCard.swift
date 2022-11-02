//
//  RouteCard.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import MapKit
import SwiftUI

struct TripCard: View {
    var trip: Trip
    
    var body: some View {
        if let route = trip.enabledRoute {
            HStack(alignment: .top) {
                Image(systemName: "alarm")
                    .font(.title)
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 5) {
                        Text(route.name)
                     
                    }.font(.caption)
                    Text(trip.alarmTime, format: .dateTime.hour().minute())
                        .font(.title)
        
                    HStack {
                        VStack {
                            Text(trip.label)
                                .font(.caption)
                                .padding(3)
                        }
                        .background(.blue.opacity(0.3))
                        .cornerRadius(4)
                    }
                }
               
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    HStack {
                        TimeIntervalView(timeInterval: route.travelTime)
                            .fontWeight(.bold)
                        TransportTypeView(transportType: MKDirectionsTransportType(rawValue: trip.transportType))
                            .font(.caption)
                    }
                    if !trip.repeatDays.isNever {
                        HStack {
                            Text(trip.repeatDays.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(7)
            .shadow(radius: 2)
        }
        else {
            Text("ROUTES ENABLED")
        }
    }
}

struct TripCard_Previews: PreviewProvider {
    static var previews: some View {
        let trip = Trip()
        trip.label = "morning"
        trip.addRoute(name: "Mijdrechtsedwarsweg", travelTime: 3200, enabled: true)
        trip.alarmTime = Date.now
        trip.repeatDays.selection = [false, false, true, true, false]
        return TripCard(trip: trip)
    }
}
