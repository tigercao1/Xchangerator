//
//  Alerts.swift
//  Xchangerator
//
//  Created by Wenyue Deng on 2020-03-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class Alerts: ObservableObject {
    var alerts = Array<Alert>()
    
    func add(_ alert: Alert) -> Void {
        alerts.append(alert)
    }
    
    func findById(_ id: String) throws -> Alert {
        for alert in alerts {
            if alert.id == UUID(uuidString: id) {
                return alert
            }
        }
        throw EntityExceptions.EntityNotFoundException("Alert with id " + id + " not found!")
    }
    
    func find(_ alert: Alert) throws -> Alert {
        for a in alerts {
            if a == alert {
                return a
            }
        }
        throw EntityExceptions.EntityNotFoundException("Alert when the rate of " + alert.baseCurrency.name + " and " + alert.targetCurrency.name + " is " + alert.conditionOperator + alert.numBar + " not found!")
    }
    
    func delete(_ alert: Alert) throws -> Alert {
        var temp: Alert
        do {
            temp = try find(alert)
            if let index = alerts.firstIndex(of: temp) {
                alerts.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("Alert when the rate of " + alert.baseCurrency.name + " and " + alert.targetCurrency.name + " is " + alert.conditionOperator + alert.numBar + " not deleted!")
        }
        print("Alert when the rate of " + alert.baseCurrency.name + " and " + alert.targetCurrency.name + " is " + alert.conditionOperator + alert.numBar + " is deleted!")
        return temp
    }
    
    func deleteById(_ id: String) throws -> Alert {
        var temp: Alert
        do {
            temp = try findById(id)
            if let index = alerts.firstIndex(of: temp) {
                alerts.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("Alert with id " + id +  " not deleted")
        }
        print("Alert with id " + id + " deleted")
        return temp
    }
    
    func getModel() -> Array<Alert> {
        return alerts
    }
}
