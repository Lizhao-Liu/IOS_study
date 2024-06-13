//
//  MBXXXViewControllerSwift.swift
//  YMMModuleLib_Example
//
//  Created by Lizhao on 2023/5/4.
//  Copyright © 2023 knop. All rights reserved.
//

import UIKit
import YMMModuleLib


class MBXXXViewControllerSwift: UIViewController, MBXXXViewControllerProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adapter在shipper宿主下返回实例，并调用对应独有runShipper方法。其他宿主下返回空值，即不会调用方法
        MBAdapter.shared.adapter(of: MBShipperXXXAdapterProtocol.self, from: nil, target: self)?.runShipper()
    }

}
