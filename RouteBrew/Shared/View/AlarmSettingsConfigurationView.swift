//
//  AddNewRouteView.swift
//  RouteBrew
//
//  Created by km on 11/10/2022.
//

import CoreLocation
import LocalAuthentication
import MapKit
import SwiftUI

struct AlarmSettingsConfigurationView: View {
    @EnvironmentObject var form: TripReactiveFormModel
    
    var body: some View {
        VStack {
            Form {
                Picker("Time interpretation", selection: $form.trip.timeInterpretation) {
                    ForEach([TimeInterpretation.departure, TimeInterpretation.arrival], id: \.self) {
                        TimeInterpretationView(timeInterpretation: $0)
                    }
                }
                .pickerStyle(.segmented)
                DatePicker(selection: $form.trip.alarmTime, displayedComponents: .hourAndMinute, label: {})
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                NavigationLink {
                    WeekdaysSelectorView(weekdays: $form.trip.repeatDays)
                } label: {
                    HStack {
                        Text("Repeat")
                            .foregroundColor(.gray.opacity(0.8))
                        Spacer()
                        Text(form.trip.repeatDays.rawValue)
                    }
                }
                
                HStack {
                    Text("Label")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray.opacity(0.8))
                    Spacer()
                    TextField("My commute", text: $form.trip.label).textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.red.opacity(0.75))
                }
            }
        }
    }
}

struct AlarmSettingsConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        return AlarmSettingsConfigurationView()
    }
}
