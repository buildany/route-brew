//
//  WeekdaysSelectorView.swift
//  RouteBrew
//
//  Created by km on 27/10/2022.
//

import SwiftUI

struct WeekdaysSelectorView: View {
    @Binding var weekdays: Weekdays

    var body: some View {
        VStack {
            List {
                ForEach(0 ..< 7) {
                    index in

                    if let weekday = Weekday(rawValue: index) {
                        let isSelected = weekdays.selection[index]

                        HStack {
                            Text(weekday.longValue)
                            Spacer()
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                            }
                        }
                        .onTapGesture {
                            weekdays.selection[index].toggle()
                            weekdays.selection = weekdays.selection.map { $0 }
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .padding()
        }
        .navigationBarTitle(Text("Repeat"), displayMode: .inline)
    }
}
