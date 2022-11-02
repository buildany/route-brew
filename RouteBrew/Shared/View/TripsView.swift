//
//  RoutesView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct TripsView: View {
    @State private var showingSheet = false
    @StateObject var tripsModel = TripsViewModel()
    
    var body: some View {
        if tripsModel.trips.count < 1 {
            Spacer()
            NoRoutesView()

        } else {
            TripsListView(trips: tripsModel.trips, removeTrip: tripsModel.removeTrip)
        }
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
            TripFormView(save: tripsModel.addTrip)
        }
        .shadow(radius: 2)
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        return TripsView()
    }
}
