//
//  NibLoadable.swift
//  MBFoundation
//
//  Created by zhouxiang on 2021/8/31.
//  Copyright © 2021年 ymm56.com. All rights reserved.

import UIKit

public protocol NibLoadable {}

public extension NibLoadable where Self: UIView {

    static func load(in bundle: Bundle = Bundle.main, nib name: String? = nil) -> Self {
        let name = name ?? "\(self)"
        guard let view  = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? Self else {
            fatalError("not found nib \(name) in bundle \(bundle)")
        }
        return view
    }

}
