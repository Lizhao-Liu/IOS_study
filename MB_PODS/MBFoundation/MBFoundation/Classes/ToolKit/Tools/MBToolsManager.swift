//
//  MBToolsManager.swift
//  MBFoundation
//
//  Created by 汪灏 on 2021/8/25.
//

import Foundation

@objc
public class MBToolsManager: NSObject {

    private var isHCBNumber: NSNumber?

    private static let shared = MBToolsManager()

    @objc public static func setupWithCompany(_ isHCB: Bool) {
        MBToolsManager.shared.isHCBNumber = NSNumber(value: isHCB)
    }

    @objc public static func isHCB() -> Bool {
        let number = MBToolsManager.shared.isHCBNumber
        assert(number != nil, "请首先初始化MBToolKit!!!!!!")
        return number?.boolValue ?? false
    }
}
