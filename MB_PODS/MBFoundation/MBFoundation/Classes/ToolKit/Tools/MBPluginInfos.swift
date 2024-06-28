//
//  MBPluginInfos.swift
//  MBFoundation
//
//  Created by 汪灏 on 2021/8/25.
//

import Foundation

@objc
public class MBPluginInfos: NSObject {

    @objc public static let podfileContent: String? = {
        let bundle = MBToolKitBundle.shared.bundle
        if bundle == nil {
            return nil
        }

        let filePath = bundle!.path(forAuxiliaryExecutable: "plugin_info_podfile")
        if filePath == nil {
            return nil
        }

        do {
            let content = try String(contentsOfFile: filePath!, encoding: .utf8)
            return content
        } catch {
            return nil
        }
    }()

    @objc public static let manfiestContent: String? = {
        let bundle = MBToolKitBundle.shared.bundle
        if bundle == nil {
            return nil
        }

        let filePath = bundle!.path(forAuxiliaryExecutable: "plugin_info_manfiest")
        if filePath == nil {
            return nil
        }

        do {
            let content = try String(contentsOfFile: filePath!, encoding: .utf8)
            return content
        } catch {
            return nil
        }
    }()

    private static let map: [String: MBPluginInfoModel] = {
        var map: [String: MBPluginInfoModel]
        let bundle = MBToolKitBundle.shared.bundle
        let filePath = bundle?.path(forAuxiliaryExecutable: "plugin_info")
        do {
            let string = try String(contentsOfFile: filePath ?? "", encoding: .utf8)
            map = MBPluginInfoModel.modelMap(string: string)
        } catch {
            map = [String: MBPluginInfoModel]()
        }
        return map
    }()

    @objc public static func infos() -> [String: MBPluginInfoModel]? {
        return map
    }

}
