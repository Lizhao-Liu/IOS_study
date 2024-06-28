//
//  MBPluginInfoModel.swift
//  MBFoundation
//
//  Created by 汪灏 on 2021/10/29.
//

import Foundation

// swiftlint:disable implicit_getter
// swiftlint:disable line_length
@objc
public class MBPluginInfoModel: NSObject {
    @objc public var name: String?
    @objc public var versionName: String?
    @objc public var versionCode: NSInteger = 0

    /// 返回去掉后缀的 version
    /// 例如 versionName = "0.0.1beta1"
    /// 当前 versionNumber 返回 "0.0.1"
    @objc public var versionNumber: String? {
        guard let versionName = versionName,
              let range = versionName.range(of: "[0-9]+([.][0-9]+)*", options: .regularExpression) else {
            return nil
        }
        return String(versionName[range])
    }

    public override var description: String {
        get {
            return "<\(type(of: self)): name = \(name ?? ""), version name = \(versionName ?? ""), version code = \(versionCode)>"
        }
    }

    @objc public static func modelMap(string: String) -> [String: MBPluginInfoModel] {
        let strings = parsePluginInfo(string: string)
        var map = [String: MBPluginInfoModel].init()
        for str in strings {
            if let model = model(string: str) {
                if str.contains("/"),
                    let name = str.components(separatedBy: "/").first {
                    model.name = name
                    map[name] = model
                } else {
                    map[model.name!] = model
                }
            }
        }
        return map
    }

    static func model(string: String?) -> MBPluginInfoModel? {
        if string?.isEmpty ?? true {
            return nil
        }
        let info = parsePluginInfoModel(string: string)
        let name = info["name"] as? String
        let versionName = info["versionName"] as? String
        let versionCode = info["versionCode"] as? NSNumber
        if name == nil || versionName == nil || versionCode == nil {
            return nil
        }
        let model = MBPluginInfoModel()
        model.name = name
        model.versionName = versionName
        model.versionCode = versionCode!.intValue
        return model
    }

    static func hcb_tk_toPluginVersionCode(string: String?) -> Int {
        let set = NSCharacterSet.letters
        let str = string?.trimmingCharacters(in: set)
        if str?.isEmpty ?? true {
            return 0
        }
        let components: [String] = str!.components(separatedBy: ".")
        if components.count < 3 {
            return 0
        }
        var idx = 0, count = 3, code = 0
        while (idx < count) {
            let component = components[idx]
            let tempCode = (component as NSString).integerValue
            code *= 100
            code += tempCode
            idx += 1
        }
        return code
    }

    static func parsePluginInfo(string: String?) -> [String] {
        var array = [String]()
        if string?.isEmpty ?? true {
            return array
        }
        let set = CharacterSet(charactersIn: "\n")
        let infos = string!.components(separatedBy: set)
        for str in infos.filter({$0.isEmpty == false}) {
            array.append(str)
        }
        return array
    }

    static func parsePluginInfoModel(string: String?) -> [String: Any] {
        var dic = [String: Any]()
        if string?.isEmpty ?? true {
            return dic
        }
        let components = string!.components(separatedBy: " ")
        if components.count != 2 {
            return dic
        }
        let name = components.first
        let ver = components.last?.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
        if (name?.isEmpty ?? true) || (ver?.isEmpty ?? true) {
            return dic
        }

        let verCode = hcb_tk_toPluginVersionCode(string: ver ?? "")
        dic["name"] = name
        dic["versionName"] = ver
        dic["versionCode"] = NSNumber(value:verCode)
        return dic
    }
}
