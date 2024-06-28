//
//  MBHtmlParse.swift
//  MBFoundation_Example
//
//  Created by weigen on 2021/9/3.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
@objc
public protocol MBManagerProtocol {

    // 是否退出登录后也需要常驻内存，默认是NO
    @objc optional func isManagerPersistent() -> Bool
    // Manager初始化时调用
    @objc optional func onManagerInit()
    // 重新登录时会调用
    @objc optional func onManagerReloadData()
    // 进入后台运行
    @objc optional func onManagerEnterBackground()
    // 进入前台运行
    @objc optional func onManagerEnterForeground()
    // 程序退出
    @objc optional func onManagerTerminate()
    // 内存警告
    @objc optional func onManagerMemoryWarning()
    // 退出登录时调用，用于清理和释放资源
    @objc optional func onManagerClearData()
}

@objcMembers
public class MBManagerCenter: NSObject {

    var dicManagers: [String: AnyObject]?
    var lock: NSRecursiveLock?
    public var bLastLoginStatus: Bool?

    public static let defaultCenter = MBManagerCenter()

    private override init() {
        super.init()
        dicManagers = Dictionary()
        lock = NSRecursiveLock()
        // 默认为NO，第一次自动登录和手动登录都可以触发回调
        bLastLoginStatus = false
        addNotificationObserver()
    }

    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAppWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppWillTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppMemoryWarning(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLoginSuccess(_:)), name: NSNotification.Name("MBUserLoginNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout(_:)), name: NSNotification.Name("MBUserLogoutNotification"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // 获取单例对象。
    // 如果对象不存在，则自动创建。但只能创建服从于YMMManagerService协议的对象.
    public func getManager(_ cls: AnyClass) -> AnyObject? {
        lock?.lock()
        if let obj = dicManagers?[NSStringFromClass(cls)] {
            lock?.unlock()
            return obj as AnyObject
        } else {
            if !(cls is MBManagerProtocol.Type) {
                lock?.unlock()
                return nil
            }
            guard let OCClass = cls as? NSObject.Type else {
                return nil
            }
            let obj = OCClass.init()
            dicManagers?.updateValue(obj, forKey: NSStringFromClass(cls))
            lock?.unlock()

            if obj.responds(to: #selector(MBManagerProtocol.onManagerInit)) {
                obj.perform(#selector(MBManagerProtocol.onManagerInit))
            }

            return obj
        }
    }

    public func removeManager(_ cls: AnyClass) {
        lock?.lock()
        dicManagers?.removeValue(forKey: NSStringFromClass(cls))
        lock?.unlock()
    }

    // 判断对象是否被创建
    public func isManagerCreated(_ cls: AnyClass) -> Bool {
        lock?.lock()
        if (dicManagers?[NSStringFromClass(cls)]) != nil {
            lock?.unlock()
            return true
        } else {
            lock?.unlock()
            return false
        }
    }

    // MARK: - Notification
    func onAppWillEnterForeground(_ notification: NSNotification) {
        lock?.lock()
        let array = dicManagers?.values
        lock?.unlock()
        guard let arr = array else { return }
        for item in arr {
            if !(item is MBManagerProtocol) {
                continue
            }
            if (item as AnyObject).responds(to: #selector(MBManagerProtocol.onManagerEnterForeground)) {
                (item as AnyObject).onManagerEnterForeground()
            }
        }
    }

    func onAppDidEnterBackground(_ notification: NSNotification) {
        lock?.lock()
        let array = dicManagers?.values
        lock?.unlock()
        guard let arr = array else { return }
        for item in arr {
            if !(item is MBManagerProtocol) {
                continue
            }
            if (item as AnyObject).responds(to: #selector(MBManagerProtocol.onManagerEnterBackground)) {
                (item as AnyObject).onManagerEnterBackground()
            }
        }
    }

    func onAppWillTerminate(_ notification: NSNotification) {
        lock?.lock()
        let array = dicManagers?.values
        lock?.unlock()
        guard let arr = array else { return }
        for item in arr {
            if !(item is MBManagerProtocol) {
                continue
            }
            if (item as AnyObject).responds(to: #selector(MBManagerProtocol.onManagerTerminate)) {
                (item as AnyObject).onManagerTerminate()
            }
        }
    }

    func onAppMemoryWarning(_ notification: NSNotification?) {
        lock?.lock()
        let array = dicManagers?.values
        lock?.unlock()
        guard let arr = array else { return }
        for item in arr {
            if !(item is MBManagerProtocol) {
                continue
            }
            if (item as AnyObject).responds(to: #selector(onAppMemoryWarning(_:))) {
                (item as AnyObject).onAppMemoryWarning(nil)
            }
        }
    }

    func onLoginSuccess(_ notification: NSNotification) {
        if let loginStatus = bLastLoginStatus {
            if loginStatus {
                return
            }
        }

        bLastLoginStatus = true
        lock?.lock()
        let array = dicManagers?.values
        lock?.unlock()
        guard let arr = array else { return }
        for item in arr {
            if !(item is MBManagerProtocol) {
                continue
            }
            if (item as AnyObject).responds(to: #selector(MBManagerProtocol.onManagerReloadData)) {
                (item as AnyObject).onManagerReloadData()
            }
        }
    }

    func onLogout(_ notification: NSNotification) {

        bLastLoginStatus = false
        lock?.lock()
        let array = dicManagers?.values
        lock?.unlock()
        guard let arr = array else { return }
        for item in arr {
            if !(item is MBManagerProtocol) {
                continue
            }
            if (item as AnyObject).responds(to: #selector(MBManagerProtocol.onManagerClearData)) {
                (item as AnyObject).onManagerClearData()
            }
            var needPersistent = false
            if (item as AnyObject).responds(to: #selector(MBManagerProtocol.isManagerPersistent)) {
                if (item as AnyObject).isManagerPersistent() {
                    needPersistent = true
                }
            }
            if !needPersistent {
                removeManager(type(of: item))
            }
        }

    }

}

@objcMembers
public class MBLazyInitManager: NSObject, MBManagerProtocol {

    class MBLazyObj: NSObject {
        var cls: AnyClass?
        var sel: Selector?
        var obj: AnyObject?

        init(cls: AnyClass, sel: Selector, obj: AnyObject) {
            self.cls = cls
            self.sel = sel
            self.obj = obj
        }
    }

    var notificationsPairs: [String: [MBLazyObj]]?
    var lock: NSLock?

    public func lazyInitManager(cls: AnyClass, onNotification notificationKey: String, performSelector selctor: Selector, object obj: AnyObject) {
        if !(cls is MBManagerProtocol.Type) {
            return
        }
        if notificationKey.isEmpty {
            return
        }

        lock?.lock()
        let delayObj = MBLazyObj(cls: cls, sel: selctor, obj: obj)
        var objArray = notificationsPairs?[notificationKey]
        if objArray != nil {
            objArray!.append(delayObj)
        } else {
            var arr:[MBLazyObj] = []
            arr.append(delayObj)
            notificationsPairs?.updateValue(arr, forKey: notificationKey)
            NotificationCenter.default.addObserver(self, selector: #selector(onNotificationObserved(_:)), name: NSNotification.Name(notificationKey), object: nil)
        }
        lock?.unlock()
    }

    func onNotificationObserved(_ notification: Notification) {
        lock?.lock()
        let array = notificationsPairs?[notification.name.rawValue]
        guard let arr = array else {
            lock?.unlock()
            return
        }

        for item in arr {
            guard let cls = item.cls else { continue }
            if MBManagerCenter.defaultCenter.isManagerCreated(cls) {
                guard let sel = item.sel else { continue }
                if let obj = MBManagerCenter.defaultCenter.getManager(cls) {
                    if obj.responds(to: sel) {
                        _ = obj.perform(sel, with: item.obj)
                    }
                }
            }
        }

        lock?.unlock()
    }

    // MARK: - MBManagerProtocol
    public func isManagerPersistent() -> Bool {
        return true
    }

    public func onManagerInit() {
        notificationsPairs = [:]
        lock = NSLock()
    }

    public func onManagerTerminate() {
        // swiftlint:disable notification_center_detachment
        NotificationCenter.default.removeObserver(self)
    }
}
