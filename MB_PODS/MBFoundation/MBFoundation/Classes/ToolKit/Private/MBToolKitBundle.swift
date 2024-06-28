//
//  MBToolKitBundle.swift
//  MBFoundation
//
//  Created by 汪灏 on 2021/8/25.
//

import Foundation
// swiftlint:disable implicit_getter

@objc
public class MBToolKitBundle: NSObject {

    @objc public static let shared = MBToolKitBundle()

    @objc public var bundle: Bundle? {
        get {
            let bundlePath = Bundle.main.path(forResource: "MBFoundation", ofType: "bundle")
            let bubdle = Bundle(path: bundlePath ?? "")
            return bubdle
        }
    }
}
