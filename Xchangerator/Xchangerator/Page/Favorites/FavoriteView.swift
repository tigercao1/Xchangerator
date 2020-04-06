//
//  SwiftUIView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-27.
//  Copyright © 2020 YYES. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @State var items: [FavoriteConversion] = []

    private func reload() {
        items = stateStore.favoriteConversions.getModel()
    }

    private func deleteFav(_ country: FavoriteConversion) {
        try? stateStore.favoriteConversions.deleteById(country.id.uuidString)
        reload()
    }

    var body: some View {
        NavigationView {
            List(items, id: \.self) { country in
                HStack {
                    Button(action: {
                        self.deleteFav(country)
                    }) {
                        Image(systemName: "star.fill").foregroundColor(Color.yellow)
                            .transition(.slide)
                            .imageScale(.large)
                            .rotationEffect(.degrees(90))
                            .scaleEffect(1.5)
                    }
                    .padding()
                    CountryHeadlineReadOnlyView(
                        country: country,
                        isEditable: false,
                        showFromParent: false,
                        barNumFromParent: "100"
                    )
                }

            }.onAppear(perform: {
                self.reload()
            })

                .navigationBarTitle("Favorites")
//                VStack {
//                    ForEach(historyData, id: \.self){
//                        history in
//                        VStack {
//                            //  Text(history.name)
//                            HistoryView(history: history)
//                                .padding()
//                            Spacer()
//                            }
//                    }
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone 11 Pro Max"], id: \.self) { deviceName in ContentView(selection: 1).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
