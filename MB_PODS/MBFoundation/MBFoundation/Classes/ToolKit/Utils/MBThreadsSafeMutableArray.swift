//
//  MBThreadsSafeMutableArray.swift
//  MBFoundation
//
//  Created by William Chang on 2021/8/17.
//

import UIKit

@objc open class MBThreadsSafeMutableArray: NSMutableArray {
    private static let kReadWriteQueueKey = "com.ymm.MBThreadSafeMutableArray"
    private var _readWriteQueue : DispatchQueue!
    private lazy var arr = NSMutableArray()
    override init() {
        super.init()
        _readWriteQueue = DispatchQueue(label: MBThreadsSafeMutableArray.kReadWriteQueueKey,
                                        qos: DispatchQoS.default,
                                        attributes: DispatchQueue.Attributes.concurrent,
                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                        target: nil)
    }

    required public init?(coder: NSCoder) {
        _readWriteQueue = DispatchQueue(label: MBThreadsSafeMutableArray.kReadWriteQueueKey,
                                        qos: DispatchQoS.default,
                                        attributes: DispatchQueue.Attributes.concurrent,
                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                        target: nil)
        fatalError("init(coder:) has not been implemented")
    }

    override init(capacity numItems: Int) {
        super.init()
        _readWriteQueue = DispatchQueue(label: MBThreadsSafeMutableArray.kReadWriteQueueKey,
                                        qos: DispatchQoS.default,
                                        attributes: DispatchQueue.Attributes.concurrent,
                                        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                        target: nil)
    }

    deinit {
        // CFArrayCreateMutable得到的是一个托管对象,所以我们不需要再使用CFRelease来释放它了
    }

    open override var count: Int {
        var arrCount : NSInteger = 0
        _readWriteQueue.sync {
            arrCount = self.arr.count
        }
        return arrCount
    }

    open override func object(at index: Int) -> Any {
        var object : Any?
        _readWriteQueue.sync {
            let count = self.arr.count
            if index < count {
                object = self.arr.object(at:index)
            } else {
                object = nil
            }
        }
        return object!
    }
    // MARK: - private method
    open override func add(_ anObject: Any) {
        let write = DispatchWorkItem(flags: .barrier) {
            self.arr.add(anObject)
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func insert(_ anObject: Any, at index: Int) {
        let write = DispatchWorkItem(flags: .barrier) {
            let count = self.arr.count
            let blockIndex = count > index ? index : count
            self.arr.insert(anObject, at: blockIndex)
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func removeLastObject() {
        let write = DispatchWorkItem(flags: .barrier) {
            let count = self.arr.count
            // swiftlint:disable:next empty_count
            if count > 0 {
                self.arr.removeLastObject()
            }
        }
        _readWriteQueue.sync(execute: write)
    }
    open override func removeObject(at index: Int) {
        let write = DispatchWorkItem(flags: .barrier) {
            let count = self.arr.count
            if count > index {
                self.arr.removeObject(at: index)
            }
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func remove(_ anObject: Any) {
        let index = self.index(of: anObject)
        let write = DispatchWorkItem(flags: .barrier) {
            let count = self.arr.count
            if count > index {
                self.arr.remove(anObject)
            }
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func replaceObject(at index: Int, with anObject: Any) {
        let write = DispatchWorkItem(flags: .barrier) {
            let count = self.arr.count
            if count > index {
                self.arr.replaceObject(at: index, with: anObject)
            }
        }
        _readWriteQueue.sync(execute: write)
    }

    open override func index(of anObject: Any) -> Int {
        var index : Int = 0
        _readWriteQueue.sync {
            index = self.arr.index(of: anObject)
        }
        return index
    }

    open override func removeAllObjects() {
        let write = DispatchWorkItem(flags: .barrier) {
            let count = self.arr.count
            // swiftlint:disable:next empty_count
            if count > 0 {
                self.arr.removeAllObjects()
            }
        }
        _readWriteQueue.sync(execute: write)
    }

}
