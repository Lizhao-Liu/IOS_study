//
//  MBAPMDebugCrashViewController.swift
//  MBAPMDebug
//
//  Created by xp on 2022/10/25.
//

import UIKit
import MBLogLib

@objc
open class MBAPMDebugCrashViewController: UIViewController {
    
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
    
    fileprivate lazy var settingBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem.init(title: "设置", style: UIBarButtonItem.Style.plain, target: self, action: #selector(settingAction));
    }()
    
    
    @objc fileprivate func zombieCrashOccured() {
        NSLog("zombieCrashOccured")
        let issueTrigger: MBChaosIssueProtocol = MBChaosCrashIssueOC.init()
        issueTrigger.triggerIssue()
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
    
    @objc func settingAction() -> Void {
        let configVC: CrashMonitorConfigViewController = CrashMonitorConfigViewController()
        self.navigationController?.pushViewController(configVC, animated: false)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "崩溃监控"
        self.navigationItem.rightBarButtonItem = settingBarButtonItem
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.tertiarySystemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        self.view .addSubview(zombieObjectCrashBtn)
    }
    
    
}
