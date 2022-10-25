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

class TripsViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var manager = CLLocationManager()

    @Published private(set) var locationServiceStatus: LocationServiceStatus = .undefined
    @Published var mapView: ExtendedMapView = .init()
    @Published var trips: [Trip] = [Trip]()
 
    @Published var startSearchText: String = ""
    @Published var endSearchText: String = ""
    @Published private(set) var startFetchedPlaces: [CLPlacemark]?
    @Published private(set) var endFetchedPlaces: [CLPlacemark]?
    @Published var currentPin: RoutePin = .start
    @Published private(set) var currentUserLocation: CLLocation?
    @Published var canUseCurrentLocation = true

    @Published var routeStartPlacemark: CLPlacemark? = nil {
        didSet {
            startPlacePublisher.send(routeStartPlacemark)
            validateCanUseCurrentLocation()
        }
    }

    private let startPlacePublisher = CurrentValueSubject<CLPlacemark?, Never>(nil)

    @Published var routeEndPlacemark: CLPlacemark? = nil {
        didSet {
            endPlacePublisher.send(routeEndPlacemark)
            validateCanUseCurrentLocation()
        }
    }

    private let endPlacePublisher = CurrentValueSubject<CLPlacemark?, Never>(nil)

    @Published var route: [CLPlacemark] = .init()
    @Published var routeRefs: [String: (Double, UIColor, Bool)] = [:]
    @Published var preferredRoute: String?

    private var cancellableSet: Set<AnyCancellable> = []
    @Published var validationMessages = [(RoutePin, String)]()

    private var submitAllowed: AnyPublisher<Bool, Never>?
    @Published var allSet: Bool = false

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
                    self.fetchPlaces(value: value, currentPin: self.currentPin)
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
                    self.fetchPlaces(value: value, currentPin: self.currentPin)
                } else {
                    self.endFetchedPlaces = nil
                }
            })
            .store(in: &cancellableSet)

        let validationPipeline = Publishers.CombineLatest(startPlacePublisher, endPlacePublisher)
            .map { arg -> [(RoutePin, String)] in
                let (start, end) = arg
                var validationMsg = [(RoutePin, String)]()
                if start == end {
                    validationMsg.append((.end, "The placemarks should be different."))
                }
                if start == nil {
                    validationMsg.append((.start, "Select start point."))
                }

                if end == nil {
                    validationMsg.append((.end, "Select finish point."))
                }

                return validationMsg
            }

        submitAllowed = validationPipeline
            .map {
                stringArray in
                let allSet = stringArray.count < 1
                if allSet {
                    self.requestDirections()
                }
                return allSet
            }
            .eraseToAnyPublisher()

        validationPipeline
            .assign(to: \.validationMessages, on: self)
            .store(in: &cancellableSet)
    }

    func validateCanUseCurrentLocation() {
        canUseCurrentLocation = true
        
        guard let startPlacemark = routeStartPlacemark else { return }
        guard let endPlacemark = routeEndPlacemark else { return }
        guard let startLocation = startPlacemark.location else { return }
        guard let endLocation = endPlacemark.location else { return }
        
        if startLocation == currentUserLocation || endLocation == currentUserLocation {
            canUseCurrentLocation = false
        }
    }
    
    func fetchPlaces(value: String, currentPin: RoutePin) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()

                let response = try await MKLocalSearch(request: request).start()

                await MainActor.run(body: {
                    let places = response.mapItems.compactMap { item -> CLPlacemark? in
                        item.placemark
                    }
                    if currentPin == .start {
                        self.startFetchedPlaces = places
                    }
                    if currentPin == .end {
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

    func clearStartSearch() {
        Task {
            await MainActor.run(body: {
                self.startSearchText = ""
                self.startFetchedPlaces = nil
            })
        }
    }
    
    func removeTrip(at offsets: IndexSet) {
        trips.remove(atOffsets: offsets)
    }

    func clearEndSearch() {
        Task {
            await MainActor.run(body: {
                self.endSearchText = ""
                self.endFetchedPlaces = nil
            })
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

    func addPin(place: CLPlacemark) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.location!.coordinate
        annotation.title = place.name

        mapView.addAnnotation(annotation)

        Task {
            await MainActor.run(body: {
                if currentPin == .start {
                    routeStartPlacemark = place
                } else {
                    routeEndPlacemark = place
                }
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
        guard let currentLocation = currentUserLocation else { return }

        Task {
            do {
                guard let place = try await reverseLocationCoordinates(location: currentLocation) else { return }

                addPin(place: place)
            } catch {}
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = currentPin == .start ? startPinIdentifier : endPinIdentifier
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        marker.isDraggable = true
        marker.canShowCallout = false

        return marker
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)

        if let sub = overlay.subtitle {
            print("subtitle: \(sub ?? "")")
            if sub != nil, let (_, color, _) = routeRefs[sub!] {
                renderer.strokeColor = color
            }
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
