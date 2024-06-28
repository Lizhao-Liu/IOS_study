//
//  CollectionExtensions.swift
//  MBFoundation
//
//  Created by 周翔 on 2021/7/6.
//

import Foundation

// MARK: - Properties

public extension Collection {

    /// 过滤空值
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}

// MARK: - subscript

public extension Collection {

    ///  Safe protects the array from out of bounds by use of optional.
    ///
    ///        let arr = [1, 2, 3, 4, 5]
    ///        arr[safe: 1] -> 2
    ///        arr[safe: 10] -> nil
    ///
    /// - Parameter index: index of element to access element.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
