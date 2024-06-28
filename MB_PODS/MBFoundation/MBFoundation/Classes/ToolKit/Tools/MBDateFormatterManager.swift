//
//  MBDateFormatterManager.swift
//  MBFoundation
//
//  Created by 汪灏 on 2021/8/25.
//

import Foundation

@objc
public class MBDateFormatterManager: NSObject {

    private static let sharedInstance = MBDateFormatterManager()
    private static let concurrentQueue = DispatchQueue(label: "com.mb.hcbToolKit.dateManager", qos: .utility)
    private let formatterCaches: NSCache<NSString, DateFormatter> = NSCache()

    @objc public static let sharedCalendar: NSCalendar? = {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        calendar?.timeZone = NSTimeZone.system
        return calendar
    }()

    @objc public static func dateFormatter(format: NSString) -> DateFormatter {
        var formatter = MBDateFormatterManager.sharedInstance.formatterCaches.object(forKey: format)
        if formatter == nil {
            formatter = DateFormatter()
            formatter!.dateFormat = format as String
        }
        return formatter!
    }

    @objc public static func removeFormatter(format: NSString) {
        MBDateFormatterManager.sharedInstance.formatterCaches.removeObject(forKey: format)
    }

    @objc public static func removeAllFormatters() {
        MBDateFormatterManager.sharedInstance.formatterCaches.removeAllObjects()
    }

    @objc public static func temporaryDateFormatter(format: NSString) -> DateFormatter {
        var formatter = MBDateFormatterManager.sharedInstance.formatterCaches.object(forKey: format)
        if formatter == nil {
            formatter = DateFormatter()
            formatter!.dateFormat = format as String
        }
        return formatter!
    }

}
