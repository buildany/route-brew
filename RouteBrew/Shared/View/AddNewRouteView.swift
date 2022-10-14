//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import LocalAuthentication
import SwiftUI
import CoreLocation

struct AddNewRouteView: View {
    @State var start = ""
    @State var finish = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var isStartRouteSelected: Bool {
        guard let _ = locationViewModel.routeStartPlacemark else { return false }
        return true
    }
    
    var isEndRouteSelected: Bool {
        guard let _ = locationViewModel.routeEndPlacemark else { return false }
        return true
    }
    
    var startLocation: (String, String, String, String, String)? {
        guard let place = locationViewModel.routeStartPlacemark else { return nil }
        guard let name = place.name else { return nil }
        let locality = place.locality!
        let postalCode = place.postalCode!
        let country = place.country!
        
        return (name, place.locality != nil ? place.locality! : "", place.postalCode != nil ? place.postalCode! : "" , place.country != nil ? place.country! : "", "start")
    }
    
    var endLocation: (String, String, String, String, String)? {
        guard let place = locationViewModel.routeEndPlacemark else { return nil }
        guard let name = place.name else { return nil }

        return (name, place.locality != nil ? place.locality! : "", place.postalCode != nil ? place.postalCode! : "" , place.country != nil ? place.country! : "", "finish")
    }

    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            VStack {
                if !isStartRouteSelected || !isEndRouteSelected {
                    VStack {
                        SearchTextField(searchText: $locationViewModel.searchText, fetchedPlaces: locationViewModel.fetchedPlaces, onSelect: locationViewModel.addPin, placeholder: isStartRouteSelected ? "Final location" : "Start location")
                        
                    }.padding()
                }
                Spacer()
            
                VStack {
                    if isStartRouteSelected {
                        if let place = startLocation {
                            Divider()
                            SelectedLocationTextField(name: place.0, locality: place.1, postalCode: place.2, country: place.3, label: place.4, onDelete: {})
                        }
                    }
                    if isEndRouteSelected {
                        if let place = endLocation {
                            Divider()
                            SelectedLocationTextField(name: place.0, locality: place.1, postalCode: place.2, country: place.3, label: place.4, onDelete: {})
                        }
                            
                        Button {
                            // COnfirm route selection
                        } label: {
                            Text("Confirm route selection")
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        .background(.red.opacity(0.75))
                        .cornerRadius(7)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .font(.title3)
                        .padding()
                    }
                }
                .background(.white)
            }
        }
    }

//    func saveNewRoute() {
//        locationViewModel.addRoute(name: name, startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
//    }
}

struct AddNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()
        return AddNewRouteView().environmentObject(viewModel)
    }
}
