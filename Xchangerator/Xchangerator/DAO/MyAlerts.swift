//
//  Alerts.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class MyAlerts: ObservableObject {
    var alerts = Array<MyAlert>()
    
    init() {
        alerts.append(MyAlert(baseCurrency: Country(flag: "🇨🇦",  name: "Canadian Dollar", rate: 1.421735, unit: "CAD"), targetCurrency: Country(flag: "🇨🇳",  name: "Chinese Yuan", rate: 7.0923, unit: "CNY"), conditionOperator: "LT", rate: 5.1))
        alerts.append(MyAlert(baseCurrency: Country(flag: "🇺🇸",  name: "United States Dollar", rate: 1, unit: "USD"), targetCurrency: Country(flag: "🇪🇺",  name: "Euro", rate: 0.925498, unit: "EUR"), conditionOperator: "LT", rate: 0.93))
    }
    
    init(alertList: Array<MyAlert>) {
        
        
    }
    
    func add(_ alert: MyAlert) -> Void {
        alerts.append(alert)
    }
    
    func addToFirst(_ alert: MyAlert) -> Void {
        alerts.insert(alert, at: 0)
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
            throw EntityExceptions.EntityNotFoundException("MyAlert with id " + id +  " not deleted")
        }
        print("MyAlert with id " + id + " deleted")
        return temp
    }
    
    func getModel() -> Array<MyAlert> {
        return alerts
    }
}
