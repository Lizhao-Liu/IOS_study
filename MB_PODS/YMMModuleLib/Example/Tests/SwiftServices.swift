//
//  SwiftServices.swift
//  YMMModuleLib_Tests
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

import Foundation
import YMMModuleLib

@objc public protocol swiftServiceForSwiftImpl: MBAdapterProtocol {
    var methodCalled : Bool {get set}
    func runTest()
}

@objc public protocol swiftServiceForOCImpl: MBAdapterProtocol {
    @objc var methodCalled : Bool {get set}
    func runTest()
}

@objc(swiftServiceRenamedInOC)
public protocol swiftServiceToBeRenamed: MBAdapterProtocol {
    var methodCalled : Bool {get set}
    func runTest()
}


@objc public protocol swiftServiceAdapterBase: MBAdapterProtocol {
    var methodCalled : Bool {get set}
    func runTest()
}


@objc public protocol swiftServiceAdapter1: swiftServiceAdapterBase {
    var methodCalled : Bool {get set}

}

@objc public protocol swiftServiceAdapter2: MBAdapterProtocol {
    var methodCalled : Bool {get set}

}

@objc public protocol swiftServiceNotRegistered: MBAdapterProtocol {
    var methodCalled : Bool {get set}
    func runTest()
}
