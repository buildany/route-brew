//
//  RoutesCardView.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import SwiftUI

struct RoutesCardView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var showingSheet = false

    var body: some View {
        if locationViewModel.routes.count == 0 {
            NoRoutesView()
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(locationViewModel.routes) { route in
                        RouteCard(route: route)
                    }.onDelete(perform: removeRoute)
                }
            }
        }
    }

    func removeRoute(at offsets: IndexSet) {
        locationViewModel.removeRoute(at: offsets)
    }
}

struct RoutesCardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()
       
        return RoutesCardView().environmentObject(viewModel)
    }
}
