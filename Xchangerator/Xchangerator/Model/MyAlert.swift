//
//  Alert.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-26.
//  Copyright © 2020 YYES. All rights reserved.
//
import Foundation

struct MyAlert: Equatable, Hashable {
    let id = UUID()
    var baseCurrency: Country
    var targetCurrency: Country
    var conditionOperator: String
    var rate: Double
    var numBar: String { return String(rate * 100) }
    var disabled: Bool = true

    init(baseCurrency: Country, targetCurrency: Country, conditionOperator: String) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.conditionOperator = conditionOperator
        rate = 0
    }

    init(baseCurrency: Country, targetCurrency: Country, conditionOperator: String, rate: Double) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.conditionOperator = conditionOperator
        self.rate = rate
    }

    init(baseCurrency: Country, targetCurrency: Country, conditionOperator: String, rate: Double, disabled: Bool) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
        self.conditionOperator = conditionOperator
        self.rate = rate
        self.disabled = disabled
    }

    static func == (lhs: MyAlert, rhs: MyAlert) -> Bool {
        return lhs.baseCurrency == rhs.baseCurrency && lhs.targetCurrency == rhs.targetCurrency && lhs.conditionOperator == rhs.conditionOperator && lhs.numBar == rhs.numBar
    }
}

// Data struct of documents in subcollection "notifictions", for DB CRUD
struct Notification_Document: Codable {
    let condition: String
    let disabled: Bool
    let target: Double

    enum CodingKeys: String, CodingKey {
        case condition
        case disabled
        case target
    }

    init(_ alert: MyAlert) {
        target = alert.rate
        disabled = true
        condition = "\(alert.baseCurrency.unit)-\(alert.targetCurrency.unit)-\(alert.conditionOperator)"
    }

    init(condition: String, disabled: Bool, target: Double) {
        self.disabled = disabled
        self.condition = condition
        self.target = target
    }

    init() {
        disabled = false
        condition = "CAD-USD-LT"
        target = 1.2
    }
}
