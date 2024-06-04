//
//  RouteCard.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import MapKit
import SwiftUI

struct TripCard: View {
    @ObservedObject var trip: TripEntity
    
    var body: some View {
        if let route = trip.enabledRoute {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 5) {
                        Text(route.wrappedName)
                     
                    }.font(.caption)
                    Text(trip.wrappedAlarmTime, format: .dateTime.hour().minute())
                        .font(.title)
        
                    HStack {
                        VStack {
                            Text(trip.wrappedLabel)
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
                        TimeIntervalView(timeInterval: route.wrappedTravelTime)
                            .fontWeight(.bold)
                        TransportTypeView(transportType: MKDirectionsTransportType(rawValue: trip.wrappedTransportType))
                            .font(.caption)
                    }
                    if let repeatSchedule = trip.repeatDays {
                        if !repeatSchedule.isNever {
                            HStack {
                                Text(Weekdays.getRawValue(entity: trip.repeatDays))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
      
        }
        else {
            Text("ROUTES ENABLED")
        }
    }
}

