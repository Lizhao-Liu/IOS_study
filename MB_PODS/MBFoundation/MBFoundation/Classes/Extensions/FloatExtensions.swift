// 
//  FloatExtensions.swift
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// MARK: - Properties

public extension Float {
    ///  Int.
    var int: Int {
        return Int(self)
    }

    /// Double.
    var double: Double {
        return Double(self)
    }

    /// CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
