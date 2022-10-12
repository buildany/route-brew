//
//  LockedAppView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI

struct LockedAppView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "lock.fill")
                .foregroundColor(.primary)
                .font(.largeTitle)
            Spacer()

            Button(action: {
                viewModel.authenticateUserWithBiometrics()
            }) {
                Text("UNLOCK")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(.red)
            .cornerRadius(7)

        }
        .padding()
    }
}

struct LockedAppView_Previews: PreviewProvider {
    static var previews: some View {
        LockedAppView()
    }
}
