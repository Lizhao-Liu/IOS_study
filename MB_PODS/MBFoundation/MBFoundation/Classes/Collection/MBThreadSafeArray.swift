//
//  MBThreadSafeArray.swift
//  MBFoundation
//
//  Created by rensihao on 2021/2/22.
//

import Foundation

public class MBThreadSafeArray<Element> {

    fileprivate let queue = DispatchQueue(
        label: "com.mbfoundation.thread-safe-array",
        attributes: .concurrent)
    fileprivate var array = [Element]()

    public init() { }

    public convenience init(_ array: [Element]) {
        self.init()
        self.array = array
    }
}

// MARK: Properties

public extension MBThreadSafeArray {

    var first: Element? {
        var result: Element?
        queue.sync {
            result = self.array.first
        }
        return result
    }

    var last: Element? {
        var result: Element?
        queue.sync {
            result = self.array.last
        }
        return result
    }

    var count: Int {
        var result = 0
        queue.sync {
            result = self.array.count
        }
        return result
    }

    var isEmpty: Bool {
        var result = false
        queue.sync {
            result = self.array.isEmpty
        }
        return result
    }

    var description: String {
        var result = ""
        queue.sync {
            result.append(self.array.description)
        }
        return result
    }

}

// MARK: Immutable

public extension MBThreadSafeArray {

    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync {
            result = self.array.first(where: predicate)
        }
        return result
    }

    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync {
            result = self.array.filter(isIncluded)
        }
        return result
    }

    func firstIndex(where predicate: (Element) -> Bool) -> Int? {
        var result: Int?
        queue.sync {
            result = self.array.firstIndex(where: predicate)
        }
        return result
    }

    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync {
            result = self.array.sorted(by: areInIncreasingOrder)
        }
        return result
    }

    func compactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync {
            result = self.array.compactMap(transform)
        }
        return result
    }

    func forEach(_ body: (Element) -> Void) {
        queue.sync {
            self.array.forEach(body)
        }
    }

    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync {
            result = self.array.contains(where: predicate)
        }
        return result
    }

}

// MARK: Mutable

public extension MBThreadSafeArray {

    func append(_ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func append(_ elements: [Element]) {
        queue.async(flags: .barrier) {
            self.array += elements
        }
    }

    func insert(_ element: Element, at index: Int) {
        queue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }

    func remove(at index: Int, completion: ((Element) -> Void)?) {
        queue.async(flags: .barrier) {
            let element = self.array.remove(at: index)
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }

    func remove(where predicate: @escaping (Element) -> Bool, completion: ((Element) -> Void)?) {
        queue.async(flags: .barrier) {
            guard let index = self.array.firstIndex(where: predicate) else { return }
            let element = self.array.remove(at: index)
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }

    func removeAll(completion: (([Element]) -> Void)?) {
        queue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }

}

// MARK: Subscript

public extension MBThreadSafeArray {

    subscript(index: Int) -> Element? {
        get {
            var result: Element?
            queue.sync {
                guard self.array.startIndex..<self.array.endIndex ~= index else { return }
                result = self.array[index]
            }
            return result
        }
        set {
            guard let newValue = newValue else { return }
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
    }

}

// MARK: Equatable

public extension MBThreadSafeArray where Element: Equatable {

    func contains(_ element: Element) -> Bool {
        var result = false
        queue.sync {
            result = self.array.contains(element)
        }
        return result
    }

}

// MARK: Infix Operators

public extension MBThreadSafeArray {

    static func += (left: inout MBThreadSafeArray, right: Element) {
        left.append(right)
    }

    static func += (left: inout MBThreadSafeArray, right: [Element]) {
        left.append(right)
    }

}
