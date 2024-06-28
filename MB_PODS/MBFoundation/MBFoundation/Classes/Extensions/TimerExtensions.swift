// 
//  TimerExtensions.swift 
//  MBFoundation 
// 
//  Created by rensihao on 2021/1/25.
// 

import Foundation
// swiftlint:disable line_length
public extension MBFoundationWrapper where T == Timer {

    @discardableResult
    static func scheduledTimerWith(timeInterval: TimeInterval, repeats: Bool, completion: @escaping(_ timer: Timer) -> Void) -> Timer {
        Timer.mb_scheduledTimerWith(timeInterval: timeInterval, repeats: repeats, completion: completion)
    }
}

@objc
public extension Timer {

    // MARK: Weak timer

    @discardableResult
    static func mb_scheduledTimerWith(timeInterval: TimeInterval, repeats: Bool, completion: @escaping(_ timer: Timer) -> Void) -> Timer {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(mb_completionInvoke(_:)), userInfo: completion, repeats: repeats)
    }

    private static func mb_completionInvoke(_ timer: Timer) {
        guard let completion = timer.userInfo as? ((Timer) -> Void) else { return }
        completion(timer)
    }

}
