//
//  MBBridgeVisitor.swift
//  YMMBridgeLib
//
//  Created by changxm on 2023/9/2.
//

import Foundation

@objc
public class MBBridgeVisitor: NSObject {
    
    // 调用者来源 flutter / rn / h5 / native / davinci / global-logic
    @objc public var source: String?
    // 业务bundle名
    @objc public var bundleName: String?
    // 业务bundle版本号
    @objc public var bundleVersion: String?
    
    @objc public init(request: YMMPluginRequest) {
        self.source = request.source
        self.bundleName = request.bundleName
        self.bundleVersion = request.bundleVersion
    }
    
}

