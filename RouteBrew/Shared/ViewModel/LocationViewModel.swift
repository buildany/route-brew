//
//  LocationDataManager.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import Combine
import CoreLocation
import Foundation
import MapKit

enum RouteSelection {
    case start, end, done
}

enum LocationServiceStatus {
    case enabled, disabled, error, undefined
}

class LocationViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var manager = CLLocationManager()

    @Published private(set) var locationServiceStatus: LocationServiceStatus = .undefined
    @Published var mapView: ExtendedMapView = .init()
    @Published private(set) var routes = [Route]()
    @Published var searchText: String = ""
    @Published private(set) var fetchedPlaces: [CLPlacemark]?
    private(set) var cancellable: AnyCancellable?
    @Published private(set) var currentUserLocation: CLLocation?

    @Published var routeStartLocation: CLLocation?
    @Published var routeEndLocation: CLLocation?
    @Published var routeStartPlacemark: CLPlacemark?
    @Published var routeEndPlacemark: CLPlacemark?

    @Published var route: [CLPlacemark] = .init()
    @Published var routeRefs: [String: (Double, UIColor, Bool)] = [:]
    @Published var preferredRoute: String?

    let startPinIdentifier = "STARTPINIDENTIFIER"
    let endPinIdentifier = "ENDINIDENTIFIER"
    
    @Published var routeSelection: RouteSelection = .start {
        didSet {
            if routeSelection == .done {
                self.requestDirections()
            } else if routeSelection == .start {
                self.mapView.removeOverlays(self.mapView.overlays)
            }
        }
    }


    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self
        mapView.onLongPress = addAnnotation(for:)

        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
            })
    }

    func fetchPlaces(value: String) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()

                let response = try await MKLocalSearch(request: request).start()

                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap { item -> CLPlacemark? in
                        item.placemark
                    }
                })
            } catch {}
        }
    }

    func requestDirections() {
        guard let startLocation = routeStartLocation else { return }
        guard let endLocation = routeEndLocation else { return }

        let request = MKDirections.Request()
        let sourcePlaceMark = MKPlacemark(coordinate: startLocation.coordinate)
        request.source = MKMapItem(placemark: sourcePlaceMark)

        let destPlaceMark = MKPlacemark(coordinate: endLocation.coordinate)
        request.destination = MKMapItem(placemark: destPlaceMark)
        request.transportType = [.automobile]
        request.requestsAlternateRoutes = true

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "No error specified").")

                self.locationServiceStatus = .error
                return
            }

            let minTravelTime = response.routes.map { $0.expectedTravelTime }.min()

            for route in response.routes.sorted(by: { $0.expectedTravelTime > $1.expectedTravelTime }) {
                print("\(route.name), \(route.expectedTravelTime)")
                let routeName = String(route.name.hashValue)
                
                let routeExpectedTravelTime = Double(route.expectedTravelTime)
                let routeColor = route.expectedTravelTime == minTravelTime ? UIColor.blue : UIColor.gray
                let isRoutePreferred = minTravelTime == route.expectedTravelTime

                self.routeRefs[routeName] = (routeExpectedTravelTime, routeColor, isRoutePreferred)
                if isRoutePreferred {
                    self.preferredRoute = routeName
                }
                route.polyline.subtitle = routeName
                self.mapView.addOverlay(route.polyline)

                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    func clearSearch() {
        Task {
            await MainActor.run(body: {
                self.searchText = ""
                self.fetchedPlaces = nil
                self.routeRefs = [:]
            })
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("locationManager with \(manager.authorizationStatus)")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse,
             .authorizedAlways:
            enableLocationFeatures()
            manager.requestLocation()

        case .restricted, .denied:
            disableLocationFeatures()

        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }

        currentUserLocation = currentLocation
        useCurrentLocation()
    }

    func useCurrentLocation() {
        if let coordinate = currentUserLocation?.coordinate {
            mapView.region = .init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationServiceStatus = .error
    }

    func disableLocationFeatures() {
        locationServiceStatus = .disabled
    }

    func enableLocationFeatures() {
        locationServiceStatus = .enabled
    }

    func removeRoute(at offsets: IndexSet) {
        routes.remove(atOffsets: offsets)
    }

    func addRoute(name: String, startLocation: (Double, Double, String), endLocation: (Double, Double, String)) {
        let (startLat, startLong, startLabel) = startLocation
        let (endLat, endLong, endLabel) = endLocation
        let newRoute = Route(id: UUID(),
                             name: name,
                             start: Location(id: UUID(), label: startLabel, latitude: startLat, longitude: startLong),
                             end: Location(id: UUID(), label: endLabel, latitude: endLat, longitude: endLong))
        routes.append(newRoute)
    }

    func addPin(place: CLPlacemark) {
        guard routeSelection != .done else { return }

        let annotation = MKPointAnnotation()
        annotation.coordinate = place.location!.coordinate
        annotation.title = place.name

        mapView.addAnnotation(annotation)

        Task {
            await MainActor.run(body: {
                if routeSelection == .start {
                    routeStartLocation = place.location
                    routeStartPlacemark = place
                } else {
                    routeEndLocation = place.location
                    routeEndPlacemark = place
                }

                clearSearch()
                toggleRouteSelection()
            })
        }
    }

    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        Task {
            do {
                let location: CLLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                guard let place = try await reverseLocationCoordinates(location: location) else { return }

                addPin(place: place)
            } catch {}
        }
    }

    func addCurrentLocationPin() {
        guard routeSelection != .done else { return }
        guard let currentLocation = currentUserLocation else { return }

        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: currentLocation) else { return }

                addPin(place: place)
            } catch {}
        }
    }

    func toggleRouteSelection() {
        Task {
            await MainActor.run(body: {
                if routeSelection == .start {
                    routeSelection = .end
                } else if routeSelection == .end {
                    routeSelection = .done
                } else {
                    routeSelection = .start
                }
            })
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = routeSelection == .start ? startPinIdentifier : endPinIdentifier
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        marker.isDraggable = true
        marker.canShowCallout = false

        return marker
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)

        if let sub = overlay.subtitle {
            print("subtitle: \(sub ?? "")")
            if sub != nil, let (_, color,_) = routeRefs[sub!] {
                renderer.strokeColor = color
            }
        }

        return renderer
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else { return }

        let selectedLocation: CLLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)

        if view.reuseIdentifier == startPinIdentifier {
            routeStartLocation = selectedLocation
        } else {
            routeEndLocation = selectedLocation
        }

        updatePlacemark(location: selectedLocation, annotationIdentifier: view.reuseIdentifier!)
    }

    func updatePlacemark(location: CLLocation, annotationIdentifier: String) {
        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: location) else { return }

                await MainActor.run(body: {
                    if annotationIdentifier == startPinIdentifier {
                        self.routeStartPlacemark = place
                    } else {
                        self.routeEndPlacemark = place
                    }
                })
            } catch {}
        }
    }

    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first

        return place
    }
}
