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
    @State private var targetCountry: Country = Country() {
        didSet {
            curIsFavourite = isFavorite(targetCountry: targetCountry)
        }
    }

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var modalPresented: Bool = false
    @State private var curIsFavourite: Bool = false {
        willSet(newFavorite) {
            if newFavorite != isFavorite(targetCountry: targetCountry) {
                if newFavorite {
                    Logger.info("NewFavor \(newFavorite)")
                    addToFavorite(targetCountry)
                } else {
                    Logger.info("NewFavor \(newFavorite)")
                    deleteFromFavorite(targetCountry)
                }
            }
        }
    }

    @State private var showLinkTarget = false
    @State private var chartClicked = false
    @State private var setAlertClicked = false
    @State private var conditionOperator = "LT"
    @Binding var selectionFromParent: Int
    @State private var moreThanTwoActiveAlerts = false
    @State private var isDuplicateAlert = false

    private func convert(_ targetCurrencyUnit: String) -> String {
        let amount = Double(baseCurrencyAmt) ?? 0
        let converter = Converter(stateStore.countries)
        let convertedAmount = converter.convert(targetCurrencyUnit, amount)
        return String(format: "%.2f", convertedAmount)
    }

    private func isBaseCurrency(_ name: String) -> Bool {
        return name == stateStore.countries.baseCountry.name
    }

    private func setBaseCurrency(_ newBase: Country) {
        // need deep copy
        let myNewCountires = stateStore.countries.copy() as! Countries
        myNewCountires.setBaseCountry(newBase)
        stateStore.countries = myNewCountires
    }

    private func endEditing() {
        UIApplication.shared.endEditing()
    }

    private func isFavorite(targetCountry: Country) -> Bool {
        let currentConversion = FavoriteConversion(baseCurrency: stateStore.countries.baseCountry, targetCurrency: targetCountry)
        do {
            _ = try stateStore.favoriteConversions.find(currentConversion)
            return true
        } catch {
            return false
        }
    }

    private func addToFavorite(_ countryToAdd: Country) {
        let converter = Converter(stateStore.countries)
        if !isFavorite(targetCountry: countryToAdd) {
            let newConv = stateStore.favoriteConversions.copy() as! FavoriteConversions
            newConv.add(FavoriteConversion(baseCurrency: stateStore.countries.baseCountry, targetCurrency: targetCountry, rate: converter.getRate(targetCountry.unit, Double(baseCurrencyAmt) ?? 0)))
            stateStore.favoriteConversions = newConv
        }
    }

    private func deleteFromFavorite(_ countryToDel: Country) {
        if isFavorite(targetCountry: countryToDel) {
            do {
                try stateStore.favoriteConversions.delete(FavoriteConversion(baseCurrency: stateStore.countries.baseCountry, targetCurrency: targetCountry))
            } catch {
                Logger.error(error)
            }
        }
    }

    private func isInAlerts() -> Bool {
        let converter = Converter(stateStore.countries)
        let currentAlert = MyAlert(baseCurrency: stateStore.countries.baseCountry, targetCurrency: targetCountry, conditionOperator: conditionOperator, rate: converter.getRate(targetCountry.unit, Double(baseCurrencyAmt) ?? 0))
        do {
            _ = try stateStore.alerts.find(currentAlert)
            return true
        } catch {
            return false
        }
    }

    private func changeFirstDisabledAlert() {
        let converter = Converter(stateStore.countries)
        let myNewAlert = MyAlert(baseCurrency: stateStore.countries.baseCountry,
                                 targetCurrency: targetCountry,
                                 conditionOperator: conditionOperator,
                                 rate: converter.getRate(targetCountry.unit,
                                                         Double(baseCurrencyAmt) ?? 0))
        // 0 to count-1 (included)
        for index in 0 ... stateStore.alerts.getModel().count - 1 {
            if stateStore.alerts.getModel()[index].disabled {
                stateStore.alerts.changeAlert(index, myNewAlert)
                break
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: screenWidth * 0.05) {
                    VStack(alignment: .leading) {
                        HStack(spacing: screenWidth * 0.05) {
                            Text(self.stateStore.countries.baseCountry.flag)
                                .font(.title)
                                .frame(width: 30, height: 15)
                            TextField("Amount", text: $baseCurrencyAmt)
                                .keyboardType(.decimalPad)
                                .frame(width: screenWidth * 0.3)
                                .multilineTextAlignment(.trailing)
                            Text(self.stateStore.countries.baseCountry.unit)
                                .frame(width: 50)
                                .font(.headline)
                        }.padding(.top, 10)
                        HStack {
                            Text(self.stateStore.countries.baseCountry.name)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .frame(maxWidth: screenWidth * 0.7, alignment: .leading)
                                .fixedSize()
                        }
                    }.padding(.leading, screenWidth * 0.07)
                }
                .padding(.bottom, 5)
                .frame(width: screenWidth * 0.8, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.colorScheme == .light ? Color.black : Color.white, lineWidth: 0.5)
                )
                .fixedSize()

                List(stateStore.countries.getModel(), id: \.self) { country in
                    HStack(spacing: screenWidth * 0.06) {
                        VStack(alignment: .leading) {
                            HStack(spacing: screenWidth * 0.05) {
                                Text(country.flag)
                                    .font(.title)
                                    .frame(width: 30, height: 15)
                                    .fixedSize()
                                Text(self.convert(country.unit))
                                    .frame(width: screenWidth * 0.35, alignment: .trailing)
                                    .fixedSize()
                                Text(country.unit)
                                    .frame(width: 50, alignment: .leading)
                                    .font(.headline)
                                    .fixedSize()
                            }
                            HStack {
                                Text(country.name)
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .frame(width: screenWidth * 0.6, alignment: .leading)
                                    .padding([.bottom, .top], 5)
                                    .fixedSize()
                                Image(systemName: "suit.heart.fill")
                                    .foregroundColor(Color.yellow)
                                    .frame(width: 20, alignment: .trailing)

                            }.frame(alignment: .leading)
                        }.padding(.leading, screenWidth * 0.06)
                            .contentShape(Rectangle())
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        self.setBaseCurrency(country)
                                    }
                            )
                        // }

                        Divider()
                        Image(systemName: "ellipsis")
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 30)
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        self.targetCountry = country
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
            // Package: https://github.com/AndreaMiotto/PartialSheet
            ZStack {
                Color.partialSheetBg

                VStack {
                    Group {
                        Divider().padding(20)
                        Toggle(isOn: self.$curIsFavourite) {
                            HStack {
                                Image(systemName: "heart")
                                    .font(.title)
                                Text("Add to Favorites")
                                    .padding()
                                    .font(.headline)
                            }.foregroundColor(.black)
                        }.padding(.top, 30)
                            .padding(.horizontal, 30)
                        HStack {
                            // TODO: implement chart. don't remove
//                            Button(action: {
//                                          do {
//                                            self.chartClicked.toggle()
//                                          }
//                                      }) {
//                                          VStack {
//                                              Image(systemName: "chart.bar")
//                                                  .font(.title)
//                                              Text("Chart")
//                                                  .fontWeight(.semibold)
//                                                  .font(.headline)
//                                          }
//                            }.buttonStyle(GradientBackgroundStyle())
                            Button(action: {
                                do {
                                    self.moreThanTwoActiveAlerts = self.stateStore.alerts.checkIfMoreThanTwoActiveAlerts()
                                    if !self.moreThanTwoActiveAlerts, !self.isInAlerts() {
                                        self.changeFirstDisabledAlert()
                                        self.selectionFromParent = 2
                                        self.setAlertClicked = true
                                    }
                                }
                                      }) {
                                VStack {
                                    Image(systemName: "bell")
                                        .font(.title)
                                    Text("Set Alert")
                                        .fontWeight(.semibold)
                                        .font(.headline)
                                }.alert(isPresented: self.$moreThanTwoActiveAlerts) {
                                    Alert(title: Text("Warning"), message: Text("You cannot add more than two active alerts. Please disable one alert first"), dismissButton: .default(Text("OK")))
                                }
                            }.buttonStyle(GradientBackgroundStyle())
                        }
                        Divider().padding(.bottom, 50)
                    }
                }

            }.frame(height: 200)
                .onAppear(perform: {
                    self.modalPresented = false
                    self.isDuplicateAlert = false
            })
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Color {
    static let themeBlueGreenMixedBold = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .trailing)
    static let partialSheetBg = LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom)
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ConstantDevices.AlliPhones, id: \.self) { deviceName in ContentView(selection: 0).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}

struct GradientBackgroundStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 10)
            .foregroundColor(.white)
//            .background(Color.themeBlueGreenMixedBold)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(10)).stroke(Color.partialSheetBg))
            .padding(20)
//            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.2 : 1.0)
    }
}
