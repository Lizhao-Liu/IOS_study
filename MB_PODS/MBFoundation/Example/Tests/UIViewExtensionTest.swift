//
//  UIViewExtensionTest.swift
//  MBFoundation_Tests
//
//  Created by 周翔 on 2021/11/2.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import MBFoundation

class UIViewExtensionTest: XCTestCase {


    func testParentViewController() {
        let viewController = UIViewController()
        XCTAssertNotNil(viewController.view.parentViewController)
        XCTAssertEqual(viewController.view.parentViewController, viewController)

        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = UIView(frame: frame)
        XCTAssertNil(view.parentViewController)
    }

    
    
    func testFirstResponder() {
        // When there's no firstResponder
        XCTAssertNil(UIView().firstResponder())

        let window = UIWindow()

        // When self is firstResponder
        let txtView = UITextField(frame: CGRect.zero)
        window.addSubview(txtView)
        txtView.becomeFirstResponder()
        XCTAssert(txtView.firstResponder() === txtView)

        // When a subview is firstResponder
        let superView = UIView()
        window.addSubview(superView)
        let subView = UITextField(frame: CGRect.zero)
        superView.addSubview(subView)
        subView.becomeFirstResponder()
        XCTAssert(superView.firstResponder() === subView)

        // When you have to find recursively
        XCTAssert(window.firstResponder() === subView)
    }


}
