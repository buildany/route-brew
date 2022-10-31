//
//  TimeSelectorView.swift
//  RouteBrew
//
//  Created by km on 27/10/2022.
//

import SwiftUI

struct TimeSelectorView: View {
    @Binding var time: Date
    
    var body: some View {
        DatePicker(selection: $time, displayedComponents: .hourAndMinute, label: {})
            .datePickerStyle(.wheel)
            .navigationTitle( "Set alarm time")
    }
}
