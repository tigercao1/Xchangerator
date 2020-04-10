//
//  SwiftUIView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-03.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct EditableCardView: View {
    @State private var show = false
    @State var country1: Country
    @State var country2: Country
    @State var conditionOperator: String
    @State var numBar: String
    @State var disabled: Bool
    @State var index: Int
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @State var setSuccess: Bool = false

    private func toggleEdit() {
        if show {
            if disabled {
                guard let newMyAlerts = makeLocalAlertModel(disabled) else {
                    Logger.error("number convert err")
                    return
                }
                Logger.debug("#1 disabled: \(disabled)")
                stateStore.alerts = newMyAlerts

            } else {
                toggleDisabled(disabled)
            }
        }
        show.toggle()
    }

    private func makeLocalAlertModel(_ newDisabled: Bool) -> MyAlerts? {
        guard let dbValue = Double(numBar) else {
            Logger.error("number convert err")
            return nil
        }
        let newMyAlerts = stateStore.alerts.copy() as! MyAlerts
        newMyAlerts.setById(index, MyAlert(baseCurrency: country1, targetCurrency: country2, conditionOperator: conditionOperator, rate: dbValue / 100, disabled: newDisabled))
        // rate in the stateStore is x string/100. in the DB the target is x string
        return newMyAlerts
    }

    private func toggleDisabled(_ newDisabled: Bool) {
        guard let newMyAlerts = makeLocalAlertModel(newDisabled) else {
            Logger.error("number convert err")
            return
        }
//        Logger.debug("#1 disabled: \(disabled)")
//        Logger.debug("#2 new disabled: \(newDisabled)")

        DatabaseManager.shared.updateUserAlert(index: index, myAlerts: newMyAlerts) { result in
            switch result {
            case let .success(myAlerts):
                guard let alertsCopy = myAlerts else {
                    Logger.error("alertsCopy build failed")
                    return
                }
//                Logger.debug("🍎 alertsCopy will set")
                self.stateStore.alerts = alertsCopy // copy()as! MyAlerts
//                Logger.debug("#3 self.disabled after res: \(self.disabled)")
//                Logger.debug("#4 myAlerts idx\(self.index): \(alertsCopy.getModel()[self.index])")
                self.setLocalState(alertsCopy.getModel()[self.index], index: self.index)
                self.setSuccess = true
//                Logger.debug("#5 self.disabled afterSetLocal: \(self.disabled)")
            case let .failure(error):
                Logger.error(error)
            }
        }
    }

    private func setLocalState(_ myAlert: MyAlert, index: Int) {
        numBar = myAlert.numBar
        country1 = myAlert.baseCurrency
        country2 = myAlert.targetCurrency
        conditionOperator = myAlert.conditionOperator
        disabled = myAlert.disabled
    }

    var body: some View {
        VStack {
            if show {
                VStack {
                    Text("Notify me when")
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .lineLimit(.none)

                    CountryHeadlineCardView(
//                        currentAlert: $currentAlert,
                        country: $country1,
                        isEditable: false,
                        showFromParent: $show,
                        barNumFromParent: $numBar,
                        isCountry1: true,
                        index: self.index
                    )
                    Button(action: {
                        self.conditionOperator = self.conditionOperator == "LT" ? "GT" : "LT"
                             }) {
                        Image(systemName: conditionOperator == "LT" ? "lessthan.circle.fill" : "greaterthan.circle.fill")

                            .foregroundColor(.lightBlue).layoutPriority(200)
                    }.animation(.spring())

                    CountryHeadlineCardView(
                        country: $country2,
                        isEditable: true,
                        showFromParent: $show,
                        barNumFromParent: $numBar,
                        isCountry1: false,
                        index: self.index
                    )
                }
                .foregroundColor(Color.white)
                .animation(.easeInOut)
            } else {
                ZStack {
                    HStack {
                        CountryHeadlineCardView(
                            country: $country1,
                            isEditable: false,
                            showFromParent: $show,
                            barNumFromParent: $numBar,
                            isCountry1: true,
                            index: self.index
                        )

                        CountryHeadlineCardView(
                            country: $country2,
                            isEditable: true,
                            showFromParent: $show,
                            barNumFromParent: $numBar,
                            isCountry1: false,
                            index: self.index
                        )
                    }
                    Image(systemName: conditionOperator == "LT" ? "lessthan" : "greaterthan")
                        .foregroundColor(Color.white)
                        .frame(width: 15, height: 15)
                        .padding()
                        .layoutPriority(500)
                }.animation(.easeInOut)
            }

            HStack {
                Spacer()
                Button(action: {
                    self.toggleDisabled(!self.disabled)
                }) {
                    HStack {
                        Image(systemName: disabled ? "bell.slash" : "bell.fill").foregroundColor(disabled ? Color.white : Color.lightBlue)
                            .font(Font.title.weight(.semibold))
                            .imageScale(.small)
                        Text(disabled ? "Disabled" : "Active")
                            .foregroundColor(disabled ? Color.white : Color(hue: 0.498, saturation: 0.609, brightness: 1.0))
                            .fontWeight(.bold)
                            .font(show ? Font.title : Font.headline)
                    }
                }
                .alert(isPresented: self.$setSuccess) {
                    let thisAlert = self.stateStore.alerts.getModel()[self.index]
                    return thisAlert.disabled == true ?
                        Alert(title: Text("Notification Disabled"),
                              message: Text("You can activate it later."),
                              dismissButton: .default(Text("OK")))
                        :
                        Alert(title: Text("Notification Updated"),
                              message: Text("""
                              Xchangerate will notify you when:
                                  \(thisAlert.baseCurrency.flag) 100 \(thisAlert.baseCurrency.unit)
                                  \(thisAlert.conditionOperator == "LT" ? "Less than" : "Great than")
                                  \(thisAlert.targetCurrency.flag) \(thisAlert.numBar) \(thisAlert.targetCurrency.unit)
                              """),
                              dismissButton: .default(Text("OK")))
                }
                .padding(.bottom, show ? 20 : 15)

                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.toggleEdit()
                    }
                }) {
                    HStack {
                        Image(systemName: show ? "slash.circle.fill" : "slash.circle")
                            .foregroundColor(Color.lightBlue)
                            .font(Font.title.weight(.semibold))
                            .imageScale(.small)
                        Text(show ? "Done" : "Edit")
                            .foregroundColor(Color.lightBlue)
                            .fontWeight(.bold)
                            .font(show ? Font.title : Font.headline)
                            .cornerRadius(5)
                    }
                }
                .alert(isPresented: self.$setSuccess) {
                    let thisAlert = self.stateStore.alerts.getModel()[self.index]
                    return
                        Alert(title: Text("Notification Updated"),
                              message: Text("""
                              Xchangerate will notify you when:
                                  \(thisAlert.baseCurrency.flag) 100 \(thisAlert.baseCurrency.unit)
                                  \(thisAlert.conditionOperator == "LT" ? "Less than" : "Great than")
                                  \(thisAlert.targetCurrency.flag) \(thisAlert.numBar) \(thisAlert.targetCurrency.unit)
                              """),
                              dismissButton: .default(Text("OK")))
                }
                .padding(.bottom, show ? 20 : 15)
                Spacer()
            }
        }

        .frame(width: screenWidth * 0.9, height: show ? 300 : 100)
        .background(disabled ? Color(UIColor(0x607D8B, 0.75)) : Color(UIColor(0x448AFF, 0.9)))
        .cornerRadius(20)
    }
}

struct CountryHeadlineCardView: View {
    @Binding var country: Country
//    var number: Float
    var isEditable: Bool
    @Binding var showFromParent: Bool
    @Binding var barNumFromParent: String
    var isCountry1: Bool
    var index: Int
    // var formattedNumBar: String {return String(format:"%.2f",barNumFromParent)}

    var body: some View {
        HStack {
            if showFromParent {
                NavigationLink(destination: CountryPickerView(index: index, isCountry1: isCountry1, toCurrency: $country, newNumBar: $barNumFromParent)) {
                    Text(country.flag)
                        .font(showFromParent ? Font.largeTitle : Font.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(width: !showFromParent ? 20 : 40, height: 15)
                        .padding()
                }

            } else {
                Text(country.flag)
                    .font(showFromParent ? Font.largeTitle : Font.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: !showFromParent ? 20 : 40, height: 15)
                    .padding()
            }

            if isEditable {
                TextField("Amount", text: $barNumFromParent)
                    .disabled(!showFromParent)
                    .font(showFromParent ? Font.title : Font.headline)
                    .frame(width: showFromParent ? screenWidth * 0.3 : 60)
                    .foregroundColor(showFromParent ? Color.lightBlue : Color.white)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.leading)
            } else {
                Text(String(100))
                    .font(showFromParent ? Font.title : Font.headline)
                    .frame(width: showFromParent ? screenWidth * 0.3 : 30)
            }
            Text(country.unit)
                .fontWeight(.bold)
                .font(showFromParent ? Font.title : Font.subheadline)
        }.foregroundColor(.white)
            .frame(width: showFromParent ? screenWidth * 0.8 : screenWidth * 0.40, alignment: .leading)
            .padding(.top, showFromParent ? 5 : 0)
            .padding(.bottom, showFromParent ? 5 : 0)
            .layoutPriority(100)
    }
}

extension Color {
    static let lightBlue = Color(hue: 0.498, saturation: 0.609, brightness: 1.0)
}

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(_ rgb: Int, _ a: CGFloat = 1.0) {
        self.init(
            (rgb >> 16) & 0xFF,
            (rgb >> 8) & 0xFF,
            rgb & 0xFF,
            a
        )
    }
}

#if DEBUG
    struct EditableCardView_Previews: PreviewProvider {
        static var previews: some View {
            ForEach(["iPhone SE", "iPhone 11 Pro Max"], id: \.self) { deviceName in ContentView(selection: 2).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
            }
        }
    }
#endif
