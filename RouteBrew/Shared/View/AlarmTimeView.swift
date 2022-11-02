//
//  AlarmView.swift
//  RouteBrew
//
//  Created by km on 02/11/2022.
//

import SwiftUI

struct AlarmTimeView: View {
    var time: Date
    
    let timeFormat: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "h:mm"
      return formatter
    }()
    
    let meridiemFormat: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "a"
      return formatter
    }()
    
    var body: some View {
        Text(self.time, format: .dateTime.hour().minute())
                   
           
               
    }
}

struct AlarmTimeView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmTimeView(time: Date.now)
    }
}
