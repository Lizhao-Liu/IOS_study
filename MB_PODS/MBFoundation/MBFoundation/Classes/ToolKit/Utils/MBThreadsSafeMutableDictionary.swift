//
//  MBThreadsSafeMutableDictionary.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/18.
//

import UIKit

@objc open class MBThreadsSafeMutableDictionary: NSMutableDictionary {
    private lazy var dic = NSMutableDictionary()
    private static let kReadWriteQueueKey = "com.ymm.MBThreadSafeMutableDictionary"
    private var _readWriteQueue : DispatchQueue!

    override init() {
        super.init()
        _readWriteQueue = DispatchQueue(label: MBThreadsSafeMutableDictionary.kReadWriteQueueKey,
                                        qos: DispatchQoS.default,
                                        attributes: DispatchQueue.Attributes.concurrent,
                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                        target: nil)
    }

    override init(capacity numItems: Int) {
        super.init()
        _readWriteQueue = DispatchQueue(label: MBThreadsSafeMutableDictionary.kReadWriteQueueKey,
                                        qos: DispatchQoS.default,
                                        attributes: DispatchQueue.Attributes.concurrent,
                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                        target: nil)
    }

    required public init?(coder: NSCoder) {
        _readWriteQueue = DispatchQueue(label: MBThreadsSafeMutableDictionary.kReadWriteQueueKey,
                                        qos: DispatchQoS.default,
                                        attributes: DispatchQueue.Attributes.concurrent,
                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                        target: nil)
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - NSDictionary Primitive Methods
    open override var count: Int {
        var count = 0
        _readWriteQueue.sync {
            count = self.dic.count
        }
        return count
    }

    open override func object(forKey aKey: Any) -> Any? {
        var valueObject : Any?
        _readWriteQueue.sync {
            valueObject = self.dic.object(forKey:aKey)
        }
        return valueObject
    }

    open override var allKeys: [Any] {
        var keys = [Any]()
        _readWriteQueue.sync {
            keys = self.dic.allKeys
        }
        return keys
    }

    open override var allValues: [Any] {
        var values = [Any]()
        _readWriteQueue.sync {
            values = self.dic.allValues
        }
        return values
    }

// MARK: NSMutableDictionary Primitive Methods
    open override func removeObject(forKey aKey: Any) {
        let write = DispatchWorkItem(flags: .barrier) {
            self.dic.removeObject(forKey: aKey)
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func setObject(_ anObject: Any, forKey aKey: NSCopying) {
        let write = DispatchWorkItem(flags: .barrier) {
            self.dic.setObject(anObject, forKey: aKey)
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func addEntries(from otherDictionary: [AnyHashable : Any]) {
        let write = DispatchWorkItem(flags: .barrier) {
            self.dic.addEntries(from: otherDictionary)
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func removeAllObjects() {
        let write = DispatchWorkItem(flags: .barrier) {
            self.dic.removeAllObjects()
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func removeObjects(forKeys keyArray: [Any]) {
        let write = DispatchWorkItem(flags: .barrier) {
            self.dic.removeObject(forKey: keyArray)
        }
        _readWriteQueue.sync(execute: write)
    }

}
