//
//  TextManager.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-24.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

internal class TextFileManager {
    internal class func writeToFile(message: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(Constant.xLogFileName)
            let newContent = readFile() + message
            try? newContent.write(to: fileURL, atomically: false, encoding: .utf8)
        }
    }

    internal class func readFile() -> String {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(Constant.xLogFileName)
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                return content
            }
        }
        return ""
    }

    internal class func cleanFile() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(Constant.xLogFileName)
            try? "".write(to: fileURL, atomically: false, encoding: .utf8)
        }
    }
}
