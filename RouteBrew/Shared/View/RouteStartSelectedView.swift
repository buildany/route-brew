//
//  RouteStartSelectedView.swift
//  RouteBrew
//
//  Created by km on 13/10/2022.
//

import SwiftUI

struct RouteStartSelectedView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(spacing: 10) {
                    HStack {
                        Text("Start location")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button {
                            // delete start location
                        } label: {
                            Label {} icon: {
                                Image(systemName: "trash.circle")
                            }
                        }
                        .font(.title)
                        .foregroundColor(.gray)
                        .background(.white.opacity(0.5))
                      
                    }
                   
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
         
            VStack {
                Button {
 // focus search field
                } label: {
                    Text("Select second point")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.blue.opacity(0.75))
                .foregroundColor(.white)
                .cornerRadius(7)
            }
            .padding()
            
        }
        .background(.white)
        .cornerRadius(14)
        .padding()
        .shadow(radius: 4)
    }
}

struct RouteStartSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        RouteStartSelectedView()
    }
}
