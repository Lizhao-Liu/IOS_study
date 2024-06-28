//
//  MB7ZipUtil.swift
//  MBFoundation
//
//  Created by xp on 2024/1/4.
//

import Foundation
import PLzmaSDK

/// Exception error codes.
@objc public enum MB7ZipResultCode: UInt8 {
    case success = 0

    case fileNotExist = 1

    case invalidArguments = 2

    case notEnoughMemory = 3

    case io = 4
    
    case openFail = 5

    case `internal` = 6

    case unknown = 7
}

@objcMembers
public class MB7ZipResult: NSObject {
    public var resultCode: MB7ZipResultCode
    public var message: String?

    public init(resultCode: MB7ZipResultCode, message: String? = nil) {
        self.resultCode = resultCode
        self.message = message
    }
}

@objc public protocol MB7ZipDelegate {
    @objc optional func compressProgress(path:String, progress: Double)

    @objc optional func uncompressProgress(path: String, progress: Double)
}

@objcMembers
public class MB7ZipUtil: NSObject, EncoderDelegate, DecoderDelegate {

    public weak var delegate: MB7ZipDelegate?

    @objc
    /// 7z file uncompress
    /// if compressed file isn't exist, return fileNotExist error code
    /// if destination file directory is exist, but it is a file, return fileNotExist error code
    /// if destination file directory isn't exist, create the destination file directory
    /// - Parameters:
    ///   - compressedFilePath: file path of the compressed file
    ///   - destinationDir: the file directory where the compressed file is extracted to
    /// - Returns: uncompress result, resultCode is .success when comress successfully, detail information will be shown in message property
    public dynamic func uncompress(compressedFilePath:String, destinationDir: String) -> MB7ZipResult {
        let uncompressResult: MB7ZipResult = MB7ZipResult(resultCode: .success)
        var uncompressCostTime: UInt64 = 0
        let startTime:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
        do {
            let compressedFileExist: Bool = FileManager.default.fileExists(atPath: compressedFilePath)
            if (!compressedFileExist) {
                uncompressResult.resultCode = .fileNotExist
                uncompressResult.message = "compressed file isn't exist"
                MBFoundationExceptionUtil.shared.infoLog("compressed file isn't exist, compressedFilePath = \(compressedFilePath)", subModule: "7zip", tag: "uncompress")
                return uncompressResult
            }
            var isDir:ObjCBool = false
            let destinationDirExist: Bool = FileManager.default.fileExists(atPath: destinationDir, isDirectory: &isDir)
            if (destinationDirExist && !isDir.boolValue) {
                uncompressResult.resultCode = .fileNotExist
                uncompressResult.message = "uncompress destination directory isn't exist or a same name file is exist"
                MBFoundationExceptionUtil.shared.infoLog(" destination directory isn't exist or a same name file is exist, compressedFilePath = \(compressedFilePath) , destination directory = \(destinationDir)", subModule: "7zip", tag: "uncompress")
                return uncompressResult
            }
            if (!destinationDirExist) {
                MBFoundationExceptionUtil.shared.infoLog("destination directory isn't exist, create destination, compressedFilePath = \(compressedFilePath) directory = \(destinationDir)", subModule: "7zip", tag: "uncompress")
                try FileManager.default.createDirectory(atPath: destinationDir, withIntermediateDirectories: true)
            }
            let sourcefileAtrritures: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: compressedFilePath)
            let sourceFileSize:Int64 = sourcefileAtrritures[FileAttributeKey.size] as? Int64 ?? 0
            MBFoundationExceptionUtil.shared.infoLog(" sourceFileSize = \(sourceFileSize), compressedFilePath = \(compressedFilePath)", subModule: "7zip", tag: "uncompress")
            let archivePath = try Path(compressedFilePath)
            let archivePathInStream = try InStream(path: archivePath)
            let decoder = try Decoder(stream: archivePathInStream, fileType: .sevenZ, delegate: self)
            let openResult: Bool = try decoder.open()
            if (!openResult) {
                uncompressResult.resultCode = .openFail;
                uncompressResult.message = "decoder open failed"
                MBFoundationExceptionUtil.shared.errorLog("compressedFilePath = \(compressedFilePath) decoder open failed", subModule: "7zip", tag: "uncompress")
            } else {
                let allArchiveItems = try decoder.items()
                let numberOfArchiveItems = try decoder.count()
                var extractedTotalSize: UInt64 = 0
                for itemIndex in 0..<numberOfArchiveItems {
                    let item = try allArchiveItems.item(at: itemIndex)
                    extractedTotalSize += item.size
                    let itemPath: String = try item.path().description
                    MBFoundationExceptionUtil.shared.infoLog("compressedFilePath = \(compressedFilePath) itemPath = \(itemPath) itemSize = \(item.size)", subModule: "7zip", tag: "uncompress")
                }
                let extractResult: Bool = try decoder.extract(items: allArchiveItems, to: Path(destinationDir))
                if (extractResult) {
                    let extractEndTime:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
                    uncompressCostTime = extractEndTime - startTime
                    MBFoundationExceptionUtil.shared.infoLog("compressedFilePath = \(compressedFilePath) uncomress success extractedFileSize = \(extractedTotalSize)   costTime = \(uncompressCostTime)", subModule: "7zip", tag: "uncompress")
                } else {
                    uncompressResult.resultCode = .unknown
                    uncompressResult.message = "decoder extract failed"
                    MBFoundationExceptionUtil.shared.errorLog("compressedFilePath = \(compressedFilePath) decoder extract failed", subModule: "7zip", tag: "uncompress")
                }
            }
        } catch let exception as Exception {
            MBFoundationExceptionUtil.shared.errorLog("uncompress exception: \(exception)", subModule: "7zip", tag: "uncompress")
            let errorCode:MB7ZipResultCode = self.transferErrorCode(plzmaErrorCode: exception.code.type)
            uncompressResult.resultCode = errorCode
            uncompressResult.message = "\(exception)"
        } catch {
            MBFoundationExceptionUtil.shared.errorLog("uncompress error: \(error.localizedDescription)", subModule: "7zip", tag: "uncompress")
            uncompressResult.resultCode = .io
            uncompressResult.message = "\(error.localizedDescription)"
        }
        let endTime:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
        uncompressCostTime = endTime - startTime
        MBFoundationExceptionUtil.shared.reportMetric(metricName: "app.foundation.7z", mainValue: uncompressCostTime, sectionValues: [:], tags: ["action":"uncompress", "success":"\(uncompressResult.resultCode == .success ? 1: 0)", "code":"\(uncompressResult.resultCode.rawValue)"], attrs: ["compressedFilepath" : compressedFilePath, "destinationDir" : destinationDir])
        return uncompressResult
    }

    @objc
    /// 7z file compress by LZMA2 algorithm，compress level is 3
    /// if source file isn't exist, return fileNotExist error code
    /// if output file is exist, remove the output file
    /// log will be exported by logDelegate of MBFoundationExportUtil
    /// - Parameters:
    ///   - sourcefilePath: file path which is to be compressed
    ///   - outputFilePath: file path of the destination compressed file
    /// - Returns: compress result, resultCode is .success when comress successfully, detail information will be shown in message property
    public dynamic func compress(sourcefilePath: String, outputFilePath: String) -> MB7ZipResult {
        var compressCostTime: UInt64 = 0
        var compressRate: UInt64 = 0
        let startTime:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
        let compressResult: MB7ZipResult = MB7ZipResult(resultCode: .success)
        do {
            let sourceFileExist: Bool = FileManager.default.fileExists(atPath: sourcefilePath)
            if (!sourceFileExist) {
                compressResult.resultCode = .fileNotExist
                compressResult.message = "compress source file isn't exist"
                MBFoundationExceptionUtil.shared.errorLog("source file isn't exist, sourceFilePath = \(sourcefilePath)", subModule: "7zip", tag: "compress")
                return compressResult
            }
            let destinationFileExist: Bool = FileManager.default.fileExists(atPath: outputFilePath)
            if (destinationFileExist) {
                MBFoundationExceptionUtil.shared.infoLog("outputFile file is exist, sourceFilePath = \(sourcefilePath), outputFilePath = \(outputFilePath)", subModule: "7zip", tag: "compress")
                try FileManager.default.removeItem(atPath: outputFilePath)
            }
            let archivePath = try Path(outputFilePath)
            let sourcefileAtrritures: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: sourcefilePath)
            let sourceFileSize:Int64 = sourcefileAtrritures[FileAttributeKey.size] as? Int64 ?? 0
            let archivePathOutStream = try OutStream(path: archivePath)
            let encoder = try Encoder(stream: archivePathOutStream, fileType: .sevenZ, method: .LZMA2, delegate: self)
            try encoder.setCompressionLevel(3)
            let itemStream = try InStream(path: Path(sourcefilePath))
            let fileUrl = URL(fileURLWithPath: sourcefilePath)
            let fileName = fileUrl.lastPathComponent
            try encoder.add(stream: itemStream, archivePath: Path(fileName))
            let openResult: Bool = try encoder.open()
            if (!openResult) {
                compressResult.resultCode = .openFail;
                compressResult.message = "encoder open failed"
                MBFoundationExceptionUtil.shared.errorLog("encoder open failed, sourceFilePath = \(sourcefilePath)", subModule: "7zip", tag: "compress")
            } else {
                let compressed = try encoder.compress()
                if (compressed) {
                    let outputfileAtrritures: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: outputFilePath)
                    let outputFileSize:Int64 = outputfileAtrritures[FileAttributeKey.size] as? Int64 ?? 0
                    if (sourceFileSize > 0 && sourceFileSize >= outputFileSize) {
                        compressRate = (UInt64)((Double(sourceFileSize - outputFileSize)/Double(sourceFileSize)) * 100)
                    }
                    let compressEndTime:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
                    compressCostTime = compressEndTime - startTime
                    MBFoundationExceptionUtil.shared.infoLog("compress success sourceFileSize = \(sourceFileSize) compressedFileSize = \(outputFileSize) compressRate = \(compressRate) costTime = \(compressCostTime)")
                } else {
                    compressResult.resultCode = .unknown;
                    compressResult.message = "encoder compress failed"
                    MBFoundationExceptionUtil.shared.errorLog("encoder compress failed, sourceFilePath = \(sourcefilePath)", subModule: "7zip", tag: "compress")
                }
            }
            
        } catch let exception as Exception {
            MBFoundationExceptionUtil.shared.errorLog("compress exception: \(exception)", subModule: "7zip", tag: "uncompress")
            let errorCode:MB7ZipResultCode = self.transferErrorCode(plzmaErrorCode: exception.code.type)
            compressResult.resultCode = errorCode
            compressResult.message = "\(exception)"
        } catch {
            MBFoundationExceptionUtil.shared.errorLog("compress error: \(error.localizedDescription)", subModule: "7zip", tag: "uncompress")
            compressResult.resultCode = .io
            compressResult.message = "\(error.localizedDescription)"
        }
        let endTime:UInt64 = UInt64(Date().timeIntervalSince1970 * 1000)
        compressCostTime = endTime - startTime
        MBFoundationExceptionUtil.shared.reportMetric(metricName: "app.foundation.7z", mainValue: compressCostTime, sectionValues: ["compressRate": compressRate], tags: ["action":"compress", "success":"\(compressResult.resultCode == .success ? 1:0)", "code":"\(compressResult.resultCode.rawValue)"], attrs: ["sourcefilePath" : sourcefilePath, "outputFilePath" : outputFilePath])
        return compressResult
    }

    public func encoder(encoder: Encoder, path: String, progress: Double) {
        delegate?.compressProgress?(path: path, progress: progress)
    }

    public func decoder(decoder: Decoder, path: String, progress: Double) {
        delegate?.uncompressProgress?(path: path, progress: progress)
    }

// MARK: transfer PLzmaSDK errorCode to MB7ZipResultCode

    @objc
    public dynamic func transferErrorCode(plzmaErrorCode: plzma_error_code) -> MB7ZipResultCode {
        var resultCode: MB7ZipResultCode = .unknown
        switch plzmaErrorCode {
        case plzma_error_code_unknown:
            resultCode = .unknown
        case plzma_error_code_invalid_arguments:
            resultCode = .invalidArguments
        case plzma_error_code_io:
            resultCode = .io
        case plzma_error_code_not_enough_memory:
            resultCode = .notEnoughMemory
        case plzma_error_code_internal:
            resultCode = .internal
        default:
            resultCode = .unknown
        }
        return resultCode
    }

}
