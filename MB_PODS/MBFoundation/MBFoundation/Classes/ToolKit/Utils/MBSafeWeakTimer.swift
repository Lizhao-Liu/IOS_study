//
//  MBSafeWeakTimer.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/18.
//

import UIKit

class MBSafeWeakTargetTimer : NSObject {
    weak var aTarget : AnyObject?
    var aSelector : Selector!
    weak var timer : Timer!
    @objc func fire(_ timer : Timer) {
        if let target = self.aTarget {
            // 此方法调用会在runloop defaultmode中执行，所以将timer放到commonMode中会失效，所以使用perform withObject方法
            if target.responds(to: aSelector) {
                _ = target.perform(aSelector, with: timer.userInfo)
            }
        } else {
            timer.invalidate()
        }
    }
}
@objc open class MBSafeWeakTimer: NSObject {
    public typealias MBWeakTimerHandler = (_ userInfo : AnyObject) -> Void
    public override init() {
        super.init()
    }
    /// 定时器方法
    /// - Parameters:
    ///   - timeInterval: 定时器时间
    ///   - aTarget: 执行方法对象
    ///   - aSelector : 执行方法
    ///   - userInfo: 参数
    ///   - repeats: 是否循环
    @objc class open func scheduledTimer(timeInterval : TimeInterval,
                                         aTarget : AnyObject,
                                         aSelector : Selector,
                                         userInfo : Any?,
                                         repeats : Bool) -> Timer {
        let timerTarget = MBSafeWeakTargetTimer.init()
        timerTarget.aTarget = aTarget
        timerTarget.aSelector = aSelector
        let timer = Timer.init(timeInterval: timeInterval,
                               target: timerTarget,
                               selector: #selector(MBSafeWeakTargetTimer.fire(_:)),
                               userInfo: userInfo,
                               repeats: repeats)
        RunLoop.current.add(timer, forMode: .default)
        timerTarget.timer = timer
        return timerTarget.timer
    }

    /// 定时器方法带block
    /// - Parameters:
    ///   - timeInterval: 定时器时间
    ///   - block: 回调block
    ///   - userInfo: 参数
    ///   - repeats: 是否循环
    @objc class open func scheduledTimer(timeInterval : TimeInterval,
                                         block : @escaping MBWeakTimerHandler,
                                         userInfo : Any?,
                                         repeats : Bool) -> Timer {
        let userInfoArray = NSMutableArray.init(object: block)
        if let userInfo = userInfo {
            userInfoArray.add(userInfo)
        }
        return self.scheduledTimer(timeInterval: timeInterval,
                                   aTarget: self,
                                   aSelector: #selector(MBSafeWeakTimer._timerBlockInvoke(_:)),
                                   userInfo: userInfoArray,
                                   repeats: repeats)
    }

    @objc private class func _timerBlockInvoke(_ userInfo : NSArray) {
        var info : Any?
        if userInfo.count == 2 {
            info = userInfo[1]
        }
        if let handler = userInfo.firstObject as? MBWeakTimerHandler {
            handler(info as AnyObject)
        }
    }

}
