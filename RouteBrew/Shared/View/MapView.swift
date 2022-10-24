//
//  MapView.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var annotation = MKPointAnnotation()

    func makeUIView(context: Context) -> MKMapView {
        return locationViewModel.mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
