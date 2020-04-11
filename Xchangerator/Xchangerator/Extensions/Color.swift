//
//  Color.swift
//  Xchangerator
//
//  Created by medifle on 2020-04-10.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import SwiftUI

extension UIColor {
    convenience init(_ red: Int, _ green: Int, _ blue: Int, _ a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(_ rgb: Int, _ a: CGFloat = 1.0) {
        self.init(
            (rgb >> 16) & 0xFF,
            (rgb >> 8) & 0xFF,
            rgb & 0xFF,
            a
        )
    }
}
