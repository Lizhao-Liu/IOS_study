// 
//  ObjectExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation

// swiftlint:disable line_length

// 页面埋点协议
@objc
public protocol MBAutoLogPageProtocol {

    @objc var mbPageName: String? { get set } // 页面名称
    @objc optional var mbModuleName: String? { get set } // 模块名称
    @objc optional var mbReferPageName: String? { get set } // 页面来源名称

    @objc func mb_extension() -> NSDictionary?
}

// 控件埋点协议
@objc
public protocol MBAutoLogViewProtocol {

    @objc var mbElementId: String? { get set } // 埋点ID
    @objc optional var mbEventType: String? { get set } // 埋点类型

    @objc func mb_extension() -> NSDictionary?
}

@objc
public extension NSObject {

    func mb_swizzleInstanceMethodWithOriginSelector(_ originSel: Selector, swizzleSelector swizzleSel: Selector) -> Bool {
        let cls: AnyClass? = object_getClass(self)
        let originMethod = class_getInstanceMethod(cls, originSel)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSel)
        return NSObject.mb_swizzleMethodWithOriginSelector(originSel, originMethod, swizzleSel, swizzleMethod, cls)
    }

    static func mb_swizzleClassMethodWithOriginSelector(_ originSel: Selector, swizzleSelector swizzleSel: Selector) -> Bool {
        let cls = self
        let originMethod = class_getInstanceMethod(cls, originSel)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSel)
        return NSObject.mb_swizzleMethodWithOriginSelector(originSel, originMethod, swizzleSel, swizzleMethod, cls)
    }

    private static func mb_swizzleMethodWithOriginSelector(_ originSelector: Selector, _ originMethod: Method?, _ swizzleSelector: Selector, _ swizzleMethod: Method?, _ cls: AnyClass?) -> Bool {
        guard let originMethod = originMethod else { return false }
        guard let swizzleMethod = swizzleMethod else { return false }
        guard let cls = cls else { return false }

        let didAddMethod = class_addMethod(cls, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod))
        } else {
            method_exchangeImplementations(originMethod, swizzleMethod)
        }
        return true
    }

}

// MBJournal
private var key: Void?

@objc
extension NSObject: MBAutoLogViewProtocol {
    public func mb_extension() -> NSDictionary? {
        return nil
    }

    public var mbElementId: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public var mbEventExtraDic: NSDictionary? {
        get {
            return objc_getAssociatedObject(self, &key) as? NSDictionary
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public var mbLogElementId: String? {
        get {
            return self.mbElementId
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
