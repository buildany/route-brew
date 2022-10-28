//
//  TransportTypeView.swift
//  RouteBrew
//
//  Created by km on 27/10/2022.
//

import SwiftUI
import MapKit

struct TransportTypeView: View {
    var transportType: MKDirectionsTransportType
    
    func getTransportTypeIcon(transportType: MKDirectionsTransportType) -> String {
        switch transportType {
        case .transit:
            return "bus.fill"
        case .automobile:
            return "car.fill"
        case .walking:
            return "figure.walk"
        default:
            return ""
        }
    }
    
    var body: some View {
        Image(systemName: getTransportTypeIcon(transportType: transportType))
            
    }
}

struct TransportTypeView_Previews: PreviewProvider {

    static var previews: some View {
        TransportTypeView(transportType: .walking)
    }
}
