//
//  RoutesView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct RoutesView: View {
    @State private var showingSheet = false
 
    var body: some View {
        ZStack {
            RoutesListView()
            VStack {
                Spacer()
                Button {
                    showingSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
                .background(.red.opacity(0.75))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .sheet(isPresented: $showingSheet) {
                    AddNewRouteView()
                }
            }
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()

        viewModel.addRoute(name: "School", startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
        return RoutesView().environmentObject(viewModel)
    }
}
