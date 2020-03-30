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
//    Logger.debug(countries.getModel())
        let apiController = APIController()
//Here  we  can chain consecutive API calls in the background, each time passing the result of one call to the next. We then handle the final result back on the main thread, or in the case of one of our calls failing, we handle the resulting error.
        let result = apiController.makeRequest()
//            .flatMap { self.anotherAPICall($0) }
//            .flatMap { self.andAnotherAPICall($0) }
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
//
//func load() {
//      DispatchQueue.global(qos: .utility).async {
//         let result = self.makeAPICall()
//              .flatMap { self.anotherAPICall($0) }
//              .flatMap { self.andAnotherAPICall($0) }
//
//          DispatchQueue.main.async {
//              switch result {
//              case let .success(data):
//                  print(data)
//              case let .failure(error):
//                  print(error)
//              }
//          }
//      }
//  }
