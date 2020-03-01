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
    @State private var baseCurrencyUnit: String = "CAD"
    @State private var modalPresented: Bool = false
    @State private var favourite: Bool = false
    @State private var showLinkTarget = false
    @State private var chartClicked = false
    @State private var setAlertClicked = false

    func convert(_ targetCurrencyUnit: String) -> String {
        let amount = Double(baseCurrencyAmt) ?? 0
        let converter = Converter(stateStore.countries)
        let convertedAmount = converter.convert(self.baseCurrencyUnit, targetCurrencyUnit, amount)
        return String(format:"%.2f",convertedAmount)
    }
    private func endEditing() {
           UIApplication.shared.endEditing()
       }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName:"mappin.and.ellipse").resizable()
                        .frame(width:  CGFloat(15), height:  CGFloat(15))
                        .padding(.leading,  CGFloat(15))
                    Text("🇨🇦")
                        .frame(width:  CGFloat(20), height:  CGFloat(15))
                        .padding(.leading,  CGFloat(20))
                        .font(.title)
                    TextField("Amount", text: $baseCurrencyAmt)
                                           .keyboardType(.numberPad)
                                           .multilineTextAlignment(.trailing)
                                           .fixedSize()
                        .frame(width: screenWidth*0.20)

                    Text(baseCurrencyUnit)
                    
                    Button(action: {
                        self.modalPresented = true
                    }) {
                            Image(systemName: "ellipsis")
                            .padding(.trailing,  CGFloat(10))
                            .padding(.leading,  CGFloat(20))
                        
                    }
                    
                }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius:  CGFloat(10))
                            .stroke(Color.themeBlueGreenMixedBold)
                    ).padding()

                List(stateStore.countries.getModel(), id: \.self) {
                    country in
                    HStack {
                        Text(country.flag)
                            .font(.largeTitle)
                            .padding(.leading,  35)
                        Text(self.convert(country.unit))
                            .multilineTextAlignment(.trailing)
                            .fixedSize()
                            .frame(width: screenWidth*0.35).padding()
                        Text(country.unit)
                            .font(.headline)
                            .padding(.trailing, 20.0)
                        
                    }
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
//                            Image(systemName: "heart")
//                                .font(.title)
                            Text("Add to Favourites")
                                .padding()
                                .font(.headline)
                        }.padding(.horizontal, 50)
                        Spacer()
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
                                                  .font(.title)
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
                                                  .font(.title)
                                          }
                            }.buttonStyle(GradientBackgroundStyle())
                        }
                        
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
    static let themeBlueGreenMixedBold =  LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing)
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
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
