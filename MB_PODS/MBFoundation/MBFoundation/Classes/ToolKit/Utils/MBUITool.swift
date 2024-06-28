//
//  MBUITool.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/23.
//

import UIKit

// swiftlint:disable line_length
private var _ymmRate : CGFloat = 1
private var _ymmWrate : CGFloat = 1
private var _ymmHrate : CGFloat = 1
private let kUIToolScreenWidth = UIScreen.main.bounds.size.width
private let kUIToolScreenHeight = UIScreen.main.bounds.size.height
private var _is65InchScreen : NSInteger = -1
private var _is61InchScreen : NSInteger = -1
private var _is58InchScreen : NSInteger = -1
private var _is55InchScreen : NSInteger = -1
private var _is47InchScreen : NSInteger = -1
private var _is40InchScreen : NSInteger = -1
private var _is35InchScreen : NSInteger = -1
private var isInitialed : Bool = false
@objc open class MBUITool : NSObject {
    private static let initialize: () = {
        setUITemplateSize(CGSize.init(width: 375, height: 667))
    }()
    override init() {
        super.init()
        isInitialed = true
        MBUITool.initialize
    }

    @objc public class func setUITemplateSize(_ size : CGSize) {
        let screenSize = UIScreen.main.bounds.size
        _ymmRate = screenSize.width / size.width
        _ymmWrate = screenSize.height / size.height
        _ymmRate = sqrt((screenSize.width * screenSize.width + screenSize.height * screenSize.height) / (size.width * size.width + size.height * size.height))
    }

    // 返回屏幕尺寸缩放的比例
    @objc public class func scale(_ val : CGFloat) -> CGFloat {
        if !isInitialed { _ = MBUITool.init() }
        return val * _ymmRate
    }

    // 返回屏幕宽度缩放的比例
    @objc public class func scaleW(_ val : CGFloat) -> CGFloat {
        if !isInitialed { _ = MBUITool.init() }
        return val * _ymmWrate
    }

    // 返回屏幕高度缩放的比例
    @objc public class func scaleH(_ val : CGFloat) -> CGFloat {
        if !isInitialed { _ = MBUITool.init() }
        return val * _ymmHrate
    }

}

extension MBUITool {
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }

    @objc public class func deviceModel() -> String {
        if !isInitialed { _ = MBUITool.init() }
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        var systemInfo = utsname()
        uname(&systemInfo)
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr, encoding: .utf8)
        }
        return platform ?? ""
    }

    /// 是否为模拟器
    @objc public class func isSimulator() -> Bool {
        if !isInitialed { _ = MBUITool.init() }
        return Platform.isSimulator
    }

    @available(iOSApplicationExtension, unavailable, message: "This func which use UIApplication.shared is NS_EXTENSION_UNAVAILABLE.")
    /// 是否全面屏类型的设备
    @objc public class func isNotchedScreen() -> Bool {
        if !isInitialed { _ = MBUITool.init() }
        var notch = false
        if #available(iOS 11.0, *) {
            if UIApplication.shared.keyWindow!.safeAreaInsets.bottom > 0 {
                notch = true
            }
        }
        return notch
    }

    @available(iOSApplicationExtension, unavailable, message: "This func which use UIApplication.shared is NS_EXTENSION_UNAVAILABLE.")
    // 用于获取 iPhone X 系列全面屏手机的安全区域的 insets
    @objc public class func safeAreaInsetsForDeviceWithNotch() -> UIEdgeInsets {
        if !isInitialed { _ = MBUITool.init() }
        if !MBUITool.isNotchedScreen() {
            return .zero
        }

        let orientation = UIApplication.shared.statusBarOrientation
        switch orientation {
        case .portrait:
            return UIEdgeInsets.init(top: 44, left: 0, bottom: 34, right: 0)
        case .portraitUpsideDown:
            return .init(top: 34, left: 0, bottom: 44, right: 0)
        case .landscapeLeft,.landscapeRight:
            return .init(top: 0, left: 44, bottom: 21, right: 44)
        case .unknown:
            return .init(top: 44, left: 0, bottom: 34, right: 0)
        default:
            return .init(top: 44, left: 0, bottom: 34, right: 0)
        }
    }
}
