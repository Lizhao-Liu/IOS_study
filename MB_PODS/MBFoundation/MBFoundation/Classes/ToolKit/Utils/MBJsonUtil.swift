//
//  MBJsonUtil.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/20.
//

import UIKit
// swiftlint:disable line_length

@objc open class MBJsonUtil: NSObject {
    /// json转dictionary
    /// @param jsonString jsonString description
    @objc public class func dictionaryWithJsonString(_ jsonString : String?) -> [String : Any]? {
        guard let jsonString = jsonString, let jsonData = jsonString.data(using: .utf8)  else { return nil }
        if let dic = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String : Any] {
            return dic
        } else {
            return nil
        }
    }

    /// json转数组
    /// @param jsonString jsonString description
    @objc public class func arrayWithJsonString(_ jsonString : String?) -> [Any]? {
        guard let jsonString = jsonString, let jsonData = jsonString.data(using: .utf8)  else { return nil }
        if let arr = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [Any] {
            return arr
        } else {
            return nil
        }
    }

    /// dictionary转json
    /// @param dic dictionary description
    @objc public class func dictionaryToJson(_ dic : [String : Any]?) -> String? {
        guard let dic = dic else { return nil }
        if let strData = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) as Data? {
            return String.init(data: strData, encoding: .utf8)
        }
        return nil
    }
    /// array转json
    /// @param array array description
    @objc public class func arrayToJson(_ array : [Any]?) -> String? {
        guard let array = array else { return nil }
        if let strData = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) as Data? {
            return String.init(data: strData, encoding: .utf8)
        }
        return nil
    }

}
