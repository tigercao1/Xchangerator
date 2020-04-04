//
//  Alert.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

struct Alert: Equatable, Hashable {
    let id = UUID()
    var baseCurrency: Country
    var targetCurrency: Country
    var conditionOperator: String
    var numBar: String
    var rate: Double
    
    init(baseCurrency: Country, targetCurrency: Country, conditionOperator: String) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.conditionOperator = conditionOperator
        self.rate = 0
        self.numBar = String(self.rate * 100)
    }
    
    init(baseCurrency: Country, targetCurrency: Country, conditionOperator: String, rate: Double) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.conditionOperator = conditionOperator
        self.rate = rate
        self.numBar = String(self.rate * 100)
    }
    
    static func == (lhs: Alert, rhs: Alert) -> Bool {
        return lhs.baseCurrency == rhs.baseCurrency && lhs.targetCurrency == rhs.targetCurrency && lhs.conditionOperator == rhs.conditionOperator && lhs.numBar == rhs.numBar
    }
}
