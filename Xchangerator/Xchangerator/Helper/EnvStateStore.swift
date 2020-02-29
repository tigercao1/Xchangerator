//
//  EnvironStateStore.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import Combine

class ReduxRootStateStore: ObservableObject {
    @Published var curRoute: Key = .auth
    @Published var secondaryRoute: ContentSubKey = .home
    @Published var user: User_DBDoc = User_DBDoc ()
    @Published var isLandscape: Bool = false
    @Published var countries: Countries = ApiCall()

    enum Key: String, CaseIterable {
        case auth, content
    }
    enum ContentSubKey: String, CaseIterable {
        case home, favorites, alerts, settings
    }

}

func ApiCall() -> Countries {
    let apiController = APIController()
    var countries = Countries()
    apiController.makeRequest{(data) in countries = Countries(countryList:data)}
    while countries.getModel().count <= 1 {
        sleep(1)
    }
    return countries
}

