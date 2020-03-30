//
//  SwiftUIView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-27.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FavoriteView: View {
//    let disciplines = ["CAD-US", "CAD-FR", "CAD-CNY", "CAD-JPY"]

    var body: some View {
        NavigationView {
            ScrollView() {
                VStack {
                    ForEach(historyData, id: \.self){
                        history in
                        VStack {
                            //  Text(history.name)
                            HistoryView(history: history)
                                .padding()
//                            Spacer()
                            }
                    }
                }
          }.navigationBarTitle("Favorites")//
        }

    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
          ForEach(["iPhone SE", "iPhone 11 Pro Max"],id: \.self) { deviceName in ContentView(selection:1).environmentObject(ReduxRootStateStore()).previewDevice(PreviewDevice(rawValue: deviceName))
          .previewDisplayName(deviceName)
        }
    }
}
