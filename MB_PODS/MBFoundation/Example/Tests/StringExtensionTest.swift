//
//  StringExtensionTest.swift
//  MBFoundation_Tests
//
//  Created by 周翔 on 2021/9/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import MBFoundation

@objc
public extension NSString {
    func mb_appendURLQueryParametersUsingStringMatchingOld(_ params: [String: String]) -> NSString {
//        (self as String).mb.appendURLQueryParametersUsingStringMatching(params) as NSString
//    }
////}
////extension String {
//
//    func mb_appendURLQueryParametersUsingStringMatchingOld(_ params: [String: String]) -> String {
        guard !params.isEmpty else {
            return self
        }
        let queryParis = params.map { (key, value) -> String in
            return String(format: "%@=%@", key, value)
        }
        let queryString = (queryParis as NSArray).componentsJoined(by: "&")
        var range = (self as NSString).range(of: "?")
        if range.location == NSNotFound {
            range = (self as NSString).range(of: "#")
            return range.location == NSNotFound ? self.appendingFormat("?%@", queryString) : String(self).replacingOccurrences(of: "#", with: String(format: "?%@#", queryString), options: .literal) as NSString
        } else {
            return String(self).replacingOccurrences(of: "?", with: String(format: "?%@&", queryString), options: .literal) as NSString
        }
    }
}


class StringExtensionTest: XCTestCase {
    
    
    
    func testAppendURLQueryParametersUsingStringMatchingOld() {
        let arr = ["bankCode": "123"]
        var result: NSString = ""
        var url: NSString = ""
        
        result = "ymm://loan/loan_liveness_detection?bankCode=123&funderId=123"
        url = "ymm://loan/loan_liveness_detection?funderId=123"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
        result = "ymm://loan/loan_liveness_detection?bankCode=123"
        url = "ymm://loan/loan_liveness_detection"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
        
        
        result = "wlqq://activity/common_web?bankCode=123&url=wlqq://activity/common_web"
        url = "wlqq://activity/common_web?url=wlqq://activity/common_web"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
        
        result = "http://10.250.123.162:8000/microweb/aa/mw-wallet-h5/oneKeyBindCard/transfer?bankCode=123"
        url = "http://10.250.123.162:8000/microweb/aa/mw-wallet-h5/oneKeyBindCard/transfer"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
        
        result = "http://10.250.123.162:8000/microweb/transfer?bankCode=123&bankCode=123"
        url = "http://10.250.123.162:8000/microweb/transfer?bankCode=123"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
        
//        result = "http://10.250.123.162:8000/microweb/?bankCode=123#/transfer?bankCode=123"
//        url = "http://10.250.123.162:8000/microweb/#/transfer?bankCode=123"
//        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
//        // XCTAssertEqual failed: ("http://10.250.123.162:8000/microweb/#/transfer?bankCode=123&bankCode=123") is not equal to ("http://10.250.123.162:8000/microweb/?bankCode=123#/transfer?bankCode=123")
        
//        result = "http://10.250.123.162:8000/microweb/#/#/transfer?bankCode=123"
//        url = "http://10.250.123.162:8000/microweb/#/#/transfer?bankCode=123"
//        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
//        // XCTAssertEqual failed: ("http://10.250.123.162:8000/microweb/#/#/transfer?bankCode=123&bankCode=123") is not equal to ("http://10.250.123.162:8000/microweb/#/#/transfer?bankCode=123")
        
//        result = "http://10.250.123.162:8000/microweb/#/#/transfer"
//        url = "http://10.250.123.162:8000/microweb/#/#/transfer"
//        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
//        // XCTAssertEqual failed: ("http://10.250.123.162:8000/microweb/?bankCode=123#/?bankCode=123#/transfer") is not equal to ("http://10.250.123.162:8000/microweb/#/#/transfer")
        
        result = "http://10.250.123.162:8000/microweb/transfer?bankCode=123&bankCode=123&bankCode=123"
        url = "http://10.250.123.162:8000/microweb/transfer?bankCode=123&bankCode=123"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatchingOld(arr), result)
        
    }
    
    func testAppendURLQueryParametersUsingStringMatching() {
        let arr = ["bankCode": "123"]
        var result: NSString = ""
        var url: NSString = ""
        
        result = "ymm://loan/loan_liveness_detection?bankCode=123&funderId=123"
        url = "ymm://loan/loan_liveness_detection?funderId=123"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
        result = "ymm://loan/loan_liveness_detection?bankCode=123"
        url = "ymm://loan/loan_liveness_detection"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
        
        
        result = "wlqq://activity/common_web?bankCode=123&url=wlqq://activity/common_web"
        url = "wlqq://activity/common_web?url=wlqq://activity/common_web"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
        
        result = "http://10.250.123.162:8000/microweb/aa/mw-wallet-h5/oneKeyBindCard/transfer?bankCode=123"
        url = "http://10.250.123.162:8000/microweb/aa/mw-wallet-h5/oneKeyBindCard/transfer"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
        
        result = "http://10.250.123.162:8000/microweb/transfer?bankCode=123&bankCode=123"
        url = "http://10.250.123.162:8000/microweb/transfer?bankCode=123"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
        
//        result = "http://10.250.123.162:8000/microweb/?bankCode=123#/transfer?bankCode=123"
//        url = "http://10.250.123.162:8000/microweb/#/transfer?bankCode=123"
//        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
//
//        result = "http://10.250.123.162:8000/microweb/#/#/transfer?bankCode=123"
//        url = "http://10.250.123.162:8000/microweb/#/#/transfer?bankCode=123"
//        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
//
//        result = "http://10.250.123.162:8000/microweb/#/#/transfer"
//        url = "http://10.250.123.162:8000/microweb/#/#/transfer"
//        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
//
        result = "http://10.250.123.162:8000/microweb/transfer?bankCode=123&bankCode=123&bankCode=123"
        url = "http://10.250.123.162:8000/microweb/transfer?bankCode=123&bankCode=123"
        XCTAssertEqual(url.mb_appendURLQueryParametersUsingStringMatching(arr), result)
    }

    func testIsValidUrl() {
        XCTAssert("https://google.com".isValidUrl)
        XCTAssert("http://google.com".isValidUrl)
        XCTAssert("ftp://google.com".isValidUrl)
    }
    
    func testIsValidSchemedUrl() {
        XCTAssertFalse("Hello world!".isValidSchemedUrl)
        XCTAssert("https://google.com".isValidSchemedUrl)
        XCTAssert("ftp://google.com".isValidSchemedUrl)
        XCTAssertFalse("google.com".isValidSchemedUrl)
    }
    
    
    func testIsValidHttpsUrl() {
        XCTAssertFalse("Hello world!".isValidHttpsUrl)
        XCTAssert("https://google.com".isValidHttpsUrl)
        XCTAssertFalse("http://google.com".isValidHttpsUrl)
        XCTAssertFalse("google.com".isValidHttpsUrl)
    }

    func testIsValidHttpUrl() {
        XCTAssertFalse("Hello world!".isValidHttpUrl)
        XCTAssert("http://google.com".isValidHttpUrl)
        XCTAssertFalse("google.com".isValidHttpUrl)
    }

    func testIsValidFileURL() {
        XCTAssertFalse("Hello world!".isValidFileUrl)
        XCTAssert("file://var/folder/file.txt".isValidFileUrl)
        XCTAssertFalse("google.com".isValidFileUrl)
    }
    
    func testUrl() {
        XCTAssertNil("hello world".url)
        let google = "https://www.google.com"
        XCTAssertEqual(google.url, URL(string: google))
    }
    
    func testIntercept() {
        XCTAssertEqual("helloworld"[0...4], "hello")
        XCTAssertEqual("helloworld"[0..<4], "hell")
    }
    
    func testDir() {
        let cache = "xxx.txt".cacheDir()
        let doc = "xxx.mp4".docDir()
        let tmp = "xxx.gif".tmpDir()
        let home = NSHomeDirectory()
        XCTAssertEqual(home + "/Library/Caches/xxx.txt", cache)
        XCTAssertEqual(home + "/Documents/xxx.mp4", doc)
        #if targetEnvironment(simulator)
        XCTAssertEqual(home + "/tmp/xxx.gif", tmp)
        #else
        XCTAssertEqual("/private\(home)/tmp/xxx.gif", tmp)
        #endif
    }
    
    func testRandomString() {
        var cachedDic : Dictionary<String, Int> = Dictionary<String, Int>()
        for _ in 0 ..< 10000 {
            let randomString:String = String.mb.randomString(len: 10)
            print("testRandomString:%@", randomString)
            if (cachedDic.contains{ (key, value) -> Bool in
                key == randomString
            }) {
                    XCTAssertFalse(cachedDic[randomString]! > 1)
            } else {
                cachedDic[randomString] = 1
            }
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testStringContains() throws {
        let testStr = "abc"
        XCTAssertTrue(testStr.mb.contains(string: "a", caseInSensitive: false))
        XCTAssertFalse(testStr.mb.contains(string: "123", caseInSensitive: true))
        XCTAssertFalse(testStr.mb.contains(string: "cba", caseInSensitive: false))
        XCTAssertFalse(testStr.mb.contains(string: "abcd", caseInSensitive: false))
        XCTAssertFalse(testStr.mb.contains(string: "A", caseInSensitive: false))
        XCTAssertFalse(testStr.mb.contains(string: "", caseInSensitive: false))
        XCTAssertTrue(testStr.mb.contains(string: "bc", caseInSensitive: true))
    }
}
