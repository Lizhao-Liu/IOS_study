// https://github.com/Quick/Quick
import Quick
import Nimble
import MBFoundation

class ArraySpec: QuickSpec {

    override func spec() {

        let emptyArray = Array<AnyObject>()
        let array = ["element"]

        describe("JSON") {
            it("convert to json string") {
                expect(emptyArray.mb.json).to(beAKindOf(String.self))
                expect(emptyArray.mb.jsonPretty).to(beAKindOf(String.self))
            }
            it("convert to data") {
                expect(emptyArray.mb.jsonData).to(beAKindOf(Data.self))
            }
        }

        describe("Immutable") {
            it("element") {
                expect(array.mb.anyValue(at: 0)).to(equal("element"))
                expect(emptyArray.mb.anyValue(at: 0)).to(beNil())
            }
        }
    }

}

class NSArraySpec: QuickSpec {

    override func spec() {

        let emptyArray = NSArray()
        let array = NSArray.init(object: "element")
        let stringArray = NSArray(objects: "1", "2")
        let numberArray = NSArray(object: NSNumber(value: 1))
        let arrayArray = NSArray(objects: NSArray(objects: 1, 2))
        let dictionaryArray = NSArray(objects: NSDictionary.init(dictionary: ["key1": "1", "key2": "2"]))
        let decimalArray = NSArray(objects: NSDecimalNumber(1))
        
        
        describe("JSON") {
            it("array convert to json string") {
                if let string = emptyArray.mb_jsonString() {
                    expect(string).to(beAKindOf(NSString.self))
                }
                if let string = emptyArray.mb_jsonPrettyString() {
                    expect(string).to(beAKindOf(NSString.self))
                }
            }
            it("array convert to data") {
                if let data = emptyArray.mb_jsonData() {
                    expect(data).to(beAKindOf(NSData.self))
                }
                if let data = array.mb_jsonData() {
                    expect(data).to(beAKindOf(NSData.self))
                }
            }
        }
        
        describe("Immutable") {
            it("empty") {
                expect(emptyArray.mb_isEmpty()).toEventually(beTruthy())
                expect(array.mb_isEmpty()).toEventually(beFalsy())
            }
            it("count") {
                expect(emptyArray.mb_count()) == 0
                expect(array.mb_count()) == 1
            }
            it("element") {
                expect(emptyArray.mb_object(at: 0)).to(beNil())
                expect(array.mb_object(at: 0) as? String).to(equal("element"))
            }
            it("string") {
                expect(emptyArray.mb_string(at: 0)).to(beNil())
                expect(stringArray.mb_string(at: 0)).to(beAKindOf(NSString.self))
                expect(numberArray.mb_string(at: 0)).to(beAKindOf(NSString.self))
            }
            it("number") {
                expect(emptyArray.mb_number(at: 0)).to(beNil())
                expect(stringArray.mb_number(at: 0)).to(beAKindOf(NSNumber.self))
                expect(numberArray.mb_number(at: 0)).to(beAKindOf(NSNumber.self))
            }
            it("array") {
                expect(emptyArray.mb_array(at: 0)).to(beNil())
                expect(arrayArray.mb_array(at: 0)).to(beAKindOf(NSArray.self))
            }
            it("dictionary") {
                expect(emptyArray.mb_dictionary(at: 0)).to(beNil())
                expect(dictionaryArray.mb_dictionary(at: 0)).to(beAKindOf(NSDictionary.self))
            }
            it("decimal number") {
                expect(emptyArray.mb_decimalNumber(at: 0)).to(beNil())
                expect(decimalArray.mb_decimalNumber(at: 0)).to(beAKindOf(NSDecimalNumber.self))
                expect(stringArray.mb_decimalNumber(at: 0)).to(beAKindOf(NSDecimalNumber.self))
                expect(numberArray.mb_decimalNumber(at: 0)).to(beAKindOf(NSDecimalNumber.self))
            }
            /*
            it("bool") {
                expect(emptyArray.mb_bool(at: 0, default: true)).to(beTrue())
                expect(emptyArray.mb_bool(at: 0, default: false)).to(beFalse())
                expect(numberArray.mb_bool(at: 0, default: true)).to(beAKindOf(Bool.self))
                expect(stringArray.mb_bool(at: 0, default: true)).to(beAKindOf(Bool.self))
            }
            it("integer") {
                expect(emptyArray.mb_integer(at: 0, default: 1)) == 1
                expect(numberArray.mb_integer(at: 0, default: 0)).to(beAKindOf(NSInteger.self))
                expect(stringArray.mb_integer(at: 0, default: 0)).to(beAKindOf(NSInteger.self))
            }
            it("int8") {
                expect(emptyArray.mb_int8(at: 0, default: 1)) == 1
                expect(numberArray.mb_int8(at: 0, default: 0)).to(beAKindOf(Int8.self))
                expect(stringArray.mb_int8(at: 0, default: 0)).to(beAKindOf(Int8.self))
            }
            it("int16") {
                expect(emptyArray.mb_int16(at: 0, default: 1)) == 1
                expect(numberArray.mb_int16(at: 0, default: 0)).to(beAKindOf(Int16.self))
                expect(stringArray.mb_int16(at: 0, default: 0)).to(beAKindOf(Int16.self))
            }
            it("int32") {
                expect(emptyArray.mb_int32(at: 0, default: 1)) == 1
                expect(numberArray.mb_int32(at: 0, default: 0)).to(beAKindOf(Int32.self))
                expect(stringArray.mb_int32(at: 0, default: 0)).to(beAKindOf(Int32.self))
            }
            it("int64") {
                expect(emptyArray.mb_int64(at: 0, default: 1)) == 1
                expect(numberArray.mb_int64(at: 0, default: 0)).to(beAKindOf(Int64.self))
                expect(stringArray.mb_int64(at: 0, default: 0)).to(beAKindOf(Int64.self))
            }
            it("unsigned integer") {
                expect(emptyArray.mb_unsignedInteger(at: 0, default: 1)) == 1
                expect(numberArray.mb_unsignedInteger(at: 0, default: 0)).to(beAKindOf(UInt.self))
                expect(stringArray.mb_unsignedInteger(at: 0, default: 0)).to(beAKindOf(UInt.self))
            }
            it("unsigned int8") {
                expect(emptyArray.mb_unsignedInt8(at: 0, default: 1)) == 1
                expect(numberArray.mb_unsignedInt8(at: 0, default: 0)).to(beAKindOf(UInt8.self))
                expect(stringArray.mb_unsignedInt8(at: 0, default: 0)).to(beAKindOf(UInt8.self))
            }
            it("unsigned int16") {
                expect(emptyArray.mb_unsignedInt16(at: 0, default: 1)) == 1
                expect(numberArray.mb_unsignedInt16(at: 0, default: 0)).to(beAKindOf(UInt16.self))
                expect(stringArray.mb_unsignedInt16(at: 0, default: 0)).to(beAKindOf(UInt16.self))
            }
            it("unsigned int32") {
                expect(emptyArray.mb_unsignedInt32(at: 0, default: 1)) == 1
                expect(numberArray.mb_unsignedInt32(at: 0, default: 0)).to(beAKindOf(UInt32.self))
                expect(stringArray.mb_unsignedInt32(at: 0, default: 0)).to(beAKindOf(UInt32.self))
            }
            it("unsigned int64") {
                expect(emptyArray.mb_unsignedInt64(at: 0, default: 1)) == 1
                expect(numberArray.mb_unsignedInt64(at: 0, default: 0)).to(beAKindOf(UInt64.self))
                expect(stringArray.mb_unsignedInt64(at: 0, default: 0)).to(beAKindOf(UInt64.self))
            }
             
            it("float") {
                expect(emptyArray.mb_float(at: 0, default: 1.0)) == 1.0
                expect(numberArray.mb_float(at: 0, default: 0.0)).to(beAKindOf(Float.self))
                expect(stringArray.mb_float(at: 0, default: 0.0)).to(beAKindOf(Float.self))
            }
            it("double") {
                expect(emptyArray.mb_double(at: 0, default: 1.0)) == 1.0
                expect(numberArray.mb_double(at: 0, default: 0.0)).to(beAKindOf(Double.self))
                expect(stringArray.mb_double(at: 0, default: 0.0)).to(beAKindOf(Double.self))
            }
            it("cgfloat") {
                expect(emptyArray.mb_CGFloat(at: 0, default: 1.0)) == 1.0
                expect(numberArray.mb_CGFloat(at: 0, default: 0.0)).to(beAKindOf(CGFloat.self))
                expect(stringArray.mb_CGFloat(at: 0, default: 0.0)).to(beAKindOf(CGFloat.self))
            }
             */
            it("cgpoint") {
                expect(emptyArray.mb_CGPoint(at: 0)).to(equal(CGPoint.zero))
                expect(numberArray.mb_CGPoint(at: 0)).to(beAKindOf(CGPoint.self))
                expect(stringArray.mb_CGPoint(at: 0)).to(beAKindOf(CGPoint.self))
            }
            it("cgsize") {
                expect(emptyArray.mb_CGSize(at: 0)).to(equal(CGSize.zero))
                expect(numberArray.mb_CGSize(at: 0)).to(beAKindOf(CGSize.self))
                expect(stringArray.mb_CGSize(at: 0)).to(beAKindOf(CGSize.self))
            }
            it("cgrect") {
                expect(emptyArray.mb_CGRect(at: 0)).to(equal(CGRect.zero))
                expect(numberArray.mb_CGRect(at: 0)).to(beAKindOf(CGRect.self))
                expect(stringArray.mb_CGRect(at: 0)).to(beAKindOf(CGRect.self))
            }
        }
        
        describe("Generic Covariant") {
            it("each") {
                array.mb_each { (_ e: Any) in
                    expect(e).to(beAKindOf(NSString.self))
                }
            }
            it("map") {
                let mapArray = array.mb_map { (_ e: Any) -> Any? in
                    return (e is String) ? "map " + (e as! String) : nil
                }
                expect(mapArray).to(beAKindOf(NSArray.self))
                expect(mapArray[0]).to(beAKindOf(String.self))
                expect((mapArray[0] as! String).hasPrefix("map ")).to(beTrue())
            }
            it("flat-map") {
                let flatMapStringArray = stringArray.mb_flatMap { (_ e: Any) -> Any? in
                    e
                }
                let flatMapArray = arrayArray.mb_flatMap { (_ e: Any) -> Any? in
                    e
                }
                let flatMapDictionaryArray = dictionaryArray.mb_flatMap { (_ e: Any) -> Any? in
                    e
                }
                expect(flatMapStringArray.count) == 2
                expect(flatMapArray.count) == 2
                expect(flatMapDictionaryArray.count) == 2
            }
            it("filter") {
                let filterArray = stringArray.mb_filter { (_ e: Any) -> Bool in
                    (e is String) ? (e as! String) == "1" : false
                }
                expect(filterArray.count) == 1
                expect(filterArray[0] as? String) == "1"
            }
            it("reduce") {
                let append = stringArray.mb_reduce("0") { (_ e1: Any, _ e2: Any) -> Any in
                    if let e1 = e1 as? String, let e2 = e2 as? String {
                        return e1 + e2
                    }
                    return ""
                }
                expect((append as! String)) == "012"
            }
            it("first") {
                let target1 = stringArray.mb_first { (_ e: Any) -> Bool in
                    if let e = e as? String {
                        return e == "2"
                    }
                    return false
                }
                expect((target1 as! String)) == "2"
                let target2 = stringArray.mb_first { (_ e: Any) -> Bool in
                    if let e = e as? String {
                        return e == "3"
                    }
                    return false
                }
                expect(target2).to(beNil())
            }
        }
    }

}

class NSMutableArraySpec: QuickSpec {

    override func spec() {

        let array = NSMutableArray()

        afterEach {
            array.removeAllObjects()
        }

        describe("add") {

            afterEach {
                array.removeAllObjects()
            }

            it("string") {
                array.mb_add(string: "this is string")
                expect(array[0]).to(beAKindOf(String.self))
            }
            it("bool") {
                array.mb_add(bool: true)
                array.mb_add(bool: false)
                expect(array[0]).to(beAKindOf(Bool.self))
                expect(array[1] as? Bool).to(beFalse())
            }
            it("int") {
                array.mb_add(int: 1)
                expect(array[0] as? Int) == 1
            }
            it("int8") {
                array.mb_add(int8: 1)
                expect(array[0] as? Int8) == 1
            }
            it("integer") {
                array.mb_add(integer: -1)
                expect(array[0] as? NSInteger) == -1
            }
            it("uint") {
                array.mb_add(unsignedInteger: 1)
                expect(array[0] as? UInt) == 1
            }
            it("float") {
                array.mb_add(float: 1.1)
                expect(array[0] as? Float) == 1.1
            }
            it("double") {
                array.mb_add(double: 1.123456789)
                expect(array[0] as? Double) == 1.123456789
            }
            it("cgfloat") {
                array.mb_add(cgfloat: 1.12)
                expect(array[0]).to(beAKindOf(CGFloat.self))
            }
            it("cgpoint") {
                array.mb_add(point: .zero)
                expect(array[0] as? CGPoint).to(beNil())
                array.mb_add(point: CGPointFromString("{0,0}"))
                expect(CGPointFromString(array[1] as! String)) == .zero
            }
            it("cgsize") {
                array.mb_add(size: .zero)
                expect(array[0] as? CGSize).to(beNil())
                array.mb_add(size: CGSizeFromString("{0,0}"))
                expect(CGSizeFromString(array[1] as! String)) == .zero
            }
            it("cgrect") {
                array.mb_add(rect: .zero)
                expect(array[0] as? CGRect).to(beNil())
                array.mb_add(rect: CGRectFromString("{0,0,0,0}"))
                expect(CGRectFromString(array[1] as! String)) == .zero
            }
            it("contain nil") {
                array.mb_addContainNil(nil)
                expect(array[0] as? NSNull).to(beAKindOf(NSNull.self))
                array.mb_addContainNil("1")
                expect(array[1] as? String).to(beAKindOf(String.self))
            }
        }

        describe("insert") {
            it("") {
                array.mb_insert(nil, at: 0)
                array.mb_insert("1", at: 0)
                expect(array[0] as? String) == "1"
            }
            it("contain nil") {
                array.mb_insertContainNil(nil, at: 0)
                expect(array.count) == 1
                array.mb_insertContainNil("1", at: 1)
                expect(array[1] as? String).to(beAKindOf(String.self))
            }
        }

        describe("remove") {
            it("") {
                array.mb_insert("1", at: 0)
                expect(array.count) == 1
                array.mb_remove(at: 0)
                expect(array.count) == 0
            }
            it("all") {
                array.mb_insert("1", at: 0)
                expect(array.count) == 1
                array.mb_removeAll()
                expect(array.count) == 0
            }
        }

        describe("replace") {
            it("") {
                array.add("old")
                array.mb_replace(at: 0, with: "new")
                expect(array[0] as? String) == "new"
                array.mb_replace(at: 0, with: nil)
                expect(array[0] as? String) == "new"
            }
        }

    }

}

// class TableOfContentsSpec: QuickSpec {
//    override func spec() {
//        describe("these will fail") {
//
//            it("can do maths") {
//                expect(1) == 2
//            }
//
//            it("can read") {
//                expect("number") == "string"
//            }
//
//            it("will eventually fail") {
//                expect("time").toEventually( equal("done") )
//            }
//
//            context("these will pass") {
//
//                it("can do maths") {
//                    expect(23) == 23
//                }
//
//                it("can read") {
//                    expect("🐮") == "🐮"
//                }
//
//                it("will eventually pass") {
//                    var time = "passing"
//
//                    DispatchQueue.main.async {
//                        time = "done"
//                    }
//
//                    waitUntil { done in
//                        Thread.sleep(forTimeInterval: 0.5)
//                        expect(time) == "done"
//
//                        done()
//                    }
//                }
//            }
//        }
//    }
// }
