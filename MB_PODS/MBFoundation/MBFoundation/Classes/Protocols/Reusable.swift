//
//  ReusableTest.swift
//  MBFoundation
//
//  Created by zhouxiang on 2021/8/31.
//  Copyright © 2021年 ymm56.com. All rights reserved.

import UIKit

// swiftlint:disable line_length
public protocol Reusable {

    static var identifier: String { get }

    static var nib: UINib? { get }

}

public extension Reusable {

    static var identifier: String {
        return "\(self)"
    }

    static var nib: UINib? {
        return nil
    }

}

public extension UITableView {

    func register<T: UITableViewCell>(cell: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.identifier)
        } else {
            register(cell, forCellReuseIdentifier: T.identifier)
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(T.identifier) matching type \(T.self).")
        }
        return cell
    }

    func register<T: UITableViewHeaderFooterView>(view: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: T.identifier)
        } else {
            register(view, forHeaderFooterViewReuseIdentifier: T.identifier)
        }
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Failed to dequeue a header/footer with identifier \(T.identifier) matching type \(T.self).")
        }
        return view
    }

}

public extension UICollectionView {

    func register<T: UICollectionViewCell>(cell: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.identifier)
        } else {
            register(cell, forCellWithReuseIdentifier: T.identifier)
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(T.identifier) matching type \(T.self).")
        }
        return cell
    }

    func register<T: UICollectionReusableView>(view: T.Type, ofKind elementKind: String)  where T: Reusable {
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.identifier)
        } else {
            register(view, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.identifier)
        }
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T where T: Reusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a supplementary view with identifier \(T.identifier) matching type \(T.self).")
        }
        return view
    }

}
