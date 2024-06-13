//
//  SwiftImplClasses.swift
//  YMMModuleLib_Tests
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

import Foundation
import YMMModuleLib


class serviceImplSSSI : NSObject, swiftServiceForSwiftImpl {
    var methodCalled: Bool = false;
    
    override required init() { super.init() }
    
    func runTest(){
        methodCalled = true
    }
}


class serviceImplCSSI : NSObject, OCServiceForSwiftImpl {    
    var methodCalled: Bool = false;
    override required init() { super.init() }
    
    func runTest(){
        methodCalled = true
        
        print("OCServiceForSwiftImpl")
    }
    
    
}


class serviceImpl : NSObject {
    var methodCalled: Bool = false;
    override required init() { super.init() }

    func runTest(){
        methodCalled = true
    }
}


class testServiceImpD : NSObject{
    
    var methodCalled: Bool = false;
    override required init() { super.init() }
    
    func runTest(){
        methodCalled = true
    }
}


class testServiceImpE :  NSObject {
    
    var methodCalled: Bool = false;
    override required init() { super.init() }
    
    func runTest(){
        methodCalled = true
    }
}
