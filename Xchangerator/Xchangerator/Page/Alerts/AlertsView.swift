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
//import CoreLocation
//import MapKit

//get current location
//https://www.raywenderlich.com/5247-core-location-tutorial-for-ios-tracking-visited-locations
struct AlertsView: View {
    @State var show = false
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @State var items: Array<MyAlert> = []
//    @State var currentAlert: MyAlert
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    private func reload() {
        self.items = self.stateStore.alerts.getModel()
        // do not delete
        Logger.debug(self.items)
    }

    var body: some View {
        self.reload()
        var alertArray = self.stateStore.alerts.getModel()
        return NavigationView{
            ScrollView() {
                VStack {
                    ForEach(alertArray.indices, id: \.self)
                    {
                        index in  //MyAlert
                           // Spacer()
                            EditableCardView(
//                                currentAlert: self.$currentAlert,
                                country1: alertArray[index].baseCurrency,
                                country2: alertArray[index].targetCurrency,
                                conditionOperator: alertArray[index].conditionOperator,
                                numBar: alertArray[index].numBar,
                                disabled: alertArray[index].disabled,
                                index: index
                           )
                        // Spacer()
                    }
                }.scaledToFill()
            }
                .onTapGesture {
                self.endEditing()
                
            }
            .navigationBarTitle(Text("Alerts"))//
            
        }.onAppear(perform: {
            self.reload()
        })
        
    }
}


#if DEBUG
struct Alerts_Previews : PreviewProvider {
    static var previews: some View {
          ForEach(["iPhone SE", "iPhone 11 Pro Max"],id: \.self) { deviceName in ContentView(selection:2).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
          .previewDisplayName(deviceName)
        }
    }
}
#endif
