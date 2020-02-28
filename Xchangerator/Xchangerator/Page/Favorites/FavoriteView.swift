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
    let db = Firestore.firestore()
    let disciplines = ["CAD-US", "CAD-FR", "CAD-CNY", "CAD-JPY"]
    var body: some View {
        NavigationView {
          List(disciplines, id: \.self) { discipline in
            Text(discipline)
          }         .navigationBarTitle(Text("Favorites").foregroundColor(.blue))//
        }

    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
