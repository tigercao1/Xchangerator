//
//  FavoriteConversion.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-03-10.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
struct FavoriteConversion: Equatable, Hashable {
    let id = UUID()
    var baseCurrency: Country
    var targetCurrency: Country
    var rate: Double
    
    init(baseCurrency: Country, targetCurrency: Country) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.rate = 0
    }
    
    init(baseCurrency: Country, targetCurrency: Country, rate: Double) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.rate = rate
    }
    
    static func == (lhs: FavoriteConversion, rhs: FavoriteConversion) -> Bool {
        return lhs.baseCurrency == rhs.baseCurrency && lhs.targetCurrency == rhs.targetCurrency
    }
}
