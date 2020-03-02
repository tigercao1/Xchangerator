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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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

    private func endEditing() {
        UIApplication.shared.endEditing()
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 30){
                    VStack(alignment: .leading){
                        HStack(spacing: 20) {
                            Text(baseCountry.flag)
                                .font(.title)
                                .frame(width: 20, hheight: 15)
                            TextField("Amount", text: $baseCurrencyAmt)
                                .keyboardType(.numberPad)
                                .frame(width: screenWidth*0.20)
                                .multilineTextAlignment(.trailing)
                                .fixedSize()
                                

                            Text(baseCountry.unit)
                                .onAppear{
                                    self.setBaseCurrency()
                            }
                            
                            Button(action: {
                                self.modalPresented = true
                            }) {
                                Image(systemName: "ellipsis")
                            }
                        }
                        HStack {
                            Text(baseCountry.name)
                                .fixedSize()
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .frame(screenWidth*0.4, alignment: .leading)
                                .padding(.bottom, 5)
                        }
                    }
                }
                .padding(.bottom, 5)
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: screenWidth*0.8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                List(stateStore.countries.getModel(), id: \.self) { country in
                    HStack(spacing: 30) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 20) {
                                Text(country.flag)
                                    .font(.title)
                                    .fixedSize()
                                    .frame(width: 20, height: 15)
                                Text(self.convert(country.unit))
                                    .fixedSize()
                                    .frame(width: screenWidth*0.35, alignment: .trailing)
                                Text(country.unit)
                                    .font(.headline)
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
            }.navigationBarTitle("Exchange Rates ")
            
        }.onTapGesture {
            self.endEditing()
            
        }.partialSheet(
            presented: $modalPresented
        ) {
            //Package: https://github.com/AndreaMiotto/PartialSheet
            ZStack {
                Color.partialSheetBg
//                    .cornerRadius(30)
//                    .padding(.horizontal, 5)

                VStack {
                    Group {
                        Toggle(isOn: self.$favourite) {
                            HStack{
                                Image(systemName: "heart")
                                    .font(.title)
                                Text("Add to Favourites")
                                    .padding()
                                    .font(.headline)
                            }.foregroundColor(.black)
                        }.padding(.top,30)
                        .padding(.horizontal,30)                     .padding(.bottom,5)
                        HStack{
                            Button(action: {
                                          do {
                                          self.chartClicked = true
                                          }
                                      }) {
                                          VStack {
                                              Image(systemName: "chart.bar")
                                                  .font(.title)
                                              Text("Chart")
                                                  .fontWeight(.semibold)
                                                  .font(.headline)
                                          }
                            }.buttonStyle(GradientBackgroundStyle())
                            Button(action: {
                                          do {
                                              self.setAlertClicked = true
                                          }
                                      }) {
                                          VStack {
                                              Image(systemName: "bell")
                                                  .font(.title)
                                              Text("Set Alert")
                                                  .fontWeight(.semibold)
                                                  .font(.headline)
                                          }
                            }.buttonStyle(GradientBackgroundStyle())
                        }
                        Spacer()
                        
                    }
                }

            }.frame(height: screenHeight*0.3)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension Color {
    static let themeBlueGreenMixedBold =  LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .trailing)
    static let partialSheetBg =  LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom)
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ReduxRootStateStore())
    }
}


struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical,10)
            .foregroundColor(.white)
//            .background(Color.themeBlueGreenMixedBold)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius:  CGFloat(10)).stroke(Color.partialSheetBg))
            .padding(20)
//            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed  ? 0.2 : 1.0)

    }
}
