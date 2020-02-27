//
//  Logger.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-24.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case info = "[ℹ️Info]" // info
    case debug = "[💬Debug]" // debug
    case warning = "[⚠️Warning]" // warning
    case error = "[‼️Error]" // error
}

class Logger {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func info( _ object: Any,// 1
        fileName: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        logMessage("\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(object)")
        
    }
    
    class func debug( _ object: Any,// 1
        fileName: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        #if DEBUG
        logMessage("\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(object)")
        #endif
    }
    
    class func warning( _ object: Any,// 1
        fileName: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        logMessage("\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    class func error( _ object: Any,// 1
        fileName: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        logMessage("\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(object)")
    }
    
    fileprivate class func logMessage(_ log:String, shouldStoreInFile:Bool = true) {
        #if DEBUG
        if shouldStoreInFile {
            TextFileManager.writeToFile(message: log)
        }
        #endif
        print(log)
    }
}


extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
