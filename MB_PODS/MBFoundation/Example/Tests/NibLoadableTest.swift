//
//  NibLoadableTest.swift
//  MBFoundation_Example
//
//  Created by 周翔 on 2021/10/12.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import MBFoundation

class NibLoadableTest: XCTestCase {

    func testNotNil()  {
        let view = LoadableNibView.load(in: Bundle.main, nib: nil)
        XCTAssertNotNil(view)
    }
    
    
}
