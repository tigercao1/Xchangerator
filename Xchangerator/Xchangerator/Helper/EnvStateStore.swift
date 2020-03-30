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
    // Here it's running in the forground, later maybe change it to the background with another thread. For know-how, see comments in APIController
        let result = apiController.makeCountriesRequest()
        switch result {
        case let .success(data):
            guard let countries = data else {
                Logger.error("Countries cast failed")
                return Countries()
            }
            return countries
        case let .failure(error):
            Logger.error(error)
            return Countries()
        }
}
