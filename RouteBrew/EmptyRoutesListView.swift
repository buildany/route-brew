//
//  EmptyRoutesListView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct EmptyRoutesListView: View {
    var body: some View {
        Spacer()
        Text("Add new route to tracker")
            .font(.system(size: 18))
            .foregroundColor(.red)
      
    }
}

struct EmptyRoutesListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRoutesListView()
    }
}
