//
//  NetInfoTestViewController.swift
//  T3Library
//
//  Created by Potter on 10/31/2019.
//  Copyright (c) 2019 lich. All rights reserved.
//

import UIKit

import MBFoundation

class DeviceTestViewController: UIViewController {

    var dataSource = [ActionBean]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }

    deinit {
        print("DeviceTestViewController deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initUI() {
        self.title = "DeviceInfo"
        view.addSubview(tableView)
        view.addSubview(textView)
    }

    func initData() {
//
//        let bean1 = ActionBean(name: "设备ID") {[weak self] in
////            let obj = UIDevice.deviceUUID()
////            self?.addContentToLogView("deviceID \(String(describing: obj))")
//        }
//
//        let bean2 = ActionBean(name: "deviceName") {[weak self] in
////            let obj = UIDevice.deviceName()
////            self?.addContentToLogView("deviceName \(String(describing: obj))")
//        }
//
//        let bean3 = ActionBean(name: "deviceSystemName") {[weak self] in
////            let obj = UIDevice.deviceSystemName()
////            self?.addContentToLogView("deviceSystemName \(String(describing: obj))")
//        }
//
//        let bean4 = ActionBean(name: "deviceSystemVersion") {[weak self] in
////            let obj = UIDevice.deviceSystemVersion()
////            self?.addContentToLogView("deviceSystemVersion \(String(describing: obj))")
//        }
//
//        dataSource = [bean1, bean2, bean3, bean4]
    }

    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-200), style: .plain)
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cellIndex")
        view.delegate = self
        view.dataSource = self
        return view
    }()

    lazy var textView: UITextView = {
        let view = UITextView(frame: CGRect(x: 0, y: self.view.frame.size.height-200, width: self.view.frame.size.width, height: 200))
        view.isEditable = false
        return view
    }()

    func addContentToLogView(_ newContent: String) {
        print(newContent)
        var str = textView.text
        str?.append(contentsOf: "\n\(newContent)")
        textView.text = str
    }
}

extension DeviceTestViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellIndex")
        let bean = dataSource[indexPath.row]
        cell.textLabel?.text = bean.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bean = dataSource[indexPath.row]
        bean.action?()
    }
}
