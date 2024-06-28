// 
//  SortDescriptorExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

@objc
public extension NSSortDescriptor {

    static func mb_ascDescriptors(key: NSString) -> NSArray {
        NSArray(object: NSSortDescriptor(key: key as String, ascending: true))
    }

    static func mb_descDescriptors(key: NSString) -> NSArray {
        NSArray(object: NSSortDescriptor(key: key as String, ascending: false))
    }

    static func mb_ascendingUpdateDescriptors() -> NSArray {
        mb_ascDescriptors(key: "updateTime")
    }

    static func mb_descendingUpdateDescriptors() -> NSArray {
        mb_descDescriptors(key: "updateTime")
    }

    static func mb_ascendingCreateDescriptors() -> NSArray {
        mb_ascDescriptors(key: "createTime")
    }

    static func mb_descendingCreateDescriptors() -> NSArray {
        mb_descDescriptors(key: "createTime")
    }
}
