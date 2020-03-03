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
                HStack(spacing: screenWidth*0.05){
                    VStack(alignment: .leading){
                        HStack(spacing: screenWidth*0.05) {
                            Text(baseCountry.flag)
                                .font(.title)
                                .frame(width: 30, height: 15)
                            TextField("Amount", text: $baseCurrencyAmt)
                                .keyboardType(.numberPad)
                                .frame(width: screenWidth*0.3)
                                .multilineTextAlignment(.trailing)
                            Text(baseCountry.unit)
                                .onAppear{
                                    self.setBaseCurrency()
                            }
                            .frame(width: 50)
                            .font(.headline)
                        }.padding(.top, 10)
                        HStack {
                            Text(baseCountry.name)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .frame(maxWidth: screenWidth*0.7, alignment: .leading)
                                .fixedSize()
                        }
                    }.padding(.leading, screenWidth*0.07)
                }
                .padding(.bottom, 5)
                .frame(width: screenWidth*0.8, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(self.colorScheme == .light ? Color.black : Color.white, lineWidth: 0.5)
                    )
                .fixedSize()
                
                List(stateStore.countries.getModel(), id: \.self) { country in
                    HStack(spacing: screenWidth*0.06) {
                        VStack(alignment: .leading) {
                            HStack(spacing: screenWidth*0.05) {
                                Text(country.flag)
                                    .font(.title)
                                    .frame(width: 20, height: 15)
                                    .fixedSize()
                                Text(self.convert(country.unit))
                                    .frame(width: screenWidth*0.35, alignment: .trailing)
                                    .fixedSize()
                                Text(country.unit)
                                    .frame(width: 50, alignment: .leading)
                                    .font(.headline)
                                    .fixedSize()
                            }
                            HStack(){
                                Text(country.name)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: screenWidth*0.6, alignment: .leading)
                                    .padding([.bottom, .top], 5)
                                    .fixedSize()
                            }.frame(alignment: .leading)
                        }.padding(.leading, screenWidth*0.06)
                            .contentShape(Rectangle())
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        self.switchBase(country)
                                    }
                            )
                        Divider()
                        Image(systemName: "ellipsis")
                            .aspectRatio(contentMode:.fill)
                            .frame(height: 30)
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        self.modalPresented = true
                                    }
                            )
                    }
                    .padding(.top, 10)
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
