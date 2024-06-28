//
//  NetInfoTestViewController.swift
//  T3Library
//
//  Created by Potter on 10/31/2019.
//  Copyright (c) 2019 lich. All rights reserved.
//

import UIKit

import MBFoundation


class VC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

class LocationTestViewController: UIViewController, UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        return true
    }
    
    var dataSource = [ActionBean]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
//        self.presentationController?.isKind(of: UINavigationController.self);
        let uuid1 = MBIdentifyUtil.ymm_uuid()
        let uuid2 = UUID().uuidString
        print("\(uuid1)\n\(uuid2)")
//        NSString *uuidS = [MBIdentifyUtil ymm_uuid];
//        NSLog(@"%@", uuidS);
//        NSString *uuidS2 = [[NSUUID UUID] UUIDString];
//        NSLog(@"%@", uuidS2);
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapA))
        view.addGestureRecognizer(tap)
    }

    @objc func tapA() {
        let vc = VC()
        let nav = UINavigationController()
        nav.viewControllers = [LocationTestViewController(), LocationTestViewController()]
        vc.addChild(nav)
        vc.view.addSubview(nav.view)
        vc.title = nav.title;
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
// self.navigationController?.presentedViewController?.navigationController?.popViewController(animated: false)
//    }

    deinit {
        print("LocationTestViewController deinit")
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initUI() {
        self.title = "Location"
        view.addSubview(tableView)
        view.addSubview(textView)
        let uuid1 = MBIdentifyUtil.ymm_uuid()
        let uuid2 = UUID().uuidString
        print("\(uuid1)\n\(uuid2)")
    }

    func initData() {
        let uuid1 = MBIdentifyUtil.ymm_uuid()
        let uuid2 = UUID().uuidString
        print("\(uuid1)\n\(uuid2)")

//        let bean1 = ActionBean(name: "开启定位") {[weak self] in
////            let obj = Location.getLocation()
////            self?.addContentToLogView("location \(String(describing: obj))")
//        }
//
//        let bean2 = ActionBean(name: "城市编码,区域编码") { [weak self] in
////            let cityCode = Location.getCityCode()
////            let areaCode = Location.getAreaCode()
////            self?.addContentToLogView("城市编码: \(String(describing: cityCode)), 区域编码: \(String(describing: areaCode))")
//        }
//
//        let bean3 = ActionBean(name: "逆向地理编码") { [weak self] in
////            let placemark = Location.getPlacemark()
////            self?.addContentToLogView("地址: \(String(describing: placemark?.formattedAddress))")
//        }
//
//        dataSource = [bean1, bean2, bean3]
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
//        view.isEditable = false
        view.backgroundColor = .brown
        view.delegate = self
        return view
    }()

    func addContentToLogView(_ newContent: String) {
        print(newContent)
        var str = textView.text
        str?.append(contentsOf: "\n\(newContent)")
        textView.text = str
    }
}

extension LocationTestViewController: UITableViewDelegate, UITableViewDataSource {

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
