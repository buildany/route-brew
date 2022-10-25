//
//  RoutesView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct TripsView: View {
    @State private var showingSheet = false
 
    var body: some View {
        ZStack {
            TripsListView()
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

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TripsViewModel()

      
        return TripsView().environmentObject(viewModel)
    }
}
