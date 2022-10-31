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

enum RoutePin {
    case start, end
}

class TripReactiveFormModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    @Published var trip = Trip()
    @Published private(set) var locationServiceStatus: LocationServiceStatus = .undefined
    @Published var mapView: ExtendedMapView = .init()
    @Published var startSearchText: String = ""
    @Published var endSearchText: String = ""
    @Published private(set) var startFetchedPlaces: [CLPlacemark]?
    @Published private(set) var endFetchedPlaces: [CLPlacemark]?
    @Published private(set) var currentUserLocation: CLLocation?
    @Published private(set) var canUseCurrentLocation = true
    @Published private(set) var availableTransportTypes = [MKDirectionsTransportType.automobile.rawValue, MKDirectionsTransportType.transit.rawValue, MKDirectionsTransportType.walking.rawValue]

    private var startAnotation: MKAnnotation?
    private var endAnotation: MKAnnotation?

    @Published var routeStartPlacemark: CLPlacemark? = nil {
        didSet {
            startPlacePublisher.send(routeStartPlacemark)
        }
    }

    private let startPlacePublisher = CurrentValueSubject<CLPlacemark?, Never>(nil)

    @Published var routeEndPlacemark: CLPlacemark? = nil {
        didSet {
            endPlacePublisher.send(routeEndPlacemark)
        }
    }

    private let endPlacePublisher = CurrentValueSubject<CLPlacemark?, Never>(nil)

    private var cancellableSet: Set<AnyCancellable> = []
    @Published var validationMessages = [(RoutePin, String)]()
    @Published var saveAllowed: Bool = false

    private let startPinIdentifier = "startPinIdentifier"
    private let endPinIdentifier = "endPinIdentifier"

    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self
        mapView.onLongPress = addAnnotation(for:)

        $startSearchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value, pin: .start)
                } else {
                    self.startFetchedPlaces = nil
                }
            })
            .store(in: &cancellableSet)

        $endSearchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value, pin: .end)
                } else {
                    self.endFetchedPlaces = nil
                }
            })
            .store(in: &cancellableSet)

        let validationPipeline = Publishers.CombineLatest(startPlacePublisher, endPlacePublisher)
            .map { arg -> [(RoutePin, String)] in
                let (start, end) = arg
                var validationMsg = [(RoutePin, String)]()
                if self.areSame(start?.location, end?.location) {
                    validationMsg.append((.end, "The placemarks should be different."))
                }

                self.canUseCurrentLocation = !(self.areSame(start?.location, self.currentUserLocation) || self.areSame(end?.location, self.currentUserLocation))

                if start == nil {
                    validationMsg.append((.start, "Select start point."))
                }

                if end == nil {
                    validationMsg.append((.end, "Select finish point."))
                }

                return validationMsg
            }

        validationPipeline
            .map {
                stringArray in
                stringArray.count < 1
            }
            .assign(to: \.saveAllowed, on: self)
            .store(in: &cancellableSet)

        validationPipeline
            .assign(to: \.validationMessages, on: self)
            .store(in: &cancellableSet)
    }

    func clearStartPlacemark() {
        startSearchText = ""
        routeStartPlacemark = nil
        trip.routes = []
        mapView.removeOverlays(mapView.overlays)
        if let an1 = startAnotation {
            mapView.removeAnnotation(an1)
        }
    }

    func clearEndPlacemark() {
        endSearchText = ""
        routeEndPlacemark = nil
        trip.routes = []
        mapView.removeOverlays(mapView.overlays)
        if let an2 = endAnotation {
            mapView.removeAnnotation(an2)
        }
    }

    func getTrip() -> Trip {
        return trip
    }

    private func areSame(_ l1: CLLocation?, _ l2: CLLocation?) -> Bool {
        if let loc1 = l1, let loc2 = l2 {
            return loc1.coordinate.latitude == loc2.coordinate.latitude && loc1.coordinate.longitude == loc2.coordinate.longitude
        }

        return false
    }

    func fetchPlaces(value: String, pin: RoutePin) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()

                let response = try await MKLocalSearch(request: request).start()

                await MainActor.run(body: {
                    let places = response.mapItems.compactMap { item -> CLPlacemark? in
                        item.placemark
                    }
                    if pin == .start {
                        self.startFetchedPlaces = places
                    }
                    if pin == .end {
                        self.endFetchedPlaces = places
                    }
                })
            } catch {}
        }
    }

    func requestDirections() {
        guard let startPlacemark = routeStartPlacemark else { return }
        guard let endPlacemark = routeEndPlacemark else { return }
        guard let startLocation = startPlacemark.location else { return }
        guard let endLocation = endPlacemark.location else { return }

        let request = MKDirections.Request()
        let sourcePlaceMark = MKPlacemark(coordinate: startLocation.coordinate)
        request.source = MKMapItem(placemark: sourcePlaceMark)

        let destPlaceMark = MKPlacemark(coordinate: endLocation.coordinate)
        request.destination = MKMapItem(placemark: destPlaceMark)
        request.transportType = [MKDirectionsTransportType(rawValue: trip.transportType)]
        request.requestsAlternateRoutes = true

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "No error specified").")

                self.locationServiceStatus = .error
                return
            }

            let minTravelTime = response.routes.map { $0.expectedTravelTime }.min()
            var enabledRoute: MKRoute?

            for route in response.routes.sorted(by: { $0.expectedTravelTime > $1.expectedTravelTime }) {
                let routeExpectedTravelTime = Double(route.expectedTravelTime)
                let isEnabled = minTravelTime == route.expectedTravelTime
                let routeData = Route(name: route.name, travelTime: routeExpectedTravelTime, transportType: route.transportType, enabled: isEnabled)
                self.trip.routes.append(routeData)

                route.polyline.subtitle = routeData.id.uuidString
                route.polyline.title = route.name

                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                enabledRoute = isEnabled ? route : nil
            }
            if let eRoute = enabledRoute {
                self.mapView.setVisibleMapRect(eRoute.polyline.boundingMapRect, animated: true)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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

    private func useCurrentLocation() {
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

    private func addPin(place: CLPlacemark, pin: RoutePin) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.location!.coordinate
        annotation.title = place.name
        mapView.addAnnotation(annotation)

        if pin == .start {
            startAnotation = annotation
        }
        if pin == .end {
            endAnotation = annotation
        }
        Task {
            await MainActor.run(body: {
                let placeDescription = self.getPlaceString(placemark: place)
                if pin == .start {
                    routeStartPlacemark = place
                    startSearchText = placeDescription
                    startFetchedPlaces = []
                } else {
                    routeEndPlacemark = place
                    endSearchText = placeDescription
                    endFetchedPlaces = []
                }

                if routeEndPlacemark != nil, routeStartPlacemark != nil {
                    self.requestDirections()
                }

            })
        }
    }

    func addStartPin(place: CLPlacemark) {
        addPin(place: place, pin: .start)
    }

    func addEndPin(place: CLPlacemark) {
        addPin(place: place, pin: .end)
    }

    func getPlaceString(placemark: CLPlacemark?) -> String {
        guard let place = placemark else { return "" }
        var placeData = [String]()
        if let selectedPlaceName = place.name {
            placeData.append(selectedPlaceName)
        }
        if let selectedPlaceLocality = place.locality {
            placeData.append(selectedPlaceLocality)
        }
        if let sPostalCode = place.postalCode {
            placeData.append(sPostalCode)
        }
        if let sCountry = place.country {
            placeData.append(sCountry)
        }

        return placeData.lazy.joined(separator: ", ")
    }

    private func getRoutePin() -> RoutePin? {
        if routeStartPlacemark == nil {
            return .start
        }
        if routeEndPlacemark == nil {
            return .end
        }

        return nil
    }

    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        guard let pin = getRoutePin() else { return }

        Task {
            do {
                let location: CLLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                guard let place = try await reverseLocationCoordinates(location: location) else { return }

                addPin(place: place, pin: pin)
            } catch {}
        }
    }

    private func addCurrentLocationPin(pin: RoutePin) {
        guard let currentLocation = currentUserLocation else { return }

        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: currentLocation) else { return }

                addPin(place: place, pin: pin)
            } catch {}
        }
    }

    func addCurrentLocationPinAsStart() {
        addCurrentLocationPin(pin: .start)
    }

    func addCurrentLocationPinAsEnd() {
        addCurrentLocationPin(pin: .end)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pin = getRoutePin() else { return nil }
        let reuseIdentifier = pin == .start ? startPinIdentifier : endPinIdentifier
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        marker.isDraggable = true
        marker.canShowCallout = false

        return marker
    }


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)

        if let sub = overlay.subtitle {
            let route = trip.routes.first(where: {
                r in
                r.id.uuidString == sub
            })
            guard let routeData = route else { return renderer }

            renderer.strokeColor = routeData.enabled ? UIColor.blue : UIColor.gray
            
        }
        
        return renderer
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else { return }

        let selectedLocation: CLLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)

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
