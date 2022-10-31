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
    
    var mkMapView: MKMapView

    func makeUIView(context: Context) -> MKMapView {
        return mkMapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let preferredRoute:Route? = routes.first {
            route in route.enabled
        }
        var overlays: [MKPolylineRenderer] = []
        var enabled: MKPolylineRenderer?
        
        for overlay in uiView.overlays {
            if let pr = preferredRoute,  overlay.subtitle == pr.id.uuidString {
                enabled = MKPolylineRenderer(overlay: overlay)
            } else {
                overlays.append(MKPolylineRenderer(overlay: overlay))
            }
        }
        
        uiView.removeOverlays(uiView.overlays)
        for renderer in overlays {
            uiView.addOverlay(renderer.polyline, level: .aboveRoads)
        }
        
        if let prRenderer = enabled {
            uiView.addOverlay(prRenderer.polyline, level: .aboveRoads)
        }
    }
}
