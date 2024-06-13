//
//  testAdapters.swift
//  YMMModuleLib_Tests
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

import XCTest
import YMMModuleLib

class TestAdaptersSwift: XCTestCase {

    override func setUpWithError() throws {
//
//        MBAdapter.shared.register(service: swiftServiceForSwiftImpl.self, used: serviceImplSSSI.self)
//        MBAdapter.shared.register(service: OCServiceForSwiftImpl.self, used: ObjcImplClassA.self)
//        MBAdapter.shared.register(service: swiftServiceToBeRenamed.self, used: ObjcImplClassD.self)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testOCServiceForOCImpl() throws{
        let test = MBAdapter.shared.adapter(of: OCServiceForOCImpl.self, from: nil)
        XCTAssert(test != nil)
        test?.runTest();
        XCTAssert(test?.methodCalled==true)
    }
    
    func testOCServiceForSwiftImpl() throws{
        let test = MBAdapter.shared.adapter(of: OCServiceForSwiftImpl.self, from: nil)
        XCTAssert(test != nil)
        test?.runTest();
        XCTAssert(test?.methodCalled==true)
    }
    
    func testSwiftServiceForSwiftImpl() throws{
        let test = MBAdapter.shared.adapter(of: swiftServiceForSwiftImpl.self, from: nil)
        XCTAssert(test != nil)
        test?.runTest();
        XCTAssert(test?.methodCalled==true)
    }
    
    func testSwiftServiceForOCImpl() throws{
        let test = MBAdapter.shared.adapter(of: swiftServiceForOCImpl.self, from: nil)
        XCTAssert(test != nil)
        test?.runTest();
        XCTAssert(test?.methodCalled==true)
    }
    
    func testSwiftServiceRenamed() throws{
        let test = MBAdapter.shared.adapter(of: swiftServiceToBeRenamed.self, from: nil)
        XCTAssert(test != nil)
        test?.runTest();
        XCTAssert(test?.methodCalled==true)
    }

}


