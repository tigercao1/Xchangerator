//
//  HomeView.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import PartialSheet
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @State private var baseCurrencyAmt: String = "100"
    @State private var baseCountry: Country = Country()
    @State private var modalPresented: Bool = false
    @State private var favourite: Bool = false
    @State private var showLinkTarget = false
    @State private var chartClicked = false
    @State private var setAlertClicked = false

    private func convert(_ targetCurrencyUnit: String) -> String {
        let amount = Double(baseCurrencyAmt) ?? 0
        let converter = Converter(stateStore.countries)
        let convertedAmount = converter.convert(targetCurrencyUnit, amount)
        return String(format:"%.2f",convertedAmount)
    }
    
    private func isBaseCurrency(_ name: String) -> Bool {
        return name == baseCountry.name
    }
    
    private func setBaseCurrency() {
        self.baseCountry = self.stateStore.countries.baseCountry
    }
    
    private func switchBase(_ newBase: Country) {
        self.stateStore.countries.setBaseCountry(newBase)
        self.setBaseCurrency()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 30){
                    VStack(alignment: .leading){
                        HStack(spacing: 20) {
                            Text(baseCountry.flag)
                                .font(.largeTitle)
                                .fixedSize()
                                .frame(width: 30)
                            TextField("Amount", text: $baseCurrencyAmt)
                                .keyboardType(.numberPad)
                                .fixedSize()
                                .frame(width: 150, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                                

                            Text(baseCountry.unit)
                                .onAppear{
                                    self.setBaseCurrency()
                            }
                            
                            Button(action: {
                                self.modalPresented = true
                            }) {
                                Image("ellipsis")
                            }
                        }
                        HStack {
                            Text(baseCountry.name)
                                .fixedSize()
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .frame(maxWidth: 80, alignment: .leading)
                                .padding(.bottom, 5)
                        }
                    }
                }
                .padding(.bottom, 5)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 360)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                ScrollView{
                    ForEach(stateStore.countries.getModel(), id:\.self) { country in
                        HStack(spacing: 30) {
                            VStack(alignment: .leading) {
                                HStack(spacing: 20) {
                                    Text(country.flag)
                                        .font(.largeTitle)
                                        .fixedSize()
                                        .frame(width: 30)
                                    Text(self.convert(country.unit))
                                        .keyboardType(.numberPad)
                                        .fixedSize()
                                        .frame(width: 145, alignment: .trailing)
                                    Text(country.unit)
                                }
                                HStack{
                                    Text(country.name)
                                        .fixedSize()
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: 80, alignment: .leading)
                                        .padding(.bottom, 5)
                                }
                            }
                            Button(action: {
                                self.modalPresented = true
                            }) {
                                Image("ellipsis")
                            }
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(width: 360)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 0.5)
                        ).padding(.top, 10)
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    self.switchBase(country)
                                }
                        )
                    }
                }
                
                
            }
            
        }.partialSheet(presented: $modalPresented) {

            VStack {
                Group {
                    Toggle(isOn: self.$favourite) {
                        Text("Add to Favourite")
                    }
                    .padding()
                    Text("Chart").gesture(
                        TapGesture().onEnded {
                            action: do {
                            self.chartClicked = true
                            }})
                    Text("Set Alert").gesture(
                    TapGesture().onEnded {
                        action: do {
                        self.setAlertClicked = true
                        }})
                        
                        
                    .padding(.leading)
                    
                }.frame(height: 65)
            }
        }
    }
}
