// 
//  IntExtensions.swift
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// MARK: - Properties

public extension Int {
    /// CountableRange 0..<Int.
    var countableRange: CountableRange<Int> {
        return 0..<self
    }

    /// Radian value of degree input.
    var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }

    /// Degree value of radian input.
    var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }

    /// UInt.
    var uInt: UInt {
        return UInt(self)
    }

    /// Double.
    var double: Double {
        return Double(self)
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
