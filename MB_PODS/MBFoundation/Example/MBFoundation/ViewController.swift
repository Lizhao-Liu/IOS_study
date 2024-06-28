//
//  ViewController.swift
//  MBFoundation
//
//  Created by rensihao on 01/21/2021.
//  Copyright (c) 2021 rensihao. All rights reserved.
//

import UIKit
import MBFoundation

// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable file_length

// MARK: - ActionModel
struct ActionBean {
    var name: String?
    var subTitle: String?
    var action: (() -> Void)?
}


// MARK: - 所有的Action在这里
extension ViewController {
    var actions: [ActionBean] {
        [bean1, bean2] + [sBean1, sBean3, sBean4, sBean5, sBean6, sBean7]
    }
}

// MARK: - 使用self的函数放这里
extension ViewController {
    var bean2: ActionBean {
        ActionBean(name: "Location") {
            let vc = LocationTestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    var bean1: ActionBean {
        ActionBean(name: "DeviceInfo") {
            let vc = DeviceTestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - 没有使用self的单纯打印的单独放
private let sBean6 = ActionBean(name: "mb_appendURLQueryParametersUsingStringMatching") {
    let url = NSString("http://10.250.123.162:8000/microweb/aa/#/mw-wallet-h5/oneKeyBindCard/transfe")
    let arr = ["bankCode": "123"]
    print(url.mb_appendURLQueryParametersUsingStringMatching(arr))
}

private let sBean5 = ActionBean(name: "mb_objectForKeyIgnoreNil") {
    let dic = NSDictionary(dictionary: ["a": "1"])
    _ = ["b": "2"]

    let s: NSString = "a"
//        let m = dic.mb_objectForKey(s)
    let t = dic.mb_objectForKeyIgnoreNil(s)

//        print(m)
    print(t!)

    let str = "ymm://flutter.servicebox/index?_singleton=1" as NSString

    print(str.mb_urlQueryString()!)
    print(str.mb_urlQueryString()!)
//        mb_objectForKeyIgnoreNil
}

private let sBean7 = ActionBean(name: "Test.init().testwindow()") {
    print(Test.init().testwindow())
}

private let sBean4 = ActionBean(name: "methodSwitchFalse") {
    let str = "https://www.baidu.com/"
    print(str.mb.md5String() ?? "")
}

public extension String {
    static func fileWithBundle(fullName: String, bundle: String? = nil) -> String? {
        var bundlePath: String? = Bundle.main.bundlePath
        //        NSLog("aaa-----1----\(bundlePath)")
        if let tempPath = Bundle.main.path(forResource: fullName, ofType: "bundle"),
           tempPath.count > 0 {
            bundlePath = tempPath
        }
        //        NSLog("aaa-----2----\(bundlePath)")
        if let tempPath = bundlePath,
           tempPath.contains("PlugIns") {
            if let bundle = bundle {
                bundlePath = tempPath.components(separatedBy: "PlugIns").first?.appending("Frameworks/MBLiveActivityLib.framework/\(bundle).bundle/")
                if let path = bundlePath,
                    FileManager.default.fileExists(atPath: path) {
                    // goon
                } else {
                    bundlePath = tempPath.components(separatedBy: "PlugIns").first?.appending("\(bundle).bundle/")
                }
            } else {
                bundlePath = tempPath.components(separatedBy: "PlugIns").first
            }
        }
        //        NSLog("aaa-----3----\(bundlePath)")
        if bundlePath?.hasSuffix("/") == false {
            //            bundlePath?.removeLast()
            bundlePath = bundlePath?.appending("/")
        }
        
        //        NSLog("aaa-----4----\(bundlePath)")
        guard let path = bundlePath else {
            return nil
        }
        
        //        Image(name, bundle: bundle)
        
        
        let imgPath = path.appending("\(fullName)")
        //        NSLog("aaa-----5----\(imgPath)")
        
        //        return nil
//        let appName = Bundle.main.infoDictionary
        //        NSLog("aaa-----6----\(appName?.debugDescription)")
        //        NSLog("aaa-----7----\(imgPath)")
        //        if let url = URL(string: imgPath) {
        //        NSLog("aaa-----8----\(NSData(contentsOfFile: imgPath))")
//        if let data = NSData(contentsOfFile: imgPath) {
//            let dd = Data(data)
//            return UIImage(data: dd, scale: 3)
//        }
        return imgPath
        //        NSData(contentsOfFile: <#T##String#>)
        //        return UIImage(data: Data(NSData(contentsOfFile: imgPath)))
    }

}

@objc
public class FilePath: NSObject {
    @objc func filePathOnBundleWith(_ fileName: String) -> String? {
        return String.fileWithBundle(fullName: fileName)
    }
    @objc static func filePathOnBundleWith(_ fileName: String) -> String? {
        return String.fileWithBundle(fullName: fileName)
    }
}


private let sBean3 = ActionBean(name: "Test.init().test01()") {
    
//    NSString *fileName = @"GlobalProtect-mac4.1.pkg.zip";
//    FilePath *filePath = [FilePath filePathOnBundleWith:fileName];
    guard var filePath = String.fileWithBundle(fullName: "GlobalProtect-mac4.1.pkg.zip") else {
        return
    }
    print(Test.init().test01(filePath))
    guard var filePath = String.fileWithBundle(fullName: "embedded.mobileprovision") else {
        return
    }
    print(Test.init().test01(filePath))
    guard var filePath = String.fileWithBundle(fullName: "Info.plist") else {
        return
    }
    print(Test.init().test01(filePath))
    guard var filePath = String.fileWithBundle(fullName: "LoadableNibView.nib") else {
        return
    }
    print(Test.init().test01(filePath))
    guard var filePath = String.fileWithBundle(fullName: "MBFoundation_Example") else {
        return
    }
    print(Test.init().test01(filePath))
    guard var filePath = String.fileWithBundle(fullName: "MBFoundation.bundle/Info.plist") else {
        return
    }
    print(Test.init().test01(filePath))
    guard var filePath = String.fileWithBundle(fullName: "PkgInfo") else {
        return
    }
    print(Test.init().test01(filePath))
}

private let sBean1 = ActionBean(name: "String的加解蜜") {
    let string = "4DF90829-00A2-4EAB-ABAA-6C7573BD90DA"// UUID().uuidString
    let data = string.data(using: .utf8)
    //        data.zi
    print("|------->\(#fileID) \(#function) \(#line)")
    print("|----\(string)")

    print("|----\(String(describing: data!.mb.deflate()))")
    print("|----\(data!.mb.deflate()!.mb.inflate()!)")
    print("|----\(String(describing: String(data: data!.mb.deflate()!.mb.inflate()!, encoding: .utf8)))")

    print("|----\(data!.mb.zip()!)")
    print("|----\(String(describing: data!.mb.zip()!.mb.unzip(skipCheckSumValidation: false)))")
    print("|----\(String(describing: String(data: data!.mb.zip()!.mb.unzip()!, encoding: .utf8)))")

    print("|----\(data!.mb.gzip()!)")
    print("|----\(String(describing: data!.mb.gzip()!.mb.gunzip()))")
    print("|----\(String(describing: String(data: data!.mb.gzip()!.mb.gunzip()!, encoding: .utf8)))")

    print("|----\(String(describing: data?.mb.crc32()))")
    print("|----\(data!.mb.crc32())")

    let key2 = "F9AFA4C2-EFC9-4D"// String(UUID().uuidString.prefix(16))
    let iv2 = "3BB02377-6571-4A"// String(UUID().uuidString.prefix(16))
    print("|----\(key2)")
    print("|----\(iv2)")
//            let string2 = UUID().uuidString
    let data2 = data?.mb.aes128Encrypt(key: key2, iv: iv2)
    print("|----\(data2!)")
    let data3 = data2?.mb.aes128Decrypt(key: key2, iv: iv2)
    print("|----\(data3!)")
    print("|----\(String(data: data3!, encoding: .utf8)!)")

//            print("|----\(key2)")
//            print("|----\(iv2)")
//            let string2 = UUID().uuidString
//            let data2 = data?.mb.aes128Encrypt(key: key2)
//            print("|----\(data2)")
//            let data3 = data2?.mb.aes128Decrypt(key: key2)
//            print("|----\(data3)")
//            print("|----\(String(data: data3!, encoding: .utf8))")
    let dataInt = Int8(10).data
    let intV = Int8.init(data: dataInt)
    print(intV!)
}


class ViewController: UIViewController {

    var dataSource = [ActionBean]()

    let str = "https://www.baidu.com/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "主功能"
        dataSource = self.actions
        view.addSubview(tableView)
//        MBPluginInfos.infos()
//        MBPluginInfos.infos()
//        MBPluginInfos.infos()
        
        
//        print("ymm://wallet/wallet_auth?a=b#a".mb.urlQueryString())
//        print("ymm://wallet/wallet_auth?a=b#a".mb.urlQueryString())
//        print("ymm://wallet/wallet_auth#a?a=b".mb.urlQueryString())
//        print("ymm://wallet/wallet_autha?a=b".mb.urlQueryString())
//        print("ymm://wallet/wallet_auth?a=b&b=c".mb.urlQueryString())
//        print("ymm://wallet/wallet_auth".mb.urlQueryString())
//
//
//        print("ymm://wallet/wallet_auth?a=b#a".mb.urlQueryParams())
//        print("ymm://wallet/wallet_auth?a=b#a".mb.urlQueryParams())
//        print("ymm://wallet/wallet_auth#a?a=b".mb.urlQueryParams())
//        print("ymm://wallet/wallet_autha?a=b".mb.urlQueryParams())
//        print("ymm://wallet/wallet_auth?a=b&b=c".mb.urlQueryParams())
//        print("ymm://wallet/wallet_auth".mb.urlQueryParams())
        
        print("ymm://wallet/wallet_auth"[1..<1])
        print("ymm://wallet/wallet_auth"[1...1])
        print("ymm://wallet/wallet_auth"[1..<2])
        
        print(["q", "b", "c"][1..<2])
        print(["q", "b", "c"][1..<1])
        
        print(NSURLComponents(string: "ymm://wallet/wallet_auth?aa=b")?.query ?? "")
        
    }

    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cellIndex")
        view.delegate = self
        view.dataSource = self
        return view
    }()

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        tableView.deselectRow(at: indexPath, animated: true)
        let bean = dataSource[indexPath.row]
        bean.action?()
    }
}
