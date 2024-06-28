//
//  ThenTest.swift
//  MBFoundation_Tests
//
//  Created by 周翔 on 2021/9/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import MBFoundation

struct Person {
    var name: String?
    var age: Int?
}

extension Person: Then {
    
}

class ThenTest: XCTestCase {

    func testNSObjectThe() {
        
        let queue = OperationQueue().then {
            $0.name = "awesome"
            $0.maxConcurrentOperationCount = 5
        }
        
        XCTAssertEqual(queue.name, "awesome")
        XCTAssertEqual(queue.maxConcurrentOperationCount, 5)

    }
    
    func testWith() {
        let person = Person().with {
            $0.name = "xxx"
            $0.age = 18
        }
        
        XCTAssertEqual(person.name, "xxx")
        XCTAssertEqual(person.age, 18)
    }
    
    
    func testWithArray() {
        let array = [1, 2, 3].with { $0.append(4) }
        XCTAssertEqual(array, [1, 2, 3, 4])
    }
    
    func testWithDictionary() {
        let dict = ["Korea": "Seoul", "Japan": "Tokyo"].with {
          $0["China"] = "Beijing"
        }
        XCTAssertEqual(dict, ["Korea": "Seoul", "Japan": "Tokyo", "China": "Beijing"])
    }
    
    func testWithSet() {
        let set = Set(["A", "B", "C"]).with {
            $0.insert("D")
        }
        XCTAssertEqual(set, Set(["A", "B", "C", "D"]))
    }
    
    func testDo() {
        UserDefaults.standard.do {
            $0.removeObject(forKey: "username")
            $0.set("devxoul", forKey: "username")
            $0.synchronize()
        }
        XCTAssertEqual(UserDefaults.standard.string(forKey: "username"), "devxoul")
    }
    
    func testRethrows() {
        XCTAssertThrowsError(
            try NSObject().do { _ in
                throw NSError(domain: "", code: 0)
            }
        )
    }
    
}
