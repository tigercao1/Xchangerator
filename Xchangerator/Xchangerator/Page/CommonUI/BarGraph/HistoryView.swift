//
//  HistoryView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-05.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    var history: HistoryCell
    @EnvironmentObject var stateStore: ReduxRootStateStore

    @State private var showDetail = false
    @State var isHide = false

    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }

    var body: some View {
        List(stateStore.favoriteConversions.getModel(), id: \.self) { country in
            HStack {
                Button(action: {}) {
                    Image(systemName: "star.fill").foregroundColor(Color.yellow)
                        .transition(.slide)
                        .imageScale(.large)
                        .rotationEffect(.degrees(self.isHide ? 90 : 0))
                        .scaleEffect(!self.isHide ? 1.5 : 0)
                }
                .padding()

                CountryHeadlineReadOnlyView(
                    country: country,
                    isEditable: false,
                    showFromParent: false,
                    barNumFromParent: "100"
                )

                Spacer()
                HistoryGraph(history: self.history, path: \.week)
                    .frame(width: 45, height: 30)
                    .animation(nil)
                Button(action: {
                    withAnimation {
                        self.showDetail.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(self.showDetail ? 90 : 0))
                        .scaleEffect(self.showDetail ? 1.5 : 1)
                        .padding()
                }
            }
            // .padding(10)

            if self.showDetail {
                HistoryDetail(history: self.history)
                    .transition(self.transition)
            }
        }
    }
}

struct CountryHeadlineReadOnlyView: View {
    var country: FavoriteConversion
//    var number: Float
    var isEditable: Bool
    var showFromParent: Bool
    var barNumFromParent: String

    var body: some View {
        VStack {
            HStack {
                Text(country.baseCurrency.flag)
                    .font(showFromParent ? Font.largeTitle : Font.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: !showFromParent ? 15 : 40)
                    .padding()

                Text(barNumFromParent)
                    .font(showFromParent ? Font.title : Font.headline)
                    .frame(width: showFromParent ? screenWidth * 0.3 : 60)

                Text(country.baseCurrency.unit)
                    .fontWeight(.bold)
                    .font(showFromParent ? Font.title : Font.subheadline)
            }
            .frame(width: showFromParent ? screenWidth * 0.8 : screenWidth * 0.2, alignment: .leading)
            .padding(.top, showFromParent ? 5 : 0)
            .padding(.bottom, showFromParent ? 5 : 0)
            .layoutPriority(100)
            HStack {
                Text(country.targetCurrency.flag)
                    .font(showFromParent ? Font.largeTitle : Font.subheadline)
                    .multilineTextAlignment(.center)
                    .frame(width: !showFromParent ? 15 : 40)
                    .padding()

                Text(String(format: "%.2f", (Double(barNumFromParent) ?? 0) * country.rate))
                    .font(showFromParent ? Font.title : Font.headline)
                    .frame(width: showFromParent ? screenWidth * 0.3 : 60)

                Text(country.targetCurrency.unit)
                    .fontWeight(.bold)
                    .font(showFromParent ? Font.title : Font.subheadline)
            }
            .frame(width: showFromParent ? screenWidth * 0.8 : screenWidth * 0.2, alignment: .leading)
            .padding(.top, showFromParent ? 5 : 0)
            .padding(.bottom, showFromParent ? 5 : 0)
            .layoutPriority(100)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ConstantDevices.AlliPhones, id: \.self) { deviceName in ContentView(selection: 1).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
