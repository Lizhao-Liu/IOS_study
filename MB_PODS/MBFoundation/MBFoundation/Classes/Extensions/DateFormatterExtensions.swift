// 
//  DateFormatterExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

public extension MBFoundationWrapper where T == DateFormatter {

    static func dateWithString(string: String, format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = NSDate.mb_dateFormatterInCache(format: format)
        return dateFormatter.date(from: string)
    }

    static func stringWithDate(date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = NSDate.mb_dateFormatterInCache(format: format)
        return dateFormatter.string(from: date)
    }
}

// MARK: DateFormatter

@objc
public extension DateFormatter {

    class func mb_dateWithString(string: String, format: String = "yyyy-MM-dd") -> Date? {
        DateFormatter.mb.dateWithString(string: string, format: format)
    }

    class func mb_stringWithDate(date: Date, format: String = "yyyy-MM-dd") -> String {
        DateFormatter.mb.stringWithDate(date: date, format: format)
    }
}
