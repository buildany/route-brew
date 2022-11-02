//
//  RoutesModel.swift
//  RouteBrew
//
//  Created by km on 25/10/2022.
//

import Combine
import Foundation
import MapKit
import SwiftUI

enum TimeInterpretation {
    case departure, arrival
    
    var rawValue: String {
        switch self {
        case .departure: return "departure"
        case .arrival: return "arrival"
        }
    }
}

enum RoutePin {
    case start, end
}

class Trip: Identifiable, Equatable, ObservableObject {
    var id: UUID = .init()
    @Published var routes: [Route] = []
    @Published var label: String = "My trip"
    @Published var timeInterpretation: TimeInterpretation = .departure
    @Published var transportType = MKDirectionsTransportType.automobile.rawValue
    @Published private(set) var availableTransportTypes = [MKDirectionsTransportType.automobile.rawValue, MKDirectionsTransportType.transit.rawValue, MKDirectionsTransportType.walking.rawValue]
    static var defaultTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 45
        return Calendar.current.date(from: components) ?? Date.now
    }

    @Published var alarmTime: Date = defaultTime
    @Published var repeatDays = Weekdays()
    
    @Published private(set) var startPlacemark: CLPlacemark? = nil {
        didSet {
            startPlacemarkPublisher.send(startPlacemark)
        }
    }

    let startPlacemarkPublisher = CurrentValueSubject<CLPlacemark?, Never>(nil)

    @Published private(set) var endPlacemark: CLPlacemark? = nil {
        didSet {
            endPlacemarkPublisher.send(endPlacemark)
        }
    }

    let endPlacemarkPublisher = CurrentValueSubject<CLPlacemark?, Never>(nil)
    
    @Published var isValid: Bool = false
    @Published var validationMessages = [(RoutePin, String)]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var enabledRoute: Route? {
        routes.first {
            route in
            route.enabled
        }
    }
    
    init() {
        let validationPipeline = Publishers.CombineLatest(startPlacemarkPublisher, endPlacemarkPublisher)
            .map { arg -> [(RoutePin, String)] in
                let (start, end) = arg
                var validationMsg = [(RoutePin, String)]()
                if Trip.areSame(start?.location, end?.location) {
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

        validationPipeline
            .map {
                stringArray in
                stringArray.count < 1
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)

        validationPipeline
            .assign(to: \.validationMessages, on: self)
            .store(in: &cancellableSet)
    }
    
    func addRoute(name: String, travelTime: Double, enabled: Bool) -> UUID {
        let newRoute = Route(name: name, travelTime: travelTime, enabled: enabled)
        routes.append(newRoute)
        
        return newRoute.id
    }
    
    func removeStartPlacemark() {
        startPlacemark = nil
        removeAllRoutes()
    }
    
    func removeEndPlacemark() {
        endPlacemark = nil
        removeAllRoutes()
    }
    
    func removeAllRoutes() {
        routes = []
    }
    
    func addStartPlacemark(placemark: CLPlacemark) {
        startPlacemark = placemark
    }
    
    func addEndPlacemark(placemark: CLPlacemark) {
        endPlacemark = placemark
    }
    
    func getRoutePin() -> RoutePin? {
        if startPlacemark == nil {
            return .start
        }
        if endPlacemark == nil {
            return .end
        }

        return nil
    }
    
    static func ==(trip1: Trip, trip2: Trip) -> Bool {
        trip1.id == trip2.id
    }
    
    static func areSame(_ l1: CLLocation?, _ l2: CLLocation?) -> Bool {
        if let loc1 = l1, let loc2 = l2 {
            return loc1.coordinate.latitude == loc2.coordinate.latitude && loc1.coordinate.longitude == loc2.coordinate.longitude
        }

        return false
    }
}
