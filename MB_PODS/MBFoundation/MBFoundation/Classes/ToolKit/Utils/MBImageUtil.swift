//
//  MBImageUtil.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/20.
//

import UIKit

// swiftlint:disable line_length
@objc open class MBImageUtil: NSObject {
    /* 根据图片data,获取图片
     * prama: imageData: 图片data
     * return NSDictionary 图片元数据
     */
    @objc public class func metadataFromImageData(_ imageData : Data) -> [String: Any]? {
        if let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil),
        let metaData = imageProperties as? [String : Any] {
            return metaData
        }
        return nil
    }

    /* 将新的exif写入图片data
     * prama:exif:图片的exif信息，需要写入的exif信息
     *       destData:需要更新的图片data
     * return 写入exif之后的图片data
     */
    @objc public class func writeOriImageInfo(_ exifDic : [String : Any]?, toReturnData destData : Data) -> Data? {
        guard let exifDic = exifDic, let toRetrunImageRef = CGImageSourceCreateWithData(destData as CFData, nil), let toReturnImageProperty = CGImageSourceCopyPropertiesAtIndex(toRetrunImageRef, 0, nil) as NSDictionary? else { return nil
        }
        let tempProperty = NSMutableDictionary.init(dictionary: toReturnImageProperty)
        tempProperty.setValue(exifDic, forKey: kCGImagePropertyExifDictionary as String)

        let newImageData = NSMutableData.init()
        guard let UTI = CGImageSourceGetType(toRetrunImageRef), let destination = CGImageDestinationCreateWithData(newImageData as CFMutableData, UTI, 1, nil) else { return nil }
        // add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
        CGImageDestinationAddImageFromSource(destination, toRetrunImageRef, 0, tempProperty as CFDictionary)
        CGImageDestinationFinalize(destination)

        if newImageData.length > 0 {
            return newImageData as Data
        }
        return destData
    }
}
