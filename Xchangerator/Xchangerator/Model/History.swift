//
//  History.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-03-05.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

private func initFormatter() -> DateFormatter {
    let f = DateFormatter()
    f.dateStyle = .medium
    f.timeStyle = .none
    f.locale = Locale(identifier: "en_US")
    f.setLocalizedDateFormatFromTemplate("MMMMd")
    return f
}

struct HistoryCell: Codable, Hashable, Identifiable {
    var name: String
    var id: Int
    var distance: Double
    var difficulty: Int
    var observations: [Observation]

    static var formatter = initFormatter()

    var distanceText: String {
        return HistoryCell.formatter
            .string(from: Date(timeIntervalSinceReferenceDate: distance * 3600 * 24 * 7))
    }

    struct Observation: Codable, Hashable {
        var distanceFromStart: Double

        var week: Range<Double>
        var month: Range<Double>
        var year: Range<Double>
    }
}
