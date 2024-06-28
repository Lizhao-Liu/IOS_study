//
//  DataExtensionTest.swift
//  MBFoundation_Tests
//
//  Created by 别施轩 on 2021/8/18.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import MBToolKit
import MBFoundation


class Test: Equatable {
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.test1 == rhs.test1 &&
            lhs.test2 == rhs.test2 &&
            lhs.test3 == rhs.test3
    }
    init() {}
    
    var test1: String?
    var test2: [String?]?
    var test3: [String?: String?]?
}


class DataExtensionTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testmb_md2Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.md2() as NSData?,
              let rhs = data.mb_md2Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.md2() as NSData?,
              let rhs2 = data2.mb_md2Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_md4Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.md4() as NSData?,
              let rhs = data.mb_md4Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.md4() as NSData?,
              let rhs2 = data2.mb_md4Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_md5Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.md5() as NSData?,
              let rhs = data.mb_md5Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.md5() as NSData?,
              let rhs2 = data2.mb_md5Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_sha1Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.sha1() as NSData?,
              let rhs = data.mb_sha1Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.sha1() as NSData?,
              let rhs2 = data2.mb_sha1Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_sha224Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.sha224() as NSData?,
              let rhs = data.mb_sha224Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.sha224() as NSData?,
              let rhs2 = data2.mb_sha224Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_sha256Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.sha256() as NSData?,
              let rhs = data.mb_sha256Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.sha256() as NSData?,
              let rhs2 = data2.mb_sha256Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_sha384Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.sha384() as NSData?,
              let rhs = data.mb_sha384Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.sha384() as NSData?,
              let rhs2 = data2.mb_sha384Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_sha512Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.sha512() as NSData?,
              let rhs = data.mb_sha512Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.sha512() as NSData?,
              let rhs2 = data2.mb_sha512Data() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_crc32StringData() throws {
        //        XCTAssertEqual(GuardSwitch.shared.methodSwitch, false)
        
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.crc32String() as NSString?,
              let rhs = data.mb_crc32String() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.crc32String() as NSString?,
              let rhs2 = data2.mb_crc32String() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_crc32Data() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.crc32() as UInt32?,
              let rhs = data.mb_crc32() as UInt32? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.crc32() as UInt32?,
              let rhs2 = data2.mb_crc32() as UInt32? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_utf8StringData() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.utf8String() as NSString?,
              let rhs = data.mb_utf8String() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.utf8String() as NSString?,
              let rhs2 = data2.mb_utf8String() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_hexStringData() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.hexString() as NSString?,
              let rhs = data.mb_hexString() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.hexString() as NSString?,
              let rhs2 = data2.mb_hexString() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_base64StringData() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.base64String() as NSString?,
              let rhs = data.mb_base64EncodedString() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.base64String() as NSString?,
              let rhs2 = data2.mb_base64EncodedString() as NSString? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    func testmb_jsonObjectData() throws {
        let string =
            """
            {
                "test1": "\(UUID().uuidString)",
                "test2": ["\(UUID().uuidString)"],
                "test3": {
                    "test4": "\(UUID().uuidString)"
                }
            }
            """
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.jsonObject() as Any?,
              let rhs = data.mb_jsonValueDecoded() as Any? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertNotNil(lhs)
        XCTAssertNotNil(rhs)
        
        
        let string2 =
            """
            {
                "test1": "\(UUID().uuidString)",
                "test2": ["\(UUID().uuidString)"],
                "test3": {
                    "test4": "\(UUID().uuidString)"
                }
            }
            """
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.jsonObject() as Any?,
              let rhs2 = data2.mb_jsonValueDecoded() as Any? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertNotNil(lhs2)
        XCTAssertNotNil(rhs2)
    }
    
    func testmb_zlibDeflateData() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.zlibDeflate() as NSData?,
              let rhs = data.mb_deflate() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        // 这一条会测试失败，因为ToolKit和Foundation压缩后的数据不一致
//        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.zlibDeflate() as NSData?,
              let rhs2 = data2.mb_deflate() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        // 这一条会测试失败，因为ToolKit和Foundation压缩后的数据不一致
//        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
        
        //inflate
        
        
        guard let lhs_ = lhs.zlibInflate() as NSData?,
              let rhs_ = rhs.mb_inflate() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs_, rhs_)
        XCTAssertEqual(lhs_, data)
        
        
        guard let lhs_2 = lhs2.zlibInflate() as NSData?,
              let rhs_2 = rhs2.mb_inflate() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs_2, rhs_2)
        XCTAssertEqual(lhs_2, data2)
    }
    
    func testmb_gzipDeflateData() throws {
        let string = UUID().uuidString
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.gzipDeflate() as NSData?,
              let rhs = data.mb_gzip() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        // 这一条会测试失败，因为ToolKit和Foundation压缩后的数据不一致
//        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.gzipDeflate() as NSData?,
              let rhs2 = data2.mb_gzip() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        
        // 这一条会测试失败，因为ToolKit和Foundation压缩后的数据不一致
//        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
        
        // unzip
        
        guard let lhs_ = lhs.gzipInflate() as NSData?,
              let rhs_ = rhs.mb_gunzip() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs_, rhs_)
        XCTAssertEqual(lhs_, data)
        
        
        guard let lhs_2 = lhs2.gzipInflate() as NSData?,
              let rhs_2 = rhs2.mb_gunzip() as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs_2, rhs_2)
        XCTAssertEqual(lhs_2, data2)
    }
    
    func testmb_aes128EncryptData() throws {
        let string = UUID().uuidString
        let key = String(UUID().uuidString.prefix(16))
        let iv = String(UUID().uuidString.prefix(16))
        
        guard let data = string.data(using: .utf8) as NSData?,
              let lhs = data.aes128Encrypt(withKey: key, iv: iv) as NSData?,
              let rhs = data.mb_aes128Encrypt(key: key as NSString, iv: iv as NSString) as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs, rhs)
        
        
        let string2 = UUID().uuidString
        let key2 = String(UUID().uuidString.prefix(16))
        let iv2 = String(UUID().uuidString.prefix(16))
        guard let data2 = string2.data(using: .utf8) as NSData?,
              let lhs2 = data2.aes128Encrypt(withKey: key2, iv: iv2) as NSData?,
              let rhs2 = data2.mb_aes128Encrypt(key: key2 as NSString, iv: iv2 as NSString) as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs2, rhs2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
        
        
        //decrypt
        
        
        guard let lhs_ = lhs.aes128Decrypt(withKey: key, iv: iv) as NSData?,
              let rhs_ = rhs.mb_aes128Decrypt(key: key, iv: iv) as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs_, rhs_)
        XCTAssertEqual(lhs_, data)
        
        guard let lhs_2 = lhs2.aes128Decrypt(withKey: key2, iv: iv2) as NSData?,
              let rhs_2 = rhs2.mb_aes128Decrypt(key: key2, iv: iv2) as NSData? else {
            XCTAssertThrowsError("")
            return
        }
        XCTAssertEqual(lhs_2, rhs_2)
        XCTAssertEqual(lhs_2, data2)
        
        XCTAssertNotEqual(string, string2)
        XCTAssertNotEqual(lhs, lhs2)
    }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}


// DataCompressor.swift - warning fix
// 'withUnsafeBytes' is deprecated: use `withUnsafeBytes<R>(_: (UnsafeRawBufferPointer) throws -> R) rethrows -> R` instead
//        let deflated = data.withUnsafeBytes { (unsafeRawBufferPointer: UnsafeRawBufferPointer) -> Data? in
//            let config = (operation: COMPRESSION_STREAM_ENCODE, algorithm: COMPRESSION_ZLIB)
//            let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)
//            let sourcePtr = unsafeBufferPointer.baseAddress!
//            return perform(config, source: sourcePtr, sourceSize: data.count, preload: header)
//        }
