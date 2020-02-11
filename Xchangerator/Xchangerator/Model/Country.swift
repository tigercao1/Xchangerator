//
//  Contry.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

struct Country: Hashable {
    var name: String = ""
    var flag: String = ""
    let unit: String
    var rate: Double = 0
}

//class Country: Hashable {
//
//    private var name: String
//    private var flag: String?
//    private var unit: String?
//    private var rate: Double
//
//    init(_ unit: String?, _ amt: Double) {
//        self.name = ""
//        self.flag = ""
//        self.unit = unit
//        self.rate = rate
//    }
//
//    init(_ name:String, _ flag: String?, _ unit: String?, _ amt: Double) {
//        self.name = name
//        self.flag = flag
//        self.unit = unit
//        self.rate = amt
//    }
//
//    static func == (lhs: Country, rhs: Country) -> Bool {
//        return lhs.name == rhs.name && lhs.unit == rhs.unit && lhs.flag == rhs.flag && lhs.rate == rhs.rate;
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(flag)
//        hasher.combine(unit)
//        hasher.combine(rate)
//    }
//
//    func getName() -> String {
//        return self.name
//    }
//
//    func setName(_ name: String) -> Void {
//        self.name = name
//    }
//
//    func getFlag() -> String? {
//        return self.flag
//    }
//
//    func setFlag(_ flag: String?) -> Void {
//        self.flag = flag
//    }
//
//    func getUnit() -> String? {
//        return self.unit
//    }
//
//    func setUnit(_ unit: String?) -> Void {
//        self.unit = unit
//    }
//
//    func getRate() -> Double {
//        return self.rate
//    }
//
//    func setRate(_ rate: Double) -> Void {
//        self.rate = rate
//    }
//}
