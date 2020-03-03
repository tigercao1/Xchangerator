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
    @Published var secondaryRoute: Int = 0
    @Published var user: User_DBDoc = User_DBDoc ()
    @Published var isLandscape: Bool = false
    @Published var countries: Countries = ApiCall()

    enum Key: String, CaseIterable {
        case auth, content
    }
//    enum ContentSubKey: Int, CaseIterable {
//        case home = 0,
//        favorites = 1,
//        alerts = 2,
//        settings = 3
//    }
    
    func resetRoute() -> Void{
        self.secondaryRoute = 0
        self.curRoute = .auth
    }
    
    func resetStateStore() -> Void {
        self.user = User_DBDoc ()
        self.isLandscape = false
        self.countries = Countries()
    }
    func initStateStore(userDoc:User_DBDoc) -> Void {
        self.user = userDoc
        self.countries = ApiCall()
    }
}

func ApiCall() -> Countries {
    let apiController = APIController()
    var countries = Countries()
    apiController.makeRequest{(data) in countries = Countries(countryList:data)}
    while countries.getModel().count <= 1 {
        sleep(1)
    }
    Logger.debug(countries.getModel())
    return countries
}

