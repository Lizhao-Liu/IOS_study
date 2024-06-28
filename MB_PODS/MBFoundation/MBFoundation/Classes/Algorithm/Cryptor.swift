//
//  Cryptor.swift
//  MBFoundation
//
//  Created by rensihao on 2021/1/30.
//
//  Note20220314: 未在宿主使用，使用前先测试

import Foundation
import CommonCrypto
import Security

// swiftlint:disable all
public enum CryptorAligorithm {

    public enum Symmetric {
        case aes_128
        case aes_192
        case aes_256
        case des
        case des40
        case tripleDES
        case rc4_40
        case rc4_128
        case rc2_40
        case rc2_128
        case cast
        case blowfish
    }

    public enum Asymmetric {
        case rsa
    }
}

public extension CryptorAligorithm.Symmetric {

    var algorithm: CCAlgorithm {
        switch self {
            case .aes_128:   return CCAlgorithm(kCCAlgorithmAES)
            case .aes_192:   return CCAlgorithm(kCCAlgorithmAES)
            case .aes_256:   return CCAlgorithm(kCCAlgorithmAES)
            case .des:       return CCAlgorithm(kCCAlgorithmDES)
            case .des40:     return CCAlgorithm(kCCAlgorithmDES)
            case .tripleDES: return CCAlgorithm(kCCAlgorithm3DES)
            case .rc4_40:    return CCAlgorithm(kCCAlgorithmRC4)
            case .rc4_128:   return CCAlgorithm(kCCAlgorithmRC4)
            case .rc2_40:    return CCAlgorithm(kCCAlgorithmRC2)
            case .rc2_128:   return CCAlgorithm(kCCAlgorithmRC2)
            case .cast:      return CCAlgorithm(kCCAlgorithmCAST)
            case .blowfish:  return CCAlgorithm(kCCAlgorithmBlowfish)
        }
    }

    var keySize: Int {
        switch self {
            case .aes_128:   return kCCKeySizeAES128
            case .aes_192:   return kCCKeySizeAES192
            case .aes_256:   return kCCKeySizeAES256
            case .des:       return kCCKeySizeDES
            case .des40:     return 5
            case .tripleDES: return kCCKeySize3DES
            case .rc4_40:    return 5
            case .rc4_128:   return 16
            case .rc2_40:    return 5
            case .rc2_128:   return kCCKeySizeMaxRC2
            case .cast:      return kCCKeySizeMaxCAST
            case .blowfish:  return kCCKeySizeMaxBlowfish
        }
    }

    var blockSize: Int {
        switch self {
            case .aes_128:   return kCCBlockSizeAES128
            case .aes_192:   return kCCBlockSizeAES128
            case .aes_256:   return kCCBlockSizeAES128
            case .des:       return kCCBlockSizeDES
            case .des40:     return kCCBlockSizeDES
            case .tripleDES: return kCCBlockSize3DES
            case .rc4_40:    return 0
            case .rc4_128:   return 0
            case .rc2_40:    return kCCBlockSizeRC2
            case .rc2_128:   return kCCBlockSizeRC2
            case .cast:      return kCCBlockSizeCAST
            case .blowfish:  return kCCBlockSizeBlowfish
        }
    }
}

public extension CryptorAligorithm.Asymmetric {

}

public struct Cryptor {

    static func symmetricEncrypt(algorithm: CryptorAligorithm.Symmetric, data: Data, key: Data, iv: Data? = nil) -> Data? {
        symmetricCrypt(operation: CCOperation(kCCEncrypt), algorithm: algorithm, data: data, key: key, iv: iv)
    }

    static func symmetricDecrypt(algorithm: CryptorAligorithm.Symmetric, data: Data, key: Data, iv: Data? = nil) -> Data? {
        symmetricCrypt(operation: CCOperation(kCCDecrypt), algorithm: algorithm, data: data, key: key, iv: iv)
    }

    private static func symmetricCrypt(operation: CCOperation, algorithm: CryptorAligorithm.Symmetric, data: Data, key: Data, iv: Data?) -> Data? {
        if iv != nil && iv?.count != algorithm.blockSize {
            return nil
        }

        if operation == CCOperation(kCCDecrypt) && algorithm.blockSize != 0 && data.count % algorithm.blockSize != 0 {
            return nil
        }

        let ccAlgorithm: CCAlgorithm = algorithm.algorithm

        let options = (((iv == nil) ? kCCOptionECBMode : 0) | kCCOptionPKCS7Padding)
        let ccOptions: CCOptions = CCOptions(options)

        let keyBytes: UnsafePointer<UInt8>? = UnsafePointer<UInt8>.mb_init(data: key)
        let keySize = algorithm.keySize

        let ivBytes: UnsafePointer<UInt8>? = UnsafePointer<UInt8>.mb_init(data: iv)

        let dataInBytes: UnsafePointer<UInt8>? = UnsafePointer<UInt8>.mb_init(data: data)
        let dataInLength = data.count

        let dataOutLength = dataInLength + algorithm.blockSize
        var dataOut = Data(count: dataOutLength)
        let dataOutBytes: UnsafeMutablePointer<UInt8>? = UnsafeMutablePointer<UInt8>.mb_init(data: &dataOut)
        var size = 0

        let status = CCCrypt(
            operation,
            ccAlgorithm,
            ccOptions,
            keyBytes, keySize,
            ivBytes,
            dataInBytes, dataInLength,
            dataOutBytes, dataOutLength, &size
        )

        if status != CCCryptorStatus(kCCSuccess) {
            debugPrint("\(operation == CCOperation(kCCEncrypt) ? "encrypt": "decrypt") failed: \(status)")
            return nil
        }

        dataOut.count = size
        return dataOut
    }

    static func asymmetricEncrypt(_ algorithm: CryptorAligorithm.Asymmetric? = .rsa, data: Data, publicKey: String) -> Data? {
        guard data.count > 0 && !publicKey.isEmpty else { return nil }
        let data = data as NSData

        if #available(iOS 10.0, *) {
            var error: Unmanaged<CFError>?
            guard let resData = SecKeyCreateEncryptedData(publicKey as! SecKey, SecKeyAlgorithm.rsaEncryptionPKCS1, data as CFData, &error) as Data? else {
                debugPrint("encrypt failed: \(String(describing: error?.takeUnretainedValue().localizedDescription))")
                return nil
            }
            return resData
        } else {
            let blockLength = SecKeyGetBlockSize(publicKey as! SecKey)
            var outBuf = [UInt8](repeating: 0, count: blockLength)
            var outBufLen: Int = blockLength

            var index = 0
            let totalLen = data.count

            let resData = NSMutableData()

            while index < totalLen {
                var curDataLen = totalLen - index
                if curDataLen > blockLength - 11 {
                    curDataLen = blockLength - 11
                }

                let curData = data.subdata(with: NSRange(location: index, length: curDataLen)) as NSData

                let status: OSStatus = SecKeyEncrypt(publicKey as! SecKey, SecPadding.PKCS1, curData.bytes.assumingMemoryBound(to: UInt8.self), curData.length, &outBuf, &outBufLen)

                if status == noErr {
                    resData.append(outBuf, length: outBufLen)
                } else {
                    debugPrint("encrypt failed: \(status))")
                    return nil
                }

                index += curDataLen
            }

            return resData as Data
        }
    }

    static func asymmetricDecrypt(_ algorithm: CryptorAligorithm.Asymmetric? = .rsa, data: Data, privateKey: String) -> Data? {
        guard data.count != 0 && !privateKey.isEmpty else { return nil }
        let data = data as NSData

        if #available(iOS 10.0, *) {
            var error: Unmanaged<CFError>?
            guard let resData = SecKeyCreateDecryptedData(privateKey as! SecKey, SecKeyAlgorithm.rsaEncryptionPKCS1, data as CFData, &error) as Data? else {
                debugPrint("decrypt failed: \(String(describing: error?.takeUnretainedValue().localizedDescription))")
                return nil
            }
            return resData
        } else {
            let blockLen = SecKeyGetBlockSize(privateKey as! SecKey)
            let outBuf = UnsafeMutablePointer<UInt8>.allocate(capacity: blockLen)
            defer {
                outBuf.deallocate()
            }

            var outBufLen: Int = blockLen

            var index = 0
            let totalLen = data.count

            let resData = NSMutableData()

            while index < totalLen {
                var curDataLen = totalLen - index
                if curDataLen  > blockLen {
                    curDataLen = blockLen
                }

                let curData = data.subdata(with: NSRange(location: index, length: index + curDataLen))

                var status: OSStatus = noErr

                if Data.mb_nilBaseAddress(curData) { return nil }
                curData.withUnsafeBytes {
                    let bytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    status = SecKeyDecrypt(privateKey as! SecKey, SecPadding.PKCS1, bytes, curData.count, outBuf, &outBufLen)
                }
                if status == noErr {
                    resData.append(outBuf, length: outBufLen)
                } else {
                    debugPrint("decrypt failed: \(status))")
                    return nil
                }

                index += curDataLen
            }

            return resData as Data?
        }
    }
}

extension UnsafePointer {
    static func mb_init<Pointee>(data: Data?) -> UnsafePointer<Pointee>? {
        guard let data = data else { return nil }

        let keyBytes: UnsafePointer<Pointee>? = data.withUnsafeBytes {
            if let baseAddress = $0.baseAddress {
                return baseAddress.assumingMemoryBound(to: Pointee.self)
            } else {
                return nil
            }
        }
       return keyBytes
   }
}

extension UnsafeMutablePointer {
    static func mb_unsafeMutablePointer<Pointee>(_ data: inout Data?) -> UnsafeMutablePointer<Pointee>? {
        guard data != nil else { return nil }

        return mb_init(data: &data!)
    }

    static func mb_init<Pointee>(data: inout Data) -> UnsafeMutablePointer<Pointee>? {
        let keyBytes: UnsafeMutablePointer<Pointee>? = data.withUnsafeMutableBytes {
            if let baseAddress = $0.baseAddress {
                return baseAddress.assumingMemoryBound(to: Pointee.self)
            } else {
                return nil
            }
        }
        return keyBytes
    }
}
