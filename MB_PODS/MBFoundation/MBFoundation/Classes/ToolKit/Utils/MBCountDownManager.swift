//
//  MBCountDownManager.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/19.
//

import UIKit

// swiftlint:disable implicit_getter
private let countDownManager = MBCountDownManager()
@objc open class MBCountDownManager: NSObject {
    @objc public var timeInterval : NSInteger = 0
    private var time : Timer?
    private var timer : Timer {
        get {
            if let time = time {
                return time
            } else {
                time = Timer.init(timeInterval: 1,
                                  target: self,
                                  selector: #selector(timeAction),
                                  userInfo: nil,
                                  repeats: true)
                return time!
            }

        }
    }
    @objc public class func sharedMBCountDownManager() -> MBCountDownManager {
        return countDownManager
    }

    @objc public func start() {
        timer.fire()
        RunLoop.current.add(timer, forMode: .default)
    }

    @objc public func reload() {
        timeInterval = 0
    }

    @objc public func stop() {
        timer.invalidate()
        time = nil
    }

    @objc private func timeAction() {
        timeInterval += 1
        NotificationCenter.default.post(name: Notification.Name.init(kCargoQuoteTimeCountDown), object: nil)
    }

    deinit {
        stop()
    }
}
