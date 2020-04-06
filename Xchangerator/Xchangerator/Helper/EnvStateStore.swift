//
//  EnvironStateStore.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Combine
import Foundation

class ReduxRootStateStore: ObservableObject {
    @Published var curRoute: Key = .auth
    @Published var secondaryRoute: Int = 0
    @Published var user: User_DBDoc = User_DBDoc()
    @Published var isLandscape: Bool = false
    @Published var countries: Countries = Countries()
    @Published var favoriteConversions: FavoriteConversions = FavoriteConversions()
    @Published var alerts: MyAlerts = MyAlerts()

    enum Key: String, CaseIterable {
        case auth, content
    }

    func resetRoute() {
        secondaryRoute = 0
        curRoute = .auth
    }

    func resetStateStore() {
        user = User_DBDoc()
        countries = Countries()
    }

    func setDoc(userDoc: User_DBDoc) {
        user = userDoc
        countries = ApiCall()
    }

    func setCountries(countries: Countries) {
        self.countries = countries
    }
}
