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
//                ScrollView{
                    List(stateStore.countries.getModel(), id: \.self) {
//                    ForEach(stateStore.countries.getModel(), id:\.self
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
                //}
            }.navigationBarTitle("Exchange Rates ").onTapGesture {
                self.endEditing()
            }
        }.partialSheet(presented: $modalPresented) {
            VStack {
                Group {
                    Toggle(isOn: self.$favourite) {
                        Text("Add to Favourite")                      .font(.title)

                    }
                    .padding()
                    Text("Chart")
                        .font(.title)
                        .gesture(
                        TapGesture().onEnded {
                            action: do {
                            self.chartClicked = true
                            }})
                    Text("Set Alert")
                        .font(.title)
                        .gesture(
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension Color {
    static let themeBlueGreenMixedBold =  LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing)
}


//
//extension TextField{
//    @IBInspectable var doneAccessory: Bool{
//        get{
//            return self.doneAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                addDoneButtonOnKeyboard()
//            }
//        }
//    }
//
//    func addDoneButtonOnKeyboard()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        self.inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction()
//    {
//        self.resignFirstResponder()
//    }
//}
