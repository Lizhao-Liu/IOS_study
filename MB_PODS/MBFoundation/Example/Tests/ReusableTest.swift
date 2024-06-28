//
//  ReusableTest.swift
//  MBFoundation_Tests
//
//  Created by 周翔 on 2021/9/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import MBFoundation

extension UITableViewCell: Reusable {
    
}

extension UICollectionViewCell: Reusable {
    
}

class ReusableTest: XCTestCase {

    let tableView = UITableView()
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())


    func testTableDequeueReusableCellWithClassForIndexPath() {
        tableView.register(cell: UITableViewCell.self)
        let indexPath = tableView.indexPathForLastRow!
        let cell = tableView.dequeueReusableCell(for: indexPath)
        XCTAssertNotNil(cell)
    }
    
    func testCollectionDequeueReusableCellWithClassForIndexPath() {
        collectionView.register(cell: UICollectionViewCell.self)
        let indexPath = collectionView.indexPathForLastItem!
        let cell = collectionView.dequeueReusableCell(for: indexPath)
        XCTAssertNotNil(cell)
    }

}

