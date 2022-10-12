//
//  ContentView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            Spacer()
            VStack {
                RoutesView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()

        return ContentView().environmentObject(viewModel)
    }
}
