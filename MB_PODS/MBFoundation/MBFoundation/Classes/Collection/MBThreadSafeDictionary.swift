//
//  MBThreadSafeDictionary.swift
//  MBFoundation
//
//  Created by rensihao on 2021/2/22.
//

import Foundation

public class MBThreadSafeDictionary<Key: Hashable, Value> {

    fileprivate let queue = DispatchQueue(
        label: "com.mbfoundation.thread-safe-dictionary",
        attributes: .concurrent)
    fileprivate var dictionary = [Key: Value]()

    public init() { }

    public convenience init(_ dictionary: [Key: Value]) {
        self.init()
        self.dictionary = dictionary
    }

}

// MARK: Properties

public extension MBThreadSafeDictionary {

    var keys: Dictionary<Key, Value>.Keys? {
        var keys: Dictionary<Key, Value>.Keys?
        queue.sync {
            keys = self.dictionary.keys
        }
        return keys
    }

    var values: Dictionary<Key, Value>.Values? {
        var values: Dictionary<Key, Value>.Values?
        queue.sync {
            values = self.dictionary.values
        }
        return values
    }

    var count: Int {
        var count = 0
        queue.sync {
            count = self.dictionary.count
        }
        return count
    }

    var isEmpty: Bool {
        var isEmpty = false
        queue.sync {
            isEmpty = self.dictionary.isEmpty
        }
        return isEmpty
    }

    var description: String {
        var description = ""
        queue.sync {
            description += self.dictionary.description
        }
        return description
    }

}

// MARK: Immutable

public extension MBThreadSafeDictionary {

    func contains(where predicate: ((_ key: Key, _ value: Value) -> Bool)) -> Bool {
        var result = false
        queue.sync {
            result = self.dictionary.contains(where: predicate)
        }
        return result
    }

}

// MARK: Mutable

public extension MBThreadSafeDictionary {

    func updateValue(_ value: Value, forKey key: Key, completion: ((Value?) -> Void)?) {
        queue.async(flags: .barrier) {
            let value = self.dictionary.updateValue(value, forKey: key)
            DispatchQueue.main.async {
                completion?(value)
            }
        }
    }

    func removeValue(forKey key: Key, completion: ((Value?) -> Void)?) {
        queue.async(flags: .barrier) {
            let value = self.dictionary.removeValue(forKey: key)
            DispatchQueue.main.async {
                completion?(value)
            }
        }
    }

    func removeAll(completion: ((Bool?) -> Void)?) {
        queue.async(flags: .barrier) {
            self.dictionary.removeAll()
            DispatchQueue.main.async {
                completion?(true)
            }
        }
    }

}

// MARK: Subscript

public extension MBThreadSafeDictionary {

    subscript(key: Key) -> Value? {
        get {
            var result: Value?
            queue.sync {
                result = self.dictionary[key]
            }
            return result
        }
        set {
            guard let newValue = newValue else { return }
            queue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }

}
