//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import SwiftUI
import LocalAuthentication
import SwiftUI

struct AddNewRouteView: View {
    @State var start = ""
    @State var name = ""
    @State var finish = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel

    
    var body: some View {
        ZStack {
//  show map with the current location/ or default one if geolocation is disabled
            
            Form {
                Section("Route Label") {
                    TextField("Label", text: $name)
                }
                Section("Start AND destination") {
                    TextField("Start", text: $start)
                    TextField("Finish", text: $finish)
                }
            }
            
            VStack {
                Spacer()
                
                Button {
                    saveNewRoute()
                    dismiss()
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
                .background(.green.opacity(0.75))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(Circle())
                .padding(.trailing)
                
            }
        }
    }
    
    func saveNewRoute() {
        viewModel.addRoute(name: name, startLocation: (52.211525, 5.924628, "Home"), endLocation: (52.0057008, 5.8265593, "School"))
    }
}

struct AddNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        return AddNewRouteView().environmentObject(viewModel)
    }
}

