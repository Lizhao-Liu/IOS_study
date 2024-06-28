//
//  DispatchQueueExtensions.swift
//  MBFoundation
//
//  Created by rensihao on 2021/2/1.
//

import Foundation

public extension MBFoundationWrapper where T == DispatchQueue {

    private static var _onceTracker = [String]()
    // swiftlint:disable:next line_length
    static func once(file: String = #file, function: String = #function, line: Int = #line, block:() -> Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }

    static func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
