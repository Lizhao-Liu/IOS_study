//
//  YMMAppUtil.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/19.
//

import UIKit

@objc open class MBAppUtil: NSObject {
    @objc public class func appComanyIsYMM() -> Bool {
        return (Bundle.main.object(forInfoDictionaryKey: "App-type") as? String) == "YMM"
    }
}
