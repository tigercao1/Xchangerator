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
    @Published var countries: Countries = Countries()
    @Published var favoriteConversions: FavoriteConversions = FavoriteConversions()
    @Published var alerts: MyAlerts = MyAlerts()

    enum Key: String, CaseIterable {
        case auth, content
    }
    
    func setBaseCountry(_ newBase:Country) -> Void{
        self.countries.addToFirst(newBase)
        self.countries.baseCountry = newBase
            do {
                try self.countries.delete(newBase.unit)
            } catch {
                print("Ran into issues while setting base country")
            }
        let newCountries = self.countries.copy()

    }

    
    func resetRoute() -> Void{
        self.secondaryRoute = 0
        self.curRoute = .auth
    }
    
    func resetStateStore() -> Void {
        self.user = User_DBDoc ()
        self.countries = Countries()
    }
    func setDoc(userDoc:User_DBDoc) -> Void {
        self.user = userDoc
        self.countries = ApiCall()
    }
    
    func setCountries(countries: Countries) -> Void {
        self.countries = countries
    }

}

