// 
//  DoubleExtensions.swift
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// MARK: - Properties

public extension Double {
    /// Int.
    var int: Int {
        return Int(self)
    }

    /// Float.
    var float: Float {
        return Float(self)
    }

    /// CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
