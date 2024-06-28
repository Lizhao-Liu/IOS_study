// 
//  ArrayExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// MARK: JSON

// swiftlint:disable all
public extension MBFoundationWrapper where T == [AnyObject] {

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

public extension MBFoundationWrapper where T == [String] {

    func anyValue(at index: Int) -> String? {
        guard index < this.count,
              index >= 0,
              this.count > 0 else {
                  return nil
              }
        return this[index]
    }

}

public extension MBFoundationWrapper where T == [AnyObject] {

    func anyValue(at index: Int) -> AnyObject? {
        guard index < this.count,
              index >= 0,
              this.count > 0 else {
                  return nil
              }
        return this[index]
    }

}

// MARK: Mutable

public extension MBFoundationWrapper where T == [AnyObject] {

}

// MARK: UnicodeReadable

#if DEBUG
public extension MBFoundationWrapper where T == [AnyObject] {

}
#endif

/**
 C 类型                               Swift 对应类型                       别名
 bool                                CBool                               Bool
 char,unsigned char                  CChar, CUnsignedChar                Int8, UInt8
 short, unsigned short               CShort, CUnsignedShort              Int16, UInt16
 int, unsigned int                   CInt, CUnsignedInt                  Int32, UInt32
 long, unsigned long                 CLong, CUnsignedLong                Int, UInt
 long long, unsigned long long       CLongLong, CUnsignedLongLong        Int64, UInt64
 wchar_t, char16_t, char32_t         CWideChar, CChar16, CChar32         UnicodeScalar, UInt16, UnicodeScalar
 float, double                       CFloat, CDouble                     Float, Double
 */

@objc
public extension NSArray {

    // MARK: JSON

    func mb_jsonString() -> NSString? {
        (self as Array).mb.json as NSString?
    }

    func mb_jsonPrettyString() -> NSString? {
        (self as Array).mb.jsonPretty as NSString?
    }

    func mb_jsonData() -> NSData? {
        (self as Array).mb.jsonData as NSData?
    }

    // MARK: Immutable
    
    static func mb_isNilOrEmpty(_ array: NSArray?) -> Bool {
        guard let array = array else { return true }
        return array.mb_isEmpty()
    }

    func mb_isEmpty() -> Bool {
        (self as Array).isEmpty
    }

    func mb_count() -> NSInteger {
        (self as Array).count as NSInteger
    }

    func mb_object(at index: NSInteger) -> Any? {
        (self as Array).mb.anyValue(at: index)
    }

    func mb_string(at index: NSInteger) -> NSString? {
        let any = (self as Array).mb.anyValue(at: index)

        if let string = any as? NSString {
            return string
        }

        if let number = any as? NSNumber {
            return NSString(utf8String: number.stringValue)
        }

        return nil
    }

    func mb_number(at index: NSInteger) -> NSNumber? {
        let any = (self as Array).mb.anyValue(at: index)

        if let number = any as? NSNumber {
            return number
        }

        if let string = any as? NSString {
            return NSNumber(integerLiteral: string.integerValue)
        }

        return nil
    }

    func mb_array(at index: NSInteger) -> NSArray? {
        let any = (self as Array).mb.anyValue(at: index)

        if let array = any as? NSArray {
            return array
        }

        return nil
    }

    func mb_dictionary(at index: NSInteger) -> NSDictionary? {
        let any = (self as Array).mb.anyValue(at: index)

        if let dictionary = any as? NSDictionary {
            return dictionary
        }

        return nil
    }

    func mb_decimalNumber(at index: NSInteger) -> NSDecimalNumber? {
        let any = (self as Array).mb.anyValue(at: index)

        if let decimalNumber = any as? NSDecimalNumber {
            return decimalNumber
        }

        if let number = any as? NSNumber {
            return NSDecimalNumber(decimal: number.decimalValue)
        }

        if let value = any as? String,
           !value.isEmpty,
           let number = NSNumber(string: value) {
            return NSDecimalNumber(decimal: number.decimalValue)
        }

        return nil
    }

    func mb_bool(at index: Int) -> Bool {
        let any = (self as Array).mb.anyValue(at: index)

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

    func mb_integer(at index: NSInteger) -> NSInteger {
        let any = (self as Array).mb.anyValue(at: index)

        if let integer = any as? NSInteger {
            return integer
        }

        if let string = any as? NSString {
            return string.integerValue
        }

        return 0
    }

    func mb_int8(at index: Int) -> Int8 {
        let any = (self as Array).mb.anyValue(at: index)

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

    func mb_int16(at index: Int) -> Int16 {
        let any = (self as Array).mb.anyValue(at: index)

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

    func mb_int32(at index: Int) -> Int32 {
        let any = (self as Array).mb.anyValue(at: index)

        if let int32 = any as? Int32 {
            return int32
        }

        if let number = any as? NSNumber {
            return number.int32Value
        }

        if let string = any as? NSString {
            return string.intValue
        }

        return 0
    }

    func mb_int64(at index: Int) -> Int64 {
        let any = (self as Array).mb.anyValue(at: index)

        if let int64 = any as? Int64 {
            return int64
        }

        if let number = any as? NSNumber {
            return number.int64Value
        }

        if let string = any as? NSString {
            return string.longLongValue
        }

        return 0
    }

    func mb_unsignedInteger(at index: Int) -> UInt {
        let any = (self as Array).mb.anyValue(at: index)

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

    func mb_unsignedInt8(at index: Int) -> UInt8 {
        let any = (self as Array).mb.anyValue(at: index)

        if let int8 = any as? UInt8 {
            return int8
        }

        if let number = any as? NSNumber {
            return number.uint8Value
        }

        if let string = any as? NSString {
            return UInt8(string.intValue)
        }

        return 0
    }

    func mb_unsignedInt16(at index: Int) -> UInt16 {
        let any = (self as Array).mb.anyValue(at: index)

        if let int16 = any as? UInt16 {
            return int16
        }

        if let number = any as? NSNumber {
            return number.uint16Value
        }

        if let string = any as? NSString {
            return UInt16(string.intValue)
        }

        return 0
    }

    func mb_unsignedInt32(at index: Int) -> UInt32 {
        let any = (self as Array).mb.anyValue(at: index)

        if let int32 = any as? UInt32 {
            return int32
        }

        if let number = any as? NSNumber {
            return number.uint32Value
        }

        if let string = any as? NSString {
            return UInt32(string.intValue)
        }

        return 0
    }

    func mb_unsignedInt64(at index: Int) -> UInt64 {
        let any = (self as Array).mb.anyValue(at: index)

        if let int64 = any as? UInt64 {
            return int64
        }

        if let number = any as? NSNumber {
            return number.uint64Value
        }

        if let string = any as? NSString {
            return UInt64(string.longLongValue)
        }

        return 0
    }

    func mb_float(at index: Int) -> Float {
        let any = (self as Array).mb.anyValue(at: index)

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

    func mb_double(at index: Int) -> Double {
        let any = (self as Array).mb.anyValue(at: index)

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

    func mb_CGFloat(at index: Int) -> CGFloat {
        let any = (self as Array).mb.anyValue(at: index)

        if let float = any as? CGFloat {
            return float
        }
        
        if let number = any as? NSNumber {
            return number.doubleValue
        }

        if let string = any as? NSString {
            return string.doubleValue
        }

        return 0
    }

    func mb_CGPoint(at index: Int) -> CGPoint {
        let any = (self as Array).mb.anyValue(at: index)

        if let point = any as? CGPoint {
            return point
        }

        if let string = any as? NSString {
            return NSCoder.cgPoint(for: string as String)
        }

        return CGPoint.zero
    }

    func mb_CGSize(at index: Int) -> CGSize {
        let any = (self as Array).mb.anyValue(at: index)

        if let size = any as? CGSize {
            return size
        }

        if let string = any as? NSString {
            return NSCoder.cgSize(for: string as String)
        }

        return CGSize.zero
    }

    func mb_CGRect(at index: Int) -> CGRect {
        let any = (self as Array).mb.anyValue(at: index)

        if let rect = any as? CGRect {
            return rect
        }

        if let string = any as? NSString {
            return NSCoder.cgRect(for: string as String)
        }

        return CGRect.zero
    }

    // MARK: Generic Covariant

    func mb_each(_ block: (Any) -> Void) {
        for obj in self {
            block(obj)
        }
    }

    @discardableResult
    func mb_map(_ block: (Any) -> Any?) -> NSArray {
        let result = NSMutableArray()
        for obj in self {
            if let mappedObj = block(obj) {
                result.add(mappedObj)
            }
        }
        return NSArray(array: result as! [Any], copyItems: false)
    }

    @discardableResult
    func mb_flatMap(_ block: (Any) -> Any?) -> NSArray {
        let result = NSMutableArray()
        for obj in self {
            if let mappedObj = block(obj) {
                if mappedObj is NSArray {
                    result.addObjects(from: mappedObj as! [Any])
                } else if mappedObj is NSDictionary {
                    result.addObjects(from: (mappedObj as! NSDictionary).allValues)
                } else {
                    result.add(mappedObj)
                }
            }
        }
        return NSArray(array: result as! [Any], copyItems: false)
    }

    @discardableResult
    func mb_filter(_ block: (Any) -> Bool) -> NSArray {
        let result = NSMutableArray()
        for obj in self {
            if block(obj) {
                result.add(obj)
            }
        }
        return NSArray(array: result as! [Any], copyItems: false)
    }

    @discardableResult
    func mb_reduce(_ initial: Any, block: (Any, Any) -> Any) -> Any? {
        var result = initial
        for obj in self {
            result = block(result, obj)
        }
        return result
    }

    @discardableResult
    func mb_first(_ block: (Any) -> Bool) -> Any? {
        for obj in self {
            if block(obj) {
                return obj
            }
        }
        return nil
    }

}

@objc
public extension NSMutableArray {

    // MARK: Mutable

    func mb_add(_ object: Any?) {
        guard let object = object else { return }
        self.add(object)
    }

    func mb_add(string: NSString) {
        mb_add(string)
    }

    func mb_add(bool: Bool) {
        mb_add(NSNumber(value: bool))
    }

    func mb_add(int: Int) {
        mb_add(NSNumber(integerLiteral: int))
    }

    func mb_add(int8: Int8) {
        mb_add(NSNumber(value: int8))
    }

    func mb_add(integer: NSInteger) {
        mb_add(NSNumber(integerLiteral: integer))
    }

    func mb_add(unsignedInteger: UInt) {
        mb_add(NSNumber(value: unsignedInteger))
    }

    func mb_add(float: Float) {
        mb_add(NSNumber(value: float))
    }

    func mb_add(cgfloat: CGFloat) {
        mb_add(NSNumber(value: Float(cgfloat)))
    }

    func mb_add(double: Double) {
        mb_add(NSNumber(value: double))
    }

    func mb_add(point: CGPoint) {
        mb_add(NSCoder.string(for: point))
    }

    func mb_add(size: CGSize) {
        mb_add(NSCoder.string(for: size))
    }

    func mb_add(rect: CGRect) {
        mb_add(NSCoder.string(for: rect))
    }

    func mb_insert(_ object: Any?, at index: Int) {
        guard let object = object else { return }
        insert(object, at: index)
    }

    func mb_remove(at index: Int) {
        removeObject(at: index)
    }

    func mb_removeAll() {
        removeAllObjects()
    }

    func mb_replace(at index: Int, with object: Any?) {
        guard let object = object else { return }
        replaceObject(at: index, with: object)
    }

    func mb_addContainNil(_ object: Any?) {
        guard let object = object else {
            mb_add(NSNull())
            return
        }
        mb_add(object)
    }

    func mb_insertContainNil(_ object: Any?, at index: Int) {
        guard let object = object else {
            mb_insert(NSNull(), at: index)
            return
        }
        mb_insert(object, at: index)
    }

}
