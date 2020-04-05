//
//  CountryPickerView.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-04-04.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

import SwiftUI

struct CountryPickerView : View {
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @State var items: Array<MyAlert> = []
    @State var index: Int
    @State var isCountry1: Bool
//    @Binding var newAlert: MyAlert
    @Binding var toCurrency: Country
    @Binding var newNumBar: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    

//    @State var toCurrency: Country
    
    var body: some View {
        NavigationView{
            VStack(){
                
                List {
                    ForEach(self.stateStore.countries.getModel(), id: \.self)
                    {
                        currency in
                         HStack {
                            Button(action: {
        //                        var toCurrency = currency
                                var newAlert = self.changeTo(currency, self.index, self.isCountry1)
                                self.toCurrency = currency
                                self.newNumBar = newAlert.numBar
                                self.presentationMode.wrappedValue.dismiss()
                                Logger.debug(self.stateStore.alerts.getModel())

//                                AlertsView()
                                
                                
                            }) {
                                Text("\(currency.flag) - \(currency.name) - \(currency.unit)").font(.headline)
                                Spacer()
                            }
                        }
                    }
                }
            }
        .navigationBarTitle("Change Currency", displayMode: .inline)
        }
    }
    
    private func reload() {
        self.items = self.stateStore.alerts.getModel()
    }
    
    private func changeTo(_ toCurrency: Country, _ index: Int, _ isCountry1: Bool) -> MyAlert{
        let converter = Converter(stateStore.countries)

        return self.stateStore.alerts.change(toCurrency, index, isCountry1, converter)
           
        
    }
    
    private func isSelected(_ currency: Country) -> Bool {
        return true
    }
}
