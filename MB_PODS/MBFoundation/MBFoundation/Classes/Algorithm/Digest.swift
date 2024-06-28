//
//  Digest.swift
//  MBFoundation
//
//  Created by rensihao on 2021/1/28.
//
//  Note20220314: 未在宿主使用，使用前先测试

import Foundation
import CommonCrypto

// swiftlint:disable switch_case_alignment
// swiftlint:disable identifier_name
public enum Digest {

    public enum Format {
        case hex
        case base64
    }

    public enum HashMethod {
        case md2
        case md4
        case md5
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512

        var length: Int32 {
            switch self {
                case .md2: return CC_MD2_DIGEST_LENGTH
                case .md4: return CC_MD4_DIGEST_LENGTH
                case .md5: return CC_MD5_DIGEST_LENGTH
                case .sha1: return CC_SHA1_DIGEST_LENGTH
                case .sha224: return CC_SHA224_DIGEST_LENGTH
                case .sha256: return CC_SHA256_DIGEST_LENGTH
                case .sha384: return CC_SHA384_DIGEST_LENGTH
                case .sha512: return CC_SHA512_DIGEST_LENGTH
            }
        }

        internal func hash(data: UnsafeRawPointer, length: CC_LONG,
                           md: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> {
            switch self {
                case .md2: return CC_MD2(data, length, md)
                case .md4: return CC_MD4(data, length, md)
                case .md5: return CC_MD5(data, length, md)
                case .sha1: return CC_SHA1(data, length, md)
                case .sha224: return CC_SHA224(data, length, md)
                case .sha256: return CC_SHA256(data, length, md)
                case .sha384: return CC_SHA384(data, length, md)
                case .sha512: return CC_SHA512(data, length, md)
            }
        }
    }

}

public extension Data {

    func digestData(using method: Digest.HashMethod) -> Data? {
        var data = Data(count: Int(method.length))
        _ = data.withUnsafeMutableBytes { digestBytes in
            self.withUnsafeBytes { messageBytes in
                method.hash(
                    data: messageBytes.baseAddress!,
                    length: CC_LONG(self.count),
                    md: digestBytes.bindMemory(to: UInt8.self).baseAddress!
                )
            }
        }
        return data
    }

    func digestString(using method: Digest.HashMethod, format: Digest.Format = .hex) -> String? {
        guard let data = self.digestData(using: method) else { return nil }
        switch format {
            case .hex: return data.map { String(format: "%02hhx", $0) }.joined()
            case .base64: return data.base64EncodedString()
        }
    }

}

public extension String {

    func digestData(using method: Digest.HashMethod) -> Data? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.digestData(using: method)
    }

    func digestString(using method: Digest.HashMethod, format: Digest.Format = .hex) -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        return data.digestString(using: method, format: format)
    }

}
