//
//  MBAPMDemo.swift
//  MBAPMLib_Example
//
//  Created by xp on 2021/8/3.
//  Copyright © 2021 seal. All rights reserved.
//

import Foundation

import UIKit

open class TestCrashViewController: UIViewController {
    
    fileprivate lazy var testDict: Dictionary<String, Any> = {
        var dic:Dictionary = Dictionary<String, Any>()
        dic["test_key"] = "test_value"
        return dic
    }()
    
    fileprivate lazy var zombieObjectCrashBtn: UIButton = {
        let crashBtn:UIButton = UIButton();
        crashBtn.setTitle("ZombieObjCrash", for: UIControl.State.normal)
        crashBtn.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        crashBtn.addTarget(self, action: #selector(zombieCrashOccured), for: UIControl.Event.touchUpInside)
        crashBtn.backgroundColor = UIColor.blue
        return crashBtn
    }()
    
    
    @objc fileprivate func zombieCrashOccured() {
        NSLog("zombieCrashOccured")
        var vc:MBAPMPageRenderTestVC = MBAPMPageRenderTestVC()
//        for _ in 0...1000 {
//            DispatchQueue.global().async {
//                NSLog(self.testDict["test_key"] as! String)
//            }
//        }
//        for _ in 0...1000 {
//            DispatchQueue.global().async {
//                NSLog(self.testDict["test_key"] as! String)
//            }
//        }
        
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "崩溃监控"
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.tertiarySystemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        self.view .addSubview(zombieObjectCrashBtn)
    }
    
    
}
