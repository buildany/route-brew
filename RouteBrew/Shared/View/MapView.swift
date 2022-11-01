//
//  MapView.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var routes: [Route]
    @EnvironmentObject var form: TripReactiveFormModel
    
    var mkMapView: MKMapView

    func makeUIView(context: Context) -> MKMapView {
        return mkMapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        form.redrawDirections()
    }
}
