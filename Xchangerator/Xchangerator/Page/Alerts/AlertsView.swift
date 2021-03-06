//
//  Alerts.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import FirebaseUI
import Foundation
import SwiftUI
// import CoreLocation
// import MapKit

// get current location
// https://www.raywenderlich.com/5247-core-location-tutorial-for-ios-tracking-visited-locations
struct AlertsView: View {
    @State var show = false
    @EnvironmentObject var stateStore: ReduxRootStateStore

    private func endEditing() {
        UIApplication.shared.endEditing()
    }

    var body: some View {
        return NavigationView {
            ScrollView {
                VStack {
                    ForEach(self.stateStore.alerts.getModel().indices, id: \.self)
                    {
                        index in // MyAlert
                        // Spacer()
                        EditableCardView(
                            country1: self.stateStore.alerts.getModel()[index].baseCurrency,
                            country2: self.stateStore.alerts.getModel()[index].targetCurrency,
                            conditionOperator: self.stateStore.alerts.getModel()[index].conditionOperator,
                            numBar: self.stateStore.alerts.getModel()[index].numBar,
                            disabled: self.stateStore.alerts.getModel()[index].disabled,
                            index: index
                        )
                        // Spacer()
                    }
                }.scaledToFill()
            }
            .onTapGesture {
                self.endEditing()
            }
            .navigationBarTitle(Text("Alerts")) //
        }
    }
}

#if DEBUG
    struct Alerts_Previews: PreviewProvider {
        static var previews: some View {
            ForEach(ConstantDevices.AlliPhones, id: \.self) { deviceName in ContentView(selection: 2).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
            }
        }
    }
#endif
