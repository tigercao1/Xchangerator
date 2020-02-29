//
//  Converter.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-02-09.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class Converter {
    
    private var countries: Countries
    
    init(_ countries: Countries) {
        self.countries = countries
    }
    
    func convert(_ baseCurrency: String, _ targetCurrency: String, _ amt: Double) -> Double {
        let tempBaseCountry = try? countries.findByUnit(baseCurrency)
        let tempTargetCountry = try? countries.findByUnit(targetCurrency)
        let conversionRate = (tempTargetCountry!.rate / tempBaseCountry!.rate)
        return amt * conversionRate
    }
    
}
