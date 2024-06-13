//
//  MBShipperXXXAdapterUnique.swift
//  YMMModuleLib_Example
//
//  Created by Lizhao on 2023/5/4.
//  Copyright © 2023 knop. All rights reserved.
//

import Foundation

@objcMembers
class MBShipperXXXAdapterUnique : NSObject, MBShipperXXXAdapterProtocol{
    func runShipper() {
        print("run unique method in shipper target")
        MBAdapter.shared.getWeakTarget(adapter: self)?.targetMethodToRun()
        
    }
    
    override required init() { super.init() }
}
