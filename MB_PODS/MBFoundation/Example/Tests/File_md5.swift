//
//  File_md5.swift
//  MBFoundation_Tests
//
//  Created by 别施轩 on 2024/1/5.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import XCTest
import MBFoundation_Example

final class File_md5: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        guard var filePath = String.fileWithBundle(fullName: "embedded.mobileprovision") else {
            return
        }
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
        
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
        guard var filePath = String.fileWithBundle(fullName: "Info.plist") else {
            return
        }
        
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
        guard var filePath = String.fileWithBundle(fullName: "LoadableNibView.nib") else {
            return
        }
        
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
        guard var filePath = String.fileWithBundle(fullName: "MBFoundation_Example") else {
            return
        }
        
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
        guard var filePath = String.fileWithBundle(fullName: "MBFoundation.bundle/Info.plist") else {
            return
        }
        
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
        guard var filePath = String.fileWithBundle(fullName: "PkgInfo") else {
            return
        }
        
        if let data = NSData(contentsOfFile: filePath) {
            XCTAssertEqual(data.md5String(),
                           MBFileUtil.md5String(atPath: filePath))
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
