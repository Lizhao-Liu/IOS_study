//
//  MBIdentifyUtil.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/20.
//
//  Note20220314: 未在宿主使用，使用前先测试

import UIKit

/// 不推荐使用，推荐使用  [[NSUUID UUID] UUIDString] 或  UUID().uuidString
@objc open class MBIdentifyUtil: NSObject {
    /// 不推荐使用，推荐使用  [[NSUUID UUID] UUIDString] 或  UUID().uuidString
    @objc public class func ymm_uuid() -> String {
        let uuidRef = CFUUIDCreate(nil)
        let uuidStringRef = CFUUIDCreateString(nil , uuidRef)
        let uuid = uuidStringRef! as String
        return uuid
    }
}
