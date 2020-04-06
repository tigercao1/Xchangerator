//
//  Alerts.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class MyAlerts: ObservableObject {
    private var alerts = [MyAlert]()

    init() {
        alerts.append(MyAlert(baseCurrency: Country(flag: "🇨🇦", name: "Canadian Dollar", rate: 1.421735, unit: "CAD"), targetCurrency: Country(flag: "🇨🇳", name: "Chinese Yuan", rate: 7.0923, unit: "CNY"), conditionOperator: "LT", rate: 5.1))
        alerts.append(MyAlert(baseCurrency: Country(flag: "🇺🇸", name: "United States Dollar", rate: 1, unit: "USD"), targetCurrency: Country(flag: "🇪🇺", name: "Euro", rate: 0.925498, unit: "EUR"), conditionOperator: "LT", rate: 0.93))
    }

    init(alertList: [MyAlert]) {
        alerts = alertList
    }

    func add(_ alert: MyAlert) {
        if alerts.count < 2 { alerts.append(alert) }
    }

    func addToFirst(_ alert: MyAlert) {
        if alerts.count < 2 { alerts.insert(alert, at: 0) }
    }

    func setById(_ idx: Int, _ value: MyAlert) {
        if alerts.count >= 2 { alerts[idx] = value }
    }

    func findById(_ id: String) throws -> MyAlert {
        for alert in alerts {
            if alert.id == UUID(uuidString: id) {
                return alert
            }
        }
        throw EntityExceptions.EntityNotFoundException("MyAlert with id " + id + " not found!")
    }

    func find(_ alert: MyAlert) throws -> MyAlert {
        for a in alerts {
            if a == alert {
                return a
            }
        }
        throw EntityExceptions.EntityNotFoundException("MyAlert when the rate of " + alert.baseCurrency.name + " and " + alert.targetCurrency.name + " is " + alert.conditionOperator + alert.numBar + " not found!")
    }

    func delete(_ alert: MyAlert) throws -> MyAlert {
        var temp: MyAlert
        do {
            temp = try find(alert)
            if let index = alerts.firstIndex(of: temp) {
                alerts.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("MyAlert when the rate of " + alert.baseCurrency.name + " and " + alert.targetCurrency.name + " is " + alert.conditionOperator + alert.numBar + " not deleted!")
        }
        print("MyAlert when the rate of " + alert.baseCurrency.name + " and " + alert.targetCurrency.name + " is " + alert.conditionOperator + alert.numBar + " is deleted!")
        return temp
    }

    func deleteById(_ id: String) throws -> MyAlert {
        var temp: MyAlert
        do {
            temp = try findById(id)
            if let index = alerts.firstIndex(of: temp) {
                alerts.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("MyAlert with id " + id + " not deleted")
        }
        print("MyAlert with id " + id + " deleted")
        return temp
    }

    func change(_ changeToCountry: Country, _ index: Int, _ isBaseCurrency: Bool, _ converter: Converter) -> MyAlert {
        if isBaseCurrency {
            alerts[index].baseCurrency = changeToCountry
        } else {
            alerts[index].targetCurrency = changeToCountry
        }
        alerts[index].rate = converter.getRate(alerts[index].baseCurrency.unit, alerts[index].targetCurrency.unit, Double(100) ?? 0)
        return alerts[index]
    }

    func update(_ index: Int, _ toConditionOp: String, _ newNumBar: String) -> MyAlert {
        alerts[index].conditionOperator = toConditionOp
        alerts[index].rate = (newNumBar as NSString).doubleValue / Double(100)
        return alerts[index]
    }

    func enableAlert(_ index: Int, _ ifDisable: Bool) {
        alerts[index].disabled = ifDisable
    }

    func changeAlert(_ index: Int, _ newAlert: MyAlert) {
        alerts[index] = newAlert
    }

    func checkIfMoreThanTwoActiveAlerts() -> Bool {
//        test()
        var count = 0
        var moreThanTwoActiveAlerts = false
        for i in 0 ... alerts.count - 1 {
            if !alerts[i].disabled {
                count += 1
            }
        }
        if count >= 2 {
            moreThanTwoActiveAlerts = true
        }
        return moreThanTwoActiveAlerts
    }

    func test() {
        alerts[0].disabled = false
        alerts[1].disabled = false
    }

    func getModel() -> [MyAlert] {
        return alerts
    }
}
