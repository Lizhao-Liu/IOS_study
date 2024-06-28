// 
//  DictionaryExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// JSON @frozen public struct Dictionary<Key, Value> where Key : Hashable
// swiftlint:disable all
public extension MBFoundationWrapper where T == [AnyHashable: Any] {

    var json: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: this, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
        }
        return nil
    }

    var jsonPretty: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: this, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
        }
        return nil
    }

    var jsonData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: this, options: .prettyPrinted)
        } catch {
        }
        return nil
    }

}

// MARK: Immutable

public extension MBFoundationWrapper where T == [AnyHashable: Any] {

}

// MARK: Mutable

public extension MBFoundationWrapper where T == [AnyHashable: Any] {

}

// MARK: Plist

public extension MBFoundationWrapper where T == [AnyHashable: Any] {

    var plistData: Data? {
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: this, format: .binary, options: 0)
            return data
        } catch {
        }
        return nil
    }

    var plistString: String? {
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: this, format: .xml, options: 0)
            return String(data: data, encoding: .utf8)
        } catch {
        }
        return nil
    }

    static func mb_dictionaryWithPlistData(_ plist: Data?) throws -> [AnyHashable: Any]? {
        guard let plist = plist else { return nil }
        return try PropertyListSerialization.propertyList(from: plist, options: [], format: nil) as? Dictionary
    }

    static func mb_dictionaryWithPlistString(_ plist: String?) throws -> [AnyHashable: Any]? {
        guard let plist = plist else { return nil }
        return try mb_dictionaryWithPlistData(plist.data(using: .utf8))
    }
}

@objc
public extension NSDictionary {

    // MARK: JSON

    func mb_jsonString() -> NSString? {
        (self as? [AnyHashable: Any])?.mb.json as NSString?
    }

    func mb_jsonPrettyString() -> NSString? {
        (self as? [AnyHashable: Any])?.mb.jsonPretty as NSString?
    }

    func mb_jsonData() -> NSData? {
        (self as? [AnyHashable: Any])?.mb.jsonData as NSData?
    }
    
    func mb_URLEncodingString() -> NSString? {
        let strings: NSMutableArray = NSMutableArray()
        for (key, value) in self {
            if let num = value as? NSNumber {
                if let string = (num.stringValue as NSString).mb_URLEncodingString() {
                    strings.add(NSString(string: "\(key)=\(string)"))
                }
            }
            if let str = value as? NSString {
                if let string = str.mb_URLEncodingString() {
                    strings.add(NSString(string: "\(key)=\(string)"))
                }
            }
        }
        return strings.componentsJoined(by: "&") as NSString?
    }

    func mb_URLParamsString() -> NSString? {
        let strings: NSMutableArray = NSMutableArray()
        for (key, value) in self {
            if let num = value as? NSNumber {
                strings.add(NSString(string: "\(key)=\(num.stringValue as NSString)"))
            }
            if let str = value as? NSString {
                strings.add(NSString(string: "\(key)=\(str)"))
            }
        }
        return strings.componentsJoined(by: "&") as NSString
    }

    // MARK: Immutable

    func mb_objectForKey(_ key: AnyObject?) -> AnyObject? {
        guard let key = key else { return nil }
        return (self as Dictionary)[key as! NSObject]
    }

    func mb_objectForKeyIgnoreNil(_ key: AnyObject?) -> AnyObject? {
        let object = mb_objectForKey(key)
        return (object is NSNull) ? nil : object
    }

    func mb_dictionaryForKey(_ key: AnyObject?) -> NSDictionary? {
        mb_objectForKey(key) as? NSDictionary
    }

    func mb_arrayForKey(_ key: AnyObject) -> NSArray? {
        mb_objectForKey(key) as? NSArray
    }

    func mb_numberForKey(_ key: AnyObject) -> NSNumber? {
        let any = mb_objectForKey(key)
        if let num = any as? NSNumber {
            return num
        }
        if let value = any,
           value.responds(to: NSSelectorFromString("integerValue")) {
            return NSNumber(value: (value.integerValue) )
        }
        return nil
    }

    func mb_stringForKey(_ key: AnyObject) -> NSString? {
        let any = mb_objectForKey(key)
        if let string = any as? NSString {
            return string
        }
        if let number = any as? NSNumber {
            return NSString(format: "%@", number)
        }
        return nil
    }
    
    func mb_decimalNumberForKey(_ key: AnyObject) -> NSDecimalNumber? {
        let any = mb_objectForKey(key)
        if let value = any as? NSDecimalNumber {
            return value
        }
        if let value = any as? NSNumber {
            return NSDecimalNumber(decimal: value.decimalValue)
        }
        if let value = any as? String,
           !value.isEmpty,
           let number = NSNumber(string: value) {
            return NSDecimalNumber(decimal: number.decimalValue)
        }
        return nil
    }

    func mb_integerForKey(_ key: AnyObject) -> NSInteger {
        let any = mb_objectForKey(key)

        if let integer = any as? Int {
            return integer
        }

        if let string = any as? NSString {
            return NSInteger(NSNumber(integerLiteral: string.integerValue).int64Value)
        }

        if let number = any as? NSNumber {
            return NSInteger(number.int64Value)
        }

        return 0
    }

    func mb_int8ForKey(_ key: AnyObject) -> Int8 {
        let any = mb_objectForKey(key)

        if let int8 = any as? Int8 {
            return int8
        }

        if let number = any as? NSNumber {
            return number.int8Value
        }

        if let string = any as? NSString {
            return Int8(string.intValue)
        }

        return 0
    }

    func mb_int16ForKey(_ key: AnyObject) -> Int16 {
        let any = mb_objectForKey(key)

        if let int16 = any as? Int16 {
            return int16
        }

        if let number = any as? NSNumber {
            return number.int16Value
        }

        if let string = any as? NSString {
            return Int16(string.intValue)
        }

        return 0
    }

    func mb_int32ForKey(_ key: AnyObject) -> Int32 {
        let any = mb_objectForKey(key)

        if let int32 = any as? Int32 {
            return int32
        }

        if let number = any as? NSNumber {
            return number.int32Value
        }

        if let string = any as? NSString {
            return Int32(string.intValue)
        }

        return 0
    }

    func mb_int64ForKey(_ key: AnyObject) -> Int64 {
        let any = mb_objectForKey(key)

        if let int64 = any as? Int64 {
            return int64
        }

        if let number = any as? NSNumber {
            return number.int64Value
        }

        if let string = any as? NSString {
            return Int64(string.longLongValue)
        }

        return 0
    }

    func mb_unsignedIntegerForKey(_ key: AnyObject) -> UInt {
        let any = mb_objectForKey(key)

        if let integer = any as? UInt {
            return integer
        }

        if let string = any as? NSString {
            return NSNumber(integerLiteral: string.integerValue).uintValue
        }

        if let number = any as? NSNumber {
            return number.uintValue
        }

        return 0
    }

    func mb_unsignedInt8ForKey(_ key: AnyObject) -> UInt8 {
        let any = mb_objectForKey(key)

        if let uint8 = any as? UInt8 {
            return uint8
        }

        if let number = any as? NSNumber {
            return number.uint8Value
        }

        if let string = any as? NSString {
            return UInt8(string.intValue)
        }

        return 0
    }

    func mb_unsignedInt16ForKey(_ key: AnyObject) -> UInt16 {
        let any = mb_objectForKey(key)

        if let uint16 = any as? UInt16 {
            return uint16
        }

        if let number = any as? NSNumber {
            return number.uint16Value
        }

        if let string = any as? NSString {
            return UInt16(string.intValue)
        }

        return 0
    }

    func mb_unsignedInt32ForKey(_ key: AnyObject) -> UInt32 {
        let any = mb_objectForKey(key)

        if let uint32 = any as? UInt32 {
            return uint32
        }

        if let number = any as? NSNumber {
            return number.uint32Value
        }

        if let string = any as? NSString {
            return UInt32(string.intValue)
        }

        return 0
    }

    func mb_unsignedInt64ForKey(_ key: AnyObject) -> UInt64 {
        let any = mb_objectForKey(key)

        if let uint64 = any as? UInt64 {
            return uint64
        }

        if let number = any as? NSNumber {
            return number.uint64Value
        }

        if let string = any as? NSString {
            return UInt64(string.unsignedLongLongValue)
        }

        return 0
    }

    func mb_boolForKey(_ key: AnyObject) -> Bool {
        let any = mb_objectForKey(key)

        if let bool = any as? Bool {
            return bool
        }

        if let number = any as? NSNumber {
            return number.boolValue
        }

        if let string = any as? NSString {
            return string.boolValue
        }

        return false
    }

    func mb_floatForKey(_ key: AnyObject) -> Float {
        let any = mb_objectForKey(key)

        if let float = any as? Float {
            return float
        }

        if let number = any as? NSNumber {
            return number.floatValue
        }

        if let string = any as? NSString {
            return string.floatValue
        }

        return 0
    }

    func mb_doubleForKey(_ key: AnyObject) -> Double {
        let any = mb_objectForKey(key)

        if let double = any as? Double {
            return double
        }

        if let number = any as? NSNumber {
            return number.doubleValue
        }

        if let string = any as? NSString {
            return string.doubleValue
        }

        return 0
    }

    func mb_CGFloatForKey(_ key: AnyObject) -> CGFloat {
        let any = mb_objectForKey(key)

        if let float = any as? CGFloat {
            return float
        }

        return 0
    }

    func mb_CGPointForKey(_ key: AnyObject) -> CGPoint {
        let any = mb_objectForKey(key)

        if let point = any as? CGPoint {
            return point
        }

        if let string = any as? NSString {
            return NSCoder.cgPoint(for: string as String)
        }

        return CGPoint.zero
    }

    func mb_CGSizeForKey(_ key: AnyObject) -> CGSize {
        let any = mb_objectForKey(key)

        if let size = any as? CGSize {
            return size
        }

        if let string = any as? NSString {
            return NSCoder.cgSize(for: string as String)
        }

        return CGSize.zero
    }

    func mb_CGRectForKey(_ key: AnyObject) -> CGRect {
        let any = mb_objectForKey(key)

        if let rect = any as? CGRect {
            return rect
        }

        if let string = any as? NSString {
            return NSCoder.cgRect(for: string as String)
        }

        return CGRect.zero
    }

    func mb_isContain(_ key: AnyObject?) -> Bool {
        guard let key = key else { return false }
        return mb_objectForKey(key) != nil
    }

    static func mb_isNilOrEmpty(_ dict: NSDictionary?) -> Bool {
        guard let dict = dict else { return true }
        return dict.mb_isEmpty()
    }

    func mb_isEmpty() -> Bool {
        (self as Dictionary).isEmpty
    }

    // MARK: Generic Covariant

    func mb_each(_ block: (Any, Any?) -> Void) {
        for key in self.allKeys {
            block(key, self[key])
        }
    }

    @discardableResult
    func mb_map(_ block: (Any, Any?) -> Any?) -> NSDictionary {
        let result = NSMutableDictionary()
        for key in self.allKeys {
            if let mappedObject = block(key, self[key]) {
                result[key] = mappedObject
            }
        }
        return NSDictionary(dictionary: result as! [AnyHashable: Any], copyItems: false)
    }

    @discardableResult
    func mb_filter(_ block: (Any, Any?) -> Bool) -> NSDictionary {
        let result = NSMutableDictionary()
        for key in self.allKeys {
            if block(key, self[key]) {
                result[key] = self[key]
            }
        }
        return NSDictionary(dictionary: result as! [AnyHashable: Any], copyItems: false)
    }

}

// MARK: Mutable

@objc
public extension NSMutableDictionary {

    func mb_setObject(_ object: AnyObject?, forKey key: NSString) {
        guard key.length != 0 else { return }
        if let object = object {
            self[key] = object
        }
    }

    func mb_setObjectContainNil(_ object: AnyObject?, forKey key: NSString) {
        if object is NSNull {
            mb_setObject(NSNull(), forKey: key)
            return
        }
        guard let object = object else {
            mb_setObject(NSNull(), forKey: key)
            return
        }
        mb_setObject(object, forKey: key)
    }

    func mb_setObjectIgnoreNil(_ object: AnyObject?, forKey key: NSString) {
        if object is NSNull { return }
        guard let object = object else { return }
        mb_setObject(object, forKey: key)
    }

    func mb_setString(_ string: NSString, forKey key: NSString) {
        mb_setObject(string, forKey: key)
    }

    func mb_setBool(_ bool: Bool, forKey key: NSString) {
        mb_setObject(NSNumber(booleanLiteral: bool), forKey: key)
    }

    func mb_setInt(_ int: Int, forKey key: NSString) {
        mb_setObject(NSNumber(integerLiteral: int), forKey: key)
    }

    func mb_setInteger(_ integer: NSInteger, forKey key: NSString) {
        mb_setObject(NSNumber(integerLiteral: integer), forKey: key)
    }

    func mb_setunsignedInteger(_ unsignedInteger: UInt, forKey key: NSString) {
        mb_setObject(NSNumber(value: unsignedInteger), forKey: key)
    }

    func mb_setCGFloat(_ cgfloat: CGFloat, forKey key: NSString) {
        mb_setObject(NSNumber(nonretainedObject: cgfloat), forKey: key)
    }

    func mb_setChar(_ char: Int8, forKey key: NSString) {
        mb_setObject(NSNumber(value: char), forKey: key)
    }

    func mb_setFloat(_ float: Float, forKey key: NSString) {
        mb_setObject(NSNumber(value: float), forKey: key)
    }

    func mb_setDouble(_ double: Double, forKey key: NSString) {
        mb_setObject(NSNumber(value: double), forKey: key)
    }

    func mb_setLongLong(_ longlong: Int64, forKey key: NSString) {
        mb_setObject(NSNumber(value: longlong), forKey: key)
    }

    func mb_setCGPoint(_ cgpoint: CGPoint, forKey key: NSString) {
        mb_setObject(NSCoder.string(for: cgpoint) as NSString, forKey: key)
    }

    func mb_setCGSize(_ cgsize: CGSize, forKey key: NSString) {
        mb_setObject(NSCoder.string(for: cgsize) as NSString, forKey: key)
    }

    func mb_setCGRect(_ cgrect: CGRect, forKey key: NSString) {
        mb_setObject(NSCoder.string(for: cgrect) as NSString, forKey: key)
    }
}
