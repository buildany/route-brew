//
//  NoRoutesView.swift
//  RouteBrew
//
//  Created by km on 12/10/2022.
//

import SwiftUI

struct NoRoutesView: View {
    var body: some View {
        Text("Add new route to tracker")
            .font(.system(size: 18))
            .foregroundColor(.red)
    }
}

struct NoRoutesView_Previews: PreviewProvider {
    static var previews: some View {
        NoRoutesView()
    }
}
