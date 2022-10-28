//
//  TimeInterpretationView.swift
//  RouteBrew
//
//  Created by km on 28/10/2022.
//

import SwiftUI

struct TimeInterpretationView: View {
    var timeInterpretation: TimeInterpretation
    
    func getLabel() -> String {
        switch timeInterpretation {
        case .departure:
            return "Departure"
        case .arrival:
            return "Arrival"
        }
    }

    
    var body: some View {
        VStack {
            HStack(spacing: 3) {
                Text(getLabel())
              
            }
        }
    }
}

struct TimeInterpretationView_Previews: PreviewProvider {
    static var previews: some View {
        TimeInterpretationView(timeInterpretation: .arrival)
    }
}
