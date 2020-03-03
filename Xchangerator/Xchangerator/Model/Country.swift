//
//  Contry.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-01-28.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

struct Country: Hashable, Codable {
    var flag: String = ""
    var name: String = ""
    var rate: Double = 0
    let unit: String

}
