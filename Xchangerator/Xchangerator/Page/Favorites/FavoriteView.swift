//
//  SwiftUIView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-27.
//  Copyright © 2020 YYES. All rights reserved.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

// Bindable Obj  is Observable Obj https://stackoverflow.com/questions/56496359/swiftui-view-viewdidload
struct FavoriteView: View {
    @EnvironmentObject var stateStore: ReduxRootStateStore

    private func deleteFav(_ country: FavoriteConversion) {
        let copy = stateStore.favoriteConversions.copy() as! FavoriteConversions
        _ = try? copy.deleteById(country.id.uuidString)
        stateStore.favoriteConversions = copy
    }

    var body: some View {
        NavigationView {
            Group {
                stateStore.favoriteConversions.getModel().count <= 0 ?
                    AnyView(
                        CardView(image: "cover", category: Constant.xDescFav, heading: "No item available", author: "Xchangerator"))
                    :
                    AnyView(List(stateStore.favoriteConversions.getModel(), id: \.self) { country in
                        HStack {
                            Button(action: {
                                self.deleteFav(country)
                            }) {
                                Image(systemName: "star.fill").foregroundColor(Color.yellow)
                                    .transition(.slide)
                                    .imageScale(.large)
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
                    }
                    )
            }.animation(.easeInOut)
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
        ForEach(ConstantDevices.AlliPhones, id: \.self) { deviceName in ContentView(selection: 1).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
