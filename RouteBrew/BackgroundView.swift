//
//  BackgroundView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("map")
            .interpolation(.none)
            .resizable()
            .scaledToFill()
            .background(.white)
            .ignoresSafeArea()
            .opacity(0.1)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
