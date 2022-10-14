//
//  SelectedLocationTextField.swift
//  RouteBrew
//
//  Created by km on 14/10/2022.
//

import CoreLocation
import SwiftUI

struct SelectedLocationTextField: View {
    var name: String?
    var locality: String?
    var postalCode: String?
    var country: String?
    var label: String

    var onDelete: () -> Void

    var body: some View {
        if let selectedPlaceName = name, let selectedPlaceLocality = locality,
        let sPostalCode = postalCode,
        let sCountry = country {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "mappin")
                            .foregroundColor(.black.opacity(0.75))
                        Text(label)
                            .foregroundColor(.gray.opacity(0.75))
                            .textCase(.uppercase)
                        Spacer()
                        Button {} label: {
                            Label {} icon: {
                                Image(systemName: "xmark")
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.red.opacity(0.75))
                        .clipShape(Circle())
                        
                    }.padding(1)
                    VStack(alignment: .leading) {
                        Text(selectedPlaceName)
                            .truncationMode(.tail)
                            .font(.system(size: 15, weight: .semibold, design: .default))
                    
                        Text("\(selectedPlaceLocality), \(sPostalCode), \(sCountry)")
                            .truncationMode(.tail)
                            .font(.caption)
                            .padding(1)
                        
                    }.padding(.leading)
                }.padding()
            }
            .background(.white)
        }
    }
}

struct SelectedLocationTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SelectedLocationTextField(name: "Amity Internation School Amsterdam", locality: "Amstelveen", postalCode: "1187DB", country: "The Netherlands", label: "Start", onDelete: {})
  
        }
    }
}
