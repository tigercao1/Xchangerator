//
//  Countries.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class Countries {
    var countries = Set<Country>()
    
    init() {
        countries.insert(Country(name: "Test", flag: "👻", unit: "GHO", rate: 109.1))
    }
    
    func add(_ country: Country) -> Country {
        let temp = country
        countries.insert(temp)
        return temp
    }
    
    func findByName(_ name: String) throws -> Country {
        for temp in countries {
            if temp.name == name {
                return temp
            }
        }
        throw EntityExceptions.EntityNotFoundException("Country " + name +  " not found")
    }
    
    func findByUnit(_ unit: String) throws -> Country {
        for temp in countries {
            if temp.unit == unit {
                return temp
            }
        }
        throw EntityExceptions.EntityNotFoundException("Currency " + unit + " not found")
    }
    
    func delete(_ unit: String) throws -> Country {
        var temp: Country
        do {
            temp = try findByUnit(unit)
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("Currency " + unit +  " not deleted")
        }
        print("Currency " + unit + " deleted")
        return temp
    }
    
    func getModel() -> Set<Country> {
        return countries
    }
}
