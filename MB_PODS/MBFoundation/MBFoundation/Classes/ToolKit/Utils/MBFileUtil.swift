//
//  MBFileUtil.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/20.
//

import UIKit
// swiftlint:disable line_length
@objc open class MBFileUtil: NSObject {

    /**
     *  指定路径文件是否存在
     *
     *  @param filePath 文件路径
     *
     *  @return 文件是否存在
     */
    @objc public class func fileExists(_ filePath : String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    /**
     *  获取指定文件字节数
     *
     *  @param filePath 指定文件路径
     *
     *  @return 文件字节数
     */
    @objc public class func fileSize(_ filePath : String) -> UInt64 {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath),
           let fileInfo = try? fileManager.attributesOfItem(atPath: filePath),
           let fileSize = fileInfo[FileAttributeKey.size] as? NSNumber {
            return fileSize.uint64Value

        } else {
            return 0
        }
    }

    /**
     *  根据制定目录类型／目录名称创建目录
     *
     *  @param directory     目录类型
     *  @param directoryName 目录名称
     *
     *  @return 目录路径
     */
    @objc public class func createDirectory(_ directory : FileManager.SearchPathDirectory, directoryName : String) -> URL? {
        let fileManager = FileManager.default
        if let documentURL = fileManager.urls(for: directory, in: .userDomainMask).first {
            var storeURL : URL? = documentURL.appendingPathComponent("\(directoryName)/")
            if let url = storeURL, !fileManager.fileExists(atPath: url.path) {
                do {
                    try fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    storeURL = nil
                }
            }
            return storeURL
        }
        return nil
    }

    /**
     *  移除指定路径的文件元素
     *
     *  @param rootDir     目录路径
     *
     *  @return 是否移除成功
     */
    @objc public class func removeFileItem(_ rootDir : URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: rootDir)
            return true
        } catch {
            return false
        }
    }
    /**
     *  拷贝指定路径的文件元素
     *
     *  @param srcURL 原路径
     *  @param dstURL 目标路径
     *
     *  @return 是否拷贝成功
     */
    @objc public class func copyFileItem(_ srcURL : URL, _ dstURL : URL) -> Bool {
        do {
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
            return true
        } catch {
            return false
        }
    }

    /**
     *  移动指定路径的文件元素
     *
     *  @param srcURL 原路径
     *  @param dstURL 目标路径
     *
     *  @return 是否移动成功
     */
    @objc public class func moveFileItem(_ srcURL : URL, _ dstURL : URL) -> Bool {
        do {
            try FileManager.default.moveItem(at: srcURL, to: dstURL)
            return true
        } catch {
            return false
        }
    }

    /**
     *  按时间排序文件
     *
     *  @param path 文件夹路径
     *
     *  @return 排序后的文件array
     */
    @objc public class func sortByDateInPath(_ path : String) -> NSArray? {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            var filesAndProperties = [String : Date]()
            files.forEach { onePath in
                if let properties = try? FileManager.default.attributesOfItem(atPath: path+"/\(onePath)") {
                    if let fileDate = properties[FileAttributeKey.modificationDate] as? Date {
                        filesAndProperties[onePath] = fileDate
                    }
                }
            }
            let arr = filesAndProperties.sorted(by: <).compactMap({ return $0.key })
            return arr as NSArray
        } catch {
            return nil
        }

    }

    /**
     *  获取Document路径
     *
     *  @return document路径
     */
    @objc public class func documentPath() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.last
    }
    /**
     *  获取Cache路径
     *
     *  @return cache路径
     */
    @objc public class func cachePath() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return paths.last
    }

}

extension MBFileUtil {
    @objc class open func md5String(atPath path: String) -> String? {
        return MBFileUtil_md5.md5String(atPath: path)
    }
}
