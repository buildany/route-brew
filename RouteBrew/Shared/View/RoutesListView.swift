//
//  RoutesListView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct RoutesListView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var showingSheet = false

    var body: some View {
        if locationViewModel.routes.count == 0 {
            NoRoutesView()
        } else {
            VStack {
                List {
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

struct RoutesListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()
        viewModel.addRoute(name: "School", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        viewModel.addRoute(name: "Home", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        return RoutesListView().environmentObject(viewModel)
    }
}
