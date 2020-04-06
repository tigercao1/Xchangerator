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
    @Binding var toCurrency: Country
    @Binding var newNumBar: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        NavigationView{
            
            VStack(){
                
                List {
                    ForEach(self.stateStore.countries.getFullCountries(), id: \.self)
                    {
                        currency in
                         HStack {
                            Button(action: {

//                                var newAlert = self.changeTo(currency, self.index, self.isCountry1)
                                self.toCurrency = currency
                                self.newNumBar = self.changeNumTo(currency, self.index, self.isCountry1)
                                self.presentationMode.wrappedValue.dismiss()
                                Logger.debug(self.stateStore.alerts.getModel())
                                
                                
                            }) {
                                
                                Text("\(currency.flag) - \(currency.name) - \(currency.unit)").font(.headline)
                                Spacer()
                            }
                        }
                    }
                }
            }
//        .navigationBarTitle("Change Currency", displayMode: .inline)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        }
    }
    
    private func reload() {
        
        self.items = self.stateStore.alerts.getModel()
        
    }
    
    private func changeTo(_ toCurrency: Country, _ index: Int, _ isCountry1: Bool) -> MyAlert{

        let converter = Converter(stateStore.countries)

        return self.stateStore.alerts.change(toCurrency, index, isCountry1, converter)

    }
    
    private func changeNumTo(_ toCurrency: Country, _ index: Int, _ isCountry1: Bool) -> String{

        let converter = Converter(stateStore.countries)
        var rate = Double(0)
        if (isCountry1){
            rate = converter.getRate(toCurrency.unit, self.stateStore.alerts.getModel()[index].targetCurrency.unit, Double(100) )
            return String(rate * 100)
            
       } else {
            rate = converter.getRate(self.stateStore.alerts.getModel()[index].baseCurrency.unit, toCurrency.unit, Double(100) )
            return String(rate * 100)
       }


    }
    
    
}
