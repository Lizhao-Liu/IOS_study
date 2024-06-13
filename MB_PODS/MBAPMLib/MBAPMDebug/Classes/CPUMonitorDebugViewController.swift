//
//  CPUMonitorDebugViewController.swift
//  MBAPMDebug
//
//  Created by xp on 2022/12/27.
//

import Foundation

@objc
open class CPUMonitorDebugViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "CPU监控"
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.tertiarySystemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        self.view.addSubview(cpuMockBtn1);
        self.view.addSubview(cpuMockBtn2);
        self.view.addSubview(cpuMockBtn3);
    }
    
    fileprivate lazy var cpuMockBtn1: UIButton = {
        let btn: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("模拟高CPU占用", for: UIControl.State.normal)
        btn.setTitleColor(.black, for: UIControl.State.normal)
        btn.frame = CGRect(x: 100, y: 100, width: 150, height: 60)
        btn.addTarget(self, action: #selector(mockHighCPU1), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var cpuMockBtn2: UIButton = {
        let btn: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("模拟高CPU占用", for: UIControl.State.normal)
        btn.setTitleColor(.black, for: UIControl.State.normal)
        btn.frame = CGRect(x: 100, y: 200, width: 150, height: 60)
        btn.addTarget(self, action: #selector(mockHighCPU2), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    
    fileprivate lazy var cpuMockBtn3: UIButton = {
        let btn: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("模拟高CPU占用", for: UIControl.State.normal)
        btn.setTitleColor(.black, for: UIControl.State.normal)
        btn.frame = CGRect(x: 100, y: 300, width: 150, height: 60)
        btn.addTarget(self, action: #selector(mockHighCPU3), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc func mockHighCPU1() {
        DispatchQueue.global().async {
            for i in 0...100000000 {
                print("88第 \(i) 次读");
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    
    @objc func mockHighCPU2() {
        let queue: DispatchQueue = DispatchQueue.init(label: "com.mb.apmdebug.networkmock", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            for i in 0...100000000 {
                print("99第 \(i) 次读");
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
        
    }
    
    @objc func mockHighCPU3() {
        DispatchQueue.global().async {
            for i in 0...100000000 {
                let format:DateFormatter = DateFormatter.init()
                format.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
                format.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone
                let dateString: String = format.string(from: NSDate.init() as Date)
                print("111第 \(i) 次读 date = \(dateString)")
            }
        }
        
    }
}
