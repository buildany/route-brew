//
//  MapSearchView.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import SwiftUI

struct MapSearchView: View {
    
    var body: some View {
        MapView()
            .ignoresSafeArea()
    }
}

struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LocationViewModel()
        
        return MapSearchView().environmentObject(viewModel)
    }
}
