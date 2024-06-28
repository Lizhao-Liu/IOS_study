// 
//  NullExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

private let nullObjects: [AnyObject] = [NSString(), NSNumber(0), NSDictionary(), NSArray()]

@objc
public extension NSNull {

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        for object in nullObjects {
            if object.responds(to: aSelector) == true {
//                assert(false, "you must check whether it's the excepeted type")
                return object
            }
        }
        return super.forwardingTarget(for: aSelector)
    }

}
