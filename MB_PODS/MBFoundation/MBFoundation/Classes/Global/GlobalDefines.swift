//
//  GlobalDefines.swift
//  MBFoundation
//
//  Created by rensihao on 2021/1/30.
//

import Foundation
// swiftlint:disable unused_setter_value
// swiftlint:disable identifier_name

// MARK: Generic NameSpace

public struct MBFoundationWrapper<T> {
    let this: T
    let THIS: Self.Type
    init(_ object: T) {
        self.this = object
        self.THIS = Self.self
    }
}

public protocol MBFoundationWrappable {
    associatedtype WrapperType
    var mb: WrapperType { get set }
    static var mb: WrapperType.Type { get set }
}

public extension MBFoundationWrappable {
    var mb: MBFoundationWrapper<Self> {
        get { MBFoundationWrapper<Self>(self) }
        set { }
    }
    static var mb: MBFoundationWrapper<Self>.Type {
        get { MBFoundationWrapper<Self>.self }
        set { }
    }
}

public protocol MBFoundationWrappableObject: MBFoundationWrappable, AnyObject { }
public protocol MBFoundationWrappableValue: MBFoundationWrappable { }

extension Array: MBFoundationWrappableValue { }
extension Character: MBFoundationWrappableValue { }
extension Data: MBFoundationWrappableValue { }
extension Date: MBFoundationWrappableValue { }
extension DateFormatter: MBFoundationWrappableObject { }
extension Dictionary: MBFoundationWrappableValue { }
extension DispatchQueue: MBFoundationWrappableObject { }
extension String: MBFoundationWrappableValue { }
extension Substring: MBFoundationWrappableValue { }
extension Timer: MBFoundationWrappableObject { }

// MARK: Console Log
// swiftlint:disable:next identifier_name
public func Print<T>(message: T,
                     fileName: String = #file,
                     methodName: String = #function,
                     lineNumber: Int = #line) {
#if DEBUG
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
      let lastPath = (fileName as NSString).lastPathComponent
      print("\(formatter.string(from: Date())) [\(lastPath)][第\(lineNumber)行] \n\t\t \(message)")
#endif
}

// MARK: OC Type Check

@objc
public protocol MBFoundationOCValidationable {
    static func isValid(_ object: AnyObject?, cls: AnyClass) -> Bool
    static func isValidAndValuable(_ object: AnyObject?, cls: AnyClass) -> Bool
}

@objc
public class MBFoundationOCValidator: NSObject, MBFoundationOCValidationable {

    private override init() {
        super.init()
    }

    public static func isValid(_ object: AnyObject?, cls: AnyClass) -> Bool {
        guard let object = object else { return false }
        return object.isKind(of: cls)
    }

    public static func isValidAndValuable(_ object: AnyObject?, cls: AnyClass) -> Bool {
        guard isValid(object, cls: cls) else { return false }

        if let string = object as? NSString {
            return string.length != 0
        }

        if let number = object as? NSNumber {
            return number.intValue != 0
        }

        if let array = object as? NSArray {
            // swiftlint:disable:next empty_count
            return array.count != 0
        }

        if let dictionary = object as? NSDictionary {
            // swiftlint:disable:next empty_count
            return dictionary.count != 0
        }

        if let data = object as? NSData {
            return !data.isEmpty
        }

        return false
    }
}
