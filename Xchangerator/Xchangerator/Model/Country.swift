//
//  Contry.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

struct Country: Hashable, Codable {
    var flag: String
    var name: String
    var rate: Double
    var unit: String

    init() {
        flag = ""
        name = ""
        rate = 0
        unit = ""
    }

    init(flag: String, name: String, rate: Double, unit: String) {
        self.flag = flag
        self.name = name
        self.rate = rate
        self.unit = unit
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        flag = try container.decode(String.self, forKey: .flag)
        name = try container.decode(String.self, forKey: .name)
        rate = try container.decode(Double.self, forKey: .rate)
        unit = try container.decode(String.self, forKey: .unit)
    }
}
