//
//  MBTypeCheckUtil.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/23.
//

import UIKit
// swiftlint:disable unused_optional_binding
@objc open class MBTypeCheckUtil: NSObject {
    // MARK: - NSString
    @objc public class func isValidString(_ obj : Any?) -> Bool {
        if let _ = obj as? String {
            return true
        } else {
            return false
        }
    }

    @objc public class func isValidStringAndValuable(_ obj : Any?) -> Bool {
        guard isValidString(obj),
            let obj = obj as? String else {
            return false
        }
        return !obj.isEmpty
    }

    // MARK: - NSNumber
    @objc public class func isValidNumber(_ obj : Any?) -> Bool {
        if let _ = obj as? NSNumber {
            return true
        } else {
            return false
        }
    }

    @objc public class func isValidAndNonzero(_ obj : Any?) -> Bool {
        guard isValidNumber(obj),
            let obj = obj as? NSNumber else {
            return false
        }
        return obj != 0
    }

    // MARK: - NSArray
    @objc public class func isValidArray(_ obj : Any?) -> Bool {
        if let _ = obj as? [Any] {
            return true
        } else {
            return false
        }
    }

    @objc public class func isValidArrayAndValuable(_ obj : Any?) -> Bool {
        guard isValidArray(obj),
            let obj = obj as? [Any] else {
            return false
        }
        return !obj.isEmpty
    }
    // MARK: - NSDictionary
    @objc public class func isValidDictionary(_ obj : Any?) -> Bool {
        if let _ = obj as? [AnyHashable : Any] {
            return true
        } else {
            return false
        }
    }

    @objc public class func isValidDictionaryAndValuable(_ obj : Any?) -> Bool {
        guard isValidDictionary(obj),
            let obj = obj as? [AnyHashable : Any] else {
            return false
        }
        return !obj.isEmpty
    }

    // MARK: - NSValue
    @objc public class func isValidValue(_ obj : Any?) -> Bool {
        if let _ = obj as? NSValue {
            return true
        } else {
            return false
        }
    }
    // MARK: - NSDate
    @objc public class func isValidNSDate(_ obj : Any?) -> Bool {
        if let _ = obj as? Date {
            return true
        } else {
            return false
        }
    }

    // MARK: - NSData
    @objc public class func isValidData(_ obj : Any?) -> Bool {
        if let _ = obj as? Data {
            return true
        } else {
            return false
        }
    }

    @objc public class func isValidDataAndValuable(_ obj : Any?) -> Bool {
        guard isValidData(obj),
              let obj = obj as? Data else {
            return false
        }
        return !obj.isEmpty
    }

}
