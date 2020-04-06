//
//  Countries.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class Countries: ObservableObject, NSCopying {
    var countries = [Country]()
    var baseCountry: Country

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Countries(countries: countries, baseCountry: baseCountry)
        return copy
    }

    init() {
        countries.append(Country(flag: "🇺🇳", name: "LoadingData", rate: 109.1, unit: "GHO"))
        baseCountry = countries[0]
    }

    init(countries: [Country], baseCountry: Country) {
        self.countries = countries
        self.baseCountry = baseCountry
    }

    init(countryList: CountryList) {
        for country in countryList.countries {
            if country.flag == "" {
                countries.append(Country(flag: "🇺🇳", name: country.name, rate: country.rate, unit: country.unit))
            } else {
                countries.append(Country(flag: country.flag, name: country.name, rate: country.rate, unit: country.unit))
            }
        }
        baseCountry = countries[0]
        do {
            try baseCountry = findByUnit("CAD")
            try delete("CAD")
            // TODO:
            // Can be replaced by location based info
        } catch {
            Logger.error("Base country is set to the first element in list.")
        }
    }

    func setBaseCountry(_ country: Country) {
        addToFirst(baseCountry)
        baseCountry = country
        do {
            try delete(country.unit)
        } catch {
            print("Ran into issues while setting base country")
        }
    }

    func add(_ country: Country) {
        countries.append(country)
    }

    func addToFirst(_ country: Country) {
        countries.insert(country, at: 0)
    }

    func findByName(_ name: String) throws -> Country {
        if baseCountry.name == name { return baseCountry }
        for temp in countries {
            if temp.name == name {
                return temp
            }
        }
        throw EntityExceptions.EntityNotFoundException("Country " + name + " not found")
    }

    func findByUnit(_ unit: String) throws -> Country {
        if baseCountry.unit == unit { return baseCountry }
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
            if let index = countries.firstIndex(of: temp) {
                countries.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("Currency " + unit + " not deleted")
        }
        Logger.debug("Currency " + unit + " deleted")
        return temp
    }

    func getModel() -> [Country] {
        return countries
    }
}
