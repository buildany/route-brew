//
//  TimeIntervalView.swift
//  RouteBrew
//
//  Created by km on 01/11/2022.
//

import SwiftUI

struct TimeIntervalView: View {
    var timeInterval: Double
    
    func formatInterval(_ value: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        return formatter.string(from: value)!
    }
    
    var body: some View {
        Text("\(formatInterval(timeInterval))")
            
    }
}

struct TimeIntervalView_Previews: PreviewProvider {
    static var previews: some View {
        TimeIntervalView(timeInterval: 10000)
    }
}
