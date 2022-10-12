//
//  RoutesCardView.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import SwiftUI

struct RoutesCardView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingSheet = false

    var body: some View {
        if viewModel.routes.count == 0 {
            NoRoutesView()
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(viewModel.routes) { route in
                        RouteCard(route: route)
                    }.onDelete(perform: removeRoute)
                }
            }
        }
    }

    func removeRoute(at offsets: IndexSet) {
        viewModel.removeRoute(at: offsets)
    }
}

struct RoutesCardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        viewModel.addRoute(name: "School", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        viewModel.addRoute(name: "Home", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        viewModel.addRoute(name: "Home", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        viewModel.addRoute(name: "Home", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        viewModel.addRoute(name: "Home", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        viewModel.addRoute(name: "Home", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        return RoutesCardView().environmentObject(viewModel)
    }
}
