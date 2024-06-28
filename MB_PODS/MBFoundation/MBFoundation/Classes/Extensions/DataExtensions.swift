// 
//  DataExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation
import CommonCrypto

// MARK: Hash
// swiftlint:disable implicit_getter
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable file_length
public extension MBFoundationWrapper where T == Data {

    func checksum() -> UInt16 {
        let s = this.withUnsafeBytes { buf in
            return buf.lazy.map(UInt32.init).reduce(UInt32(0), +)
        }
        return UInt16(s % 65535)
   }

    func md2Data() -> Data? {
        this.digestData(using: .md2)
    }

    func md4Data() -> Data? {
        this.digestData(using: .md4)
    }

    func md5Data() -> Data? {
        this.digestData(using: .md5)
    }

    func sha1Data() -> Data? {
        this.digestData(using: .sha1)
    }

    func sha224Data() -> Data? {
        this.digestData(using: .sha224)
    }

    func sha256Data() -> Data? {
        this.digestData(using: .sha256)
    }

    func sha384Data() -> Data? {
        this.digestData(using: .sha384)
    }

    func sha512Data() -> Data? {
        this.digestData(using: .sha512)
    }

    func hmacMD5DataWith(key: Data) -> Data? {
        nil
    }

    func hmacSHA1DataWith(key: Data) -> Data? {
        nil
    }

    func hmacSHA224DataWith(key: Data) -> Data? {
        nil
    }

    func hmacSHA256DataWith(key: Data) -> Data? {
        nil
    }

    func hmacSHA384DataWith(key: Data) -> Data? {
        nil
    }

    func hmacSHA512DataWith(key: Data) -> Data? {
        nil
    }

    func crc32String() -> String {
        String(format: "%08x", DataCompressor.crc32(this).checksum)
    }

    func crc32() -> UInt32 {
        DataCompressor.crc32(this).checksum.littleEndian
    }

}

// MARK: Encode & Decode

public extension MBFoundationWrapper where T == Data {

    func utf8String() -> String {
        String(decoding: this , as: UTF8.self)
    }

    func hexString() -> String {
        this.map { String(format: "%02hhx", $0) }.joined()
    }

    static func dataWithHexString(_ string: String) -> Data? {
        guard !string.isEmpty else {
            return nil
        }
        let len = string.count / 2
        var data = Data(capacity: len)
        var i = string.startIndex
        for _ in 0..<len {
            let j = string.index(i, offsetBy: 2)
            let bytes = string[i..<j]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
            i = j
        }
        return data
    }

    func base64EncodedString() -> String {
        this.base64EncodedString()
    }

    static func dataWithBase64EncodedString(_ string: String) -> Data? {
        guard !string.isEmpty else {
            return nil
        }
        return Data(base64Encoded: string, options: .ignoreUnknownCharacters)
    }

    func jsonValueDecoded() -> Any? {
        try? JSONSerialization.jsonObject(with: this, options: [])
    }

    static func jsonDataEncoded(with jsonObject: Any) -> Data? {
        if JSONSerialization.isValidJSONObject(jsonObject) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
                return jsonData
            }
            return nil
        }
        return nil
    }

}

// MARK: Inflate & Deflate

public extension MBFoundationWrapper where T == Data {

    /// Using zlib deflate algorithm to compress [RFC-1951](https://tools.ietf.org/html/rfc1951).
    /// - Returns: compressed data
    func deflate() -> Data? {
        DataCompressor.deflate(this)
    }

    /// Using zlib deflate algorithm to decompress [RFC-1951](https://tools.ietf.org/html/rfc1951).
    /// - Returns: decompressed data
    func inflate() -> Data? {
        DataCompressor.inflate(this)
    }

    /// Using zlib deflate algorithm to compress [RFC-1950](https://tools.ietf.org/html/rfc1950).
    /// - Returns: compressed data
    func zip() -> Data? {
        DataCompressor.zip(this)
    }

    /// Using zlib deflate algorithm to decompress [RFC-1950](https://tools.ietf.org/html/rfc1950).
    /// - Returns: decompressed data
    func unzip(skipCheckSumValidation: Bool = true) -> Data? {
        DataCompressor.unzip(this, skipCheckSumValidation: skipCheckSumValidation)
    }

    /// Using deflate algorithm to compress [RFC-1952](https://tools.ietf.org/html/rfc1952)
    /// - Returns: compressed data
    func gzip() -> Data? {
        DataCompressor.gzip(this)
    }

    /// Using deflate algorithm to decompress [RFC-1952](https://tools.ietf.org/html/rfc1952)
    /// - Returns: decompressed data
    func gunzip() -> Data? {
        DataCompressor.gunzip(this)
    }

}

// MARK: Encrypt & Decrypt

public extension MBFoundationWrapper where T == Data {

    func aes128Encrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricEncrypt(algorithm: .aes_128, data: this, key: keyData, iv: ivData)
    }

    func aes128Decrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricDecrypt(algorithm: .aes_128, data: this, key: keyData, iv: ivData)
    }

    func aes256Encrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricEncrypt(algorithm: .aes_256, data: this, key: keyData, iv: ivData)
    }

    func aes256Decrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricDecrypt(algorithm: .aes_256, data: this, key: keyData, iv: ivData)
    }

    func desEncrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricEncrypt(algorithm: .des, data: this, key: keyData, iv: ivData)
    }

    func desDecrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricDecrypt(algorithm: .des, data: this, key: keyData, iv: ivData)
    }

    func threeDesEncrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricEncrypt(algorithm: .tripleDES, data: this, key: keyData, iv: ivData)
    }

    func threeDesDecrypt(key: String, iv: String? = nil) -> Data? {
        guard let keyData = key.data(using: .utf8) else { return nil }
        let ivData = iv?.data(using: .utf8)
        return Cryptor.symmetricDecrypt(algorithm: .tripleDES, data: this, key: keyData, iv: ivData)
    }

    func rsaEncrypt(publicKey: String) -> Data? {
        Cryptor.asymmetricEncrypt(data: this, publicKey: publicKey)
    }

    func rsaDecrypt(privateKey: String) -> Data? {
        Cryptor.asymmetricDecrypt(data: this, privateKey: privateKey)
    }

}

// MARK: T

public extension Data {

    init<T>(value: T) {
        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

    mutating func append<T>(value: T) {
        withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) in
            append(UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

}

// MARK: Int

public protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

public extension DataConvertible {

    init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }

    var data: Data {
        return Data.init(value: self)
    }

}

extension Int8 : DataConvertible { }
extension UInt8 : DataConvertible { }
extension Int16 : DataConvertible { }
extension UInt16 : DataConvertible { }
extension Int32 : DataConvertible { }
extension UInt32 : DataConvertible { }
extension Int64 : DataConvertible { }
extension UInt64 : DataConvertible { }
extension Float : DataConvertible { }
extension Double : DataConvertible { }

public extension MBFoundationWrapper where T == Data {

    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            this.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }

    var uint16: UInt16 {
        get {
            let i16array = this.withUnsafeBytes { $0.load(as: UInt16.self) }
            return i16array
        }
    }

    var uint32: UInt32 {
        get {
            let i32array = this.withUnsafeBytes { $0.load(as: UInt32.self) }
            return i32array
        }
    }
}

// MARK: Byte Utils

public extension MBFoundationWrapper where T == Data {

    func reverse() -> Data {
        Data.init(Array(([UInt8](this)).reversed()))
    }

    static func data(from uint8: UInt8) -> Data {
        uint8.data
    }

    static func data(from uint16: UInt16) -> Data {
        uint16.data
    }

    static func data(from uint32: UInt32) -> Data {
        uint32.data
    }

    static func uint8(from data: Data) -> UInt8 {
        data.mb.uint8
    }

    static func uint16(from data: Data) -> UInt16 {
        data.mb.uint16
    }

    static func uint32(from data: Data) -> UInt32 {
        data.mb.uint32
    }

    struct ByteError: Swift.Error {}

    func withUnsafeBytes<ResultType, ContentType>(_ completion: (UnsafePointer<ContentType>) throws -> ResultType) rethrows -> ResultType {
        return try this.withUnsafeBytes {

            // swiftlint:disable:next empty_count
            if let baseAddress = $0.baseAddress, $0.count > 0 {
                return try completion(baseAddress.assumingMemoryBound(to: ContentType.self))
            } else {
                throw ByteError()
            }
        }
    }

}

// MARK: NSData
@objc
public extension NSData {

    // MARK: Hash

    func mb_md2Data() -> NSData? {
        return (self as Data).mb.md2Data() as NSData?
    }

    func mb_md4Data() -> NSData? {
        return (self as Data).mb.md4Data() as NSData?
    }

    func mb_md5Data() -> NSData? {
        return (self as Data).mb.md5Data() as NSData?
    }

    func mb_sha1Data() -> NSData? {
        return (self as Data).mb.sha1Data() as NSData?
    }

    func mb_sha224Data() -> NSData? {
        return (self as Data).mb.sha224Data() as NSData?
    }

    func mb_sha256Data() -> NSData? {
        return (self as Data).mb.sha256Data() as NSData?
    }

    func mb_sha384Data() -> NSData? {
        return (self as Data).mb.sha384Data() as NSData?
    }

    func mb_sha512Data() -> NSData? {
        return (self as Data).mb.sha512Data() as NSData?
    }

    func mb_hmacMD5DataWith(key: NSData) -> NSData? {
        (self as Data).mb.hmacMD5DataWith(key: key as Data) as NSData?
    }

    func mb_hmacSHA1DataWith(key: NSData) -> NSData? {
        (self as Data).mb.hmacSHA1DataWith(key: key as Data) as NSData?
    }

    func mb_hmacSHA224DataWith(key: NSData) -> NSData? {
        (self as Data).mb.hmacSHA224DataWith(key: key as Data) as NSData?
    }

    func mb_hmacSHA256DataWith(key: NSData) -> NSData? {
        (self as Data).mb.hmacSHA256DataWith(key: key as Data) as NSData?
    }

    func mb_hmacSHA384DataWith(key: NSData) -> NSData? {
        (self as Data).mb.hmacSHA384DataWith(key: key as Data) as NSData?
    }

    func mb_hmacSHA512DataWith(key: NSData) -> NSData? {
        (self as Data).mb.hmacSHA512DataWith(key: key as Data) as NSData?
    }

    func mb_crc32String() -> NSString {
        return (self as Data).mb.crc32String() as NSString
    }

    func mb_crc32() -> UInt32 {
        return (self as Data).mb.crc32()
    }

    // MARK: Encode & Decode

    func mb_utf8String() -> NSString {
        return (self as Data).mb.utf8String() as NSString
    }

    func mb_hexString() -> NSString {
        return (self as Data).mb.hexString() as NSString
    }

    class func mb_dataWithHexString(_ string: NSString) -> NSData? {
        Data.mb.dataWithHexString(string as String) as NSData?
    }

    func mb_base64EncodedString() -> NSString {
        return (self as Data).mb.base64EncodedString() as NSString
    }

    class func mb_dataWithBase64EncodedString(_ string: NSString) -> NSData? {
        Data.mb.dataWithBase64EncodedString(string as String) as NSData?
    }

    func mb_jsonValueDecoded() -> Any? {
        return (self as Data).mb.jsonValueDecoded()
    }

    class func mb_jsonDataEncoded(with jsonObject: Any) -> NSData? {
        Data.mb.jsonDataEncoded(with: jsonObject) as NSData?
    }

    // MARK: Inflate & Deflate

    func mb_deflate() -> NSData? {
        return (self as Data).mb.deflate() as NSData?
    }

    func mb_inflate() -> NSData? {
        return (self as Data).mb.inflate() as NSData?
    }

    func mb_zip() -> NSData? {
        (self as Data).mb.zip() as NSData?
    }

    func mb_unzip(skipCheckSumValidation: Bool = true) -> NSData? {
        (self as Data).mb.unzip(skipCheckSumValidation: skipCheckSumValidation) as NSData?
    }

    func mb_gzip() -> NSData? {
        return (self as Data).mb.gzip() as NSData?
    }

    func mb_gunzip() -> NSData? {
        return (self as Data).mb.gunzip() as NSData?
    }

    // MARK: Encrypt & Decrypt

    func mb_aes128Encrypt(key: NSString, iv: NSString? = nil) -> NSData? {
        return (self as Data).mb.aes128Encrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_aes128Decrypt(key: String, iv: String? = nil) -> NSData? {
       return (self as Data).mb.aes128Decrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_aes256Encrypt(key: NSString, iv: NSString? = nil) -> NSData? {
        (self as Data).mb.aes256Encrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_aes256Decrypt(key: String, iv: String? = nil) -> NSData? {
        (self as Data).mb.aes256Decrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_desEncrypt(key: String, iv: String? = nil) -> NSData? {
        (self as Data).mb.desEncrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_desDecrypt(key: String, iv: String? = nil) -> NSData? {
        (self as Data).mb.desDecrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_3desEncrypt(key: String, iv: String? = nil) -> NSData? {
        (self as Data).mb.threeDesEncrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_3desDecrypt(key: String, iv: String? = nil) -> NSData? {
        (self as Data).mb.threeDesDecrypt(key: key as String, iv: iv as String?) as NSData?
    }

    func mb_rsaEncrypt(publicKey: String) -> NSData? {
        (self as Data).mb.rsaEncrypt(publicKey: publicKey as String) as NSData?
    }

    func mb_rsaDecrypt(privateKey: String) -> NSData? {
        (self as Data).mb.rsaDecrypt(privateKey: privateKey as String) as NSData?
    }

    // MARK: Byte Utils

    func mb_reverse() -> NSData {
        (self as Data).mb.reverse() as NSData
    }

    static func mb_dataFrom(uint8: UInt8) -> NSData {
        Data.mb.data(from: uint8) as NSData
    }

    static func mb_dataFrom(uint16: UInt16) -> NSData {
        Data.mb.data(from: uint16) as NSData
    }

    static func mb_dataFrom(uint32: UInt32) -> NSData {
        Data.mb.data(from: uint32) as NSData
    }

    static func mb_uint8From(data: NSData) -> UInt8 {
        Data.mb.uint8(from: data as Data)
    }

    static func mb_uint16From(data: NSData) -> UInt16 {
        Data.mb.uint16(from: data as Data)
    }

    static func mb_uint32From(from data: NSData) -> UInt32 {
        Data.mb.uint32(from: data as Data)
    }
}
