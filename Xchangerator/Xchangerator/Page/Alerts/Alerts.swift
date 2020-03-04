//
//  Alerts.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseUI
import SwiftUI
import CoreLocation
import MapKit

//get current location
//https://www.raywenderlich.com/5247-core-location-tutorial-for-ios-tracking-visited-locations
struct Alerts: View {
    @State var show = false
    @EnvironmentObject var stateStore: ReduxRootStateStore

    var body: some View {
        NavigationView{
//            AlertCardView(country1ForShort:"CAD", country2ForShort:"USD",operatorAlert:">",numBar:1010)
            List(stateStore.countries.getModel(), id: \.self) { country in
                Spacer()
                EditableCardView(country1: country, country2: country, conditionOperator: ">", numBar: 100)
                Spacer()
            }
            .navigationBarTitle(Text("Alerts"))//
            
        }
        
    }
}

#if DEBUG
struct Alerts_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(selection:2).environmentObject(ReduxRootStateStore())
    }
}
#endif
