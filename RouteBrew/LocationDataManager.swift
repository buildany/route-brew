//
//  LocationDataManager.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import CoreLocation
import Foundation

class LocationDataManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var locationFeaturesEnabled: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationAccess() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }

        guard locationManager.authorizationStatus == .authorizedAlways else {
            return
        }
        
        locationManager.requestAlwaysAuthorization()
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            print("location manager authorization status changed")
//            
//            switch status {
//            case .authorizedAlways:
//                print("user allow app to get location data when app is active or in background")
//            case .authorizedWhenInUse:
//                print("user allow app to get location data only when app is active")
//            case .denied:
//                print("user tap 'disallow' on the permission dialog, cant get location data")
//            case .restricted:
//                print("parental control setting disallow location data")
//            case .notDetermined:
//                print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
//            @unknown default:
//                <#fatalError()#>
//            }
//        }

    func disableLocationFeatures() {
        print("Location features are disabled")
        locationFeaturesEnabled = false
    }

    func enableLocationFeatures() {
        print("Location features are enabled")
        locationFeaturesEnabled = true
    }

    func locationManagerDidChangeAuthorization() {
        print("locationManagerDidChangeAuthorization")
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse,
             .authorizedAlways:
            enableLocationFeatures()

        case .restricted, .denied:
            disableLocationFeatures()

        case .notDetermined:
            requestLocationAccess()

        default:
            break
        }
    }
}
