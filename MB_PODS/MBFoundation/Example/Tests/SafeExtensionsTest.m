//
//  SafeExtensionsTest.m
//  MBFoundation_Tests
//
//  Created by 别施轩 on 2021/8/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;

@interface SafeExtensionsTest : XCTestCase

@end

@implementation SafeExtensionsTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}
 
- (void)testNSArrayMBExtends {
    NSString *a = @"asf1234123qwe12341235qwe";
    NSString *r = @"[0-9]+";
    
    NSArray *result = [NSRegularExpression matchesRegularExpression:r checkString:a];
    XCTAssert(result.count == 2, @"matchesRegularExpression error");
    
    a = @"asf1234123qwe12341a235qwe";
    
    NSArray *result2 = [NSRegularExpression matchesRegularExpression:r checkString:a];
    XCTAssert(result2.count == 3, @"matchesRegularExpression error");
}

- (void)testArrayInitHapppy {
    NSDate *aDate = [NSDate distantFuture];
    NSValue *aValue = @(5);
    NSString *aString = @"hello";
    NSArray *array = @[aDate, aValue, aString];
    XCTAssertNotNil(array);
    
    
    NSString *strings[3];
    strings[0] = @"First";
    strings[1] = @"second";
    strings[2] = @"Third";
    NSArray *array2 = [NSArray arrayWithObjects:strings count:3];
    XCTAssertNotNil(array2);
}

- (void)testArrayInitSad1 {
    NSDate *aDate = [NSDate distantFuture];
    NSValue *aValue = nil;
    NSString *aString = @"hello";
    NSArray *array = @[aDate, aValue, aString];
    array = array.mutableCopy;
    XCTAssertNotNil(array);
}

- (void)testMutableArrayOther {
    NSDate *aDate = [NSDate distantFuture];
    NSValue *aValue = @(5);
    NSString *aString = @"hello";
    NSArray *array = @[aDate, aValue, aString];
    
    NSString *_nil = nil;
    NSString *null = NULL;
    
    
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:array];
    NSMutableArray *oldArr = [newArr mutableCopy];
    [newArr addObject:_nil];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr insertObject:@4 atIndex:4];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr insertObject:_nil atIndex:3];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr replaceObjectAtIndex:3 withObject:@3];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr replaceObjectAtIndex:2 withObject:_nil];
    XCTAssertEqual(newArr.count, oldArr.count);
    
    [newArr addObject:null];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr insertObject:@4 atIndex:4];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr insertObject:null atIndex:3];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr replaceObjectAtIndex:3 withObject:@3];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr replaceObjectAtIndex:2 withObject:null];
    XCTAssertEqual(newArr.count, oldArr.count);
    
    
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr addObject:@"a"];
    XCTAssertEqual(newArr.count, oldArr.count + 1);
    [newArr removeObjectAtIndex:oldArr.count];
    XCTAssertEqual(newArr.count, oldArr.count);
    [newArr insertObject:@"a" atIndex:1];
    XCTAssertEqual(newArr.count, oldArr.count + 1);
    [newArr replaceObjectAtIndex:1 withObject:@"b"];
    XCTAssertEqual(@"b", newArr[1]);
    
}


- (void)testDicInitHapppy {
    NSString *key = @"key";
    NSNumber *value = @(5);
    NSDictionary *dic = @{key: value};
    XCTAssertNotNil(dic);


    NSString *keys[1];
    NSString *vaules[1];
    keys[0] = @"key";
    vaules[0] = @"vaule";
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjects:vaules forKeys:keys count:2];
    XCTAssertNotNil(dic2);
    
    NSString *_nil = nil;
    NSDictionary *dic3 = @{@"a": @"b", _nil: @"a", @"c": _nil};
    XCTAssertNotNil(dic3);
    
    NSString *null = NULL;
    NSDictionary *dic4 = @{@"a": @"b", null: @"a", @"c": null};
    XCTAssertNotNil(dic4);
}

- (void)testDicInitSad1 {
    {
        NSString *key = @"key";
        NSString *value = nil;
        NSDictionary *dic = @{key: value};
        XCTAssertNotNil(dic);
    }
    {
        NSString *key = @"nil";
        NSString *value = @"vaule";
        NSDictionary *dic = @{key: value};
        XCTAssertNotNil(dic);
    }
    {
        NSString *key = nil;
        NSString *value = nil;
        NSDictionary *dic = @{key: value};
        XCTAssertNotNil(dic);
    }
}

- (void)testDicInitSad2 {
    {
        NSString *keys[1];
        NSString *vaules[1];
        keys[0] = nil;
        vaules[0] = @"vaule";
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjects:vaules forKeys:keys count:1];
        XCTAssertNotNil(dic2);
    }
    {
        NSString *keys[1];
        NSString *vaules[1];
        keys[0] = @"key";
        vaules[0] = nil;
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjects:vaules forKeys:keys count:1];
        XCTAssertNotNil(dic2);
    }
    {
        NSString *keys[1];
        NSString *vaules[1];
        keys[0] = nil;
        vaules[0] = nil;
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjects:vaules forKeys:keys count:1];
        XCTAssertNotNil(dic2);
    }
}

- (void)testDictionaryOther {
    NSString *key = @"key";
    NSNumber *value = @(5);
    NSDictionary *oldDic = @{key: value};
    XCTAssertNotNil(oldDic);
    
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
    XCTAssertEqual(newDic.count, oldDic.count);
    NSString *_nil = nil;
    [newDic removeObjectForKey:_nil];
    XCTAssertEqual(newDic.count, oldDic.count);
    [newDic setObject:_nil forKey:@"key"];
    XCTAssertEqual(newDic.count, oldDic.count);
    [newDic setObject:@"v" forKey:_nil];
    XCTAssertEqual(newDic.count, oldDic.count);
    [newDic setObject:_nil forKey:_nil];
    XCTAssertEqual(newDic.count, oldDic.count);
    NSString *null = NULL;
    [newDic removeObjectForKey:null];
    XCTAssertEqual(newDic.count, oldDic.count);
    [newDic setObject:null forKey:@"key"];
    XCTAssertEqual(newDic.count, oldDic.count);
    [newDic setObject:@"v" forKey:null];
    XCTAssertEqual(newDic.count, oldDic.count);
    [newDic setObject:null forKey:null];
    XCTAssertEqual(newDic.count, oldDic.count);
    
    
    [newDic setObject:@"newV" forKey:@"key"];
    XCTAssertEqual(newDic[@"key"], @"newV");
    [newDic setObject:@"v" forKey:@"key"];
    XCTAssertEqual(newDic[@"key"], @"v");
    
}


- (void)testStrings {
    NSString *str = @"key";
    XCTAssertEqual([str characterAtIndex:10], 0);
    XCTAssertEqual([str substringWithRange:NSMakeRange(10, 1)], nil);
    XCTAssertEqual([str characterAtIndex:1], 'e');
    XCTAssertTrue([[str substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"e"]);
    NSString *_nil = nil;
    XCTAssertTrue([str isEqualToString:[str stringByAppendingString:_nil]]);
    NSString *str22 = [[NSString alloc] initWithString:str];
    XCTAssertTrue([str22 isEqualToString:[str22 stringByAppendingString:_nil]]);
    NSString *str33 = [NSString stringWithString:[str mutableCopy]];
    XCTAssertTrue([str33 isEqualToString:[str33 stringByAppendingString:_nil]]);
    
    NSMutableString *newStr = [NSMutableString stringWithString:str];
    [newStr appendString:_nil];
    XCTAssertTrue([newStr isEqualToString: str]);
    [newStr appendFormat:_nil, _nil];
    XCTAssertTrue([newStr isEqualToString: str]);
    [newStr setString:_nil];
    XCTAssertTrue([newStr isEqualToString: str]);
    [newStr insertString:_nil atIndex:0];
    XCTAssertTrue([newStr isEqualToString: str]);
    [newStr insertString:@"a" atIndex:10];
    XCTAssertTrue([newStr isEqualToString: str]);
    
    XCTAssertTrue([[@"" stringByAppendingString:_nil] isEqualToString: @""]);
    
    
    [newStr appendString:@"123"];
    XCTAssertTrue([newStr hasSuffix:@"123"]);
    [newStr appendFormat:@"%@", @"456"];
    XCTAssertTrue([newStr hasSuffix:@"456"]);
    [newStr setString:@"789"];
    XCTAssertTrue([newStr isEqualToString:@"789"]);
    [newStr insertString:@"0" atIndex:0];
    XCTAssertTrue([newStr isEqualToString:@"0789"]);
    
    XCTAssertTrue([[@"aa" stringByAppendingString:@"bb"] isEqualToString: @"aabb"]);
    
    const char *charS = NULL;
    NSString *cString = [NSString stringWithCString:charS encoding:NSUTF8StringEncoding];
    XCTAssertEqual(cString, nil);
}



- (void)testNumbers {
    NSNumber *number = @12;
    NSNumber *null = nil;
    XCTAssertNotEqual(number, null);
    XCTAssertEqual(NSOrderedAscending, [number compare:null]);
    
    XCTAssertFalse([number isEqualToNumber:null]);
    
    
    XCTAssertEqual(number, @12);
    XCTAssertEqual(NSOrderedSame, [number compare:@12]);
}



// MARK: - 以下函数未上线，所以注释掉UT -

//        [self safe_swizzleMethod:@selector(safe_removeObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
//        [self safe_swizzleMethod:@selector(safe_objectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
//        [self safe_swizzleMethod:@selector(initWithObjects_safe:count:) tarClass:@"__NSPlaceholderArray" tarSel:@selector(initWithObjects:count:)];
//        [self safe_swizzleMethod:@selector(safe_arrayByAddingObject:) tarClass:@"__NSArrayI" tarSel:@selector(arrayByAddingObject:)];
//        [self safe_swizzleMethod:@selector(safe_objectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
//        [self safe_swizzleMethod:@selector(safe_objectAtIndexedSubscriptForNSArrayI:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndexedSubscript:)];
//        [self safe_swizzleMethod:@selector(safe_objectAtIndexedSubscriptForNSSingleObjectArrayI:) tarClass:@"__NSSingleObjectArrayI" tarSel:@selector(objectAtIndex:)];
//        [self safe_swizzleMethod:@selector(safe_objectAtIndexForNSArray0:) tarClass:@"__NSArray0" tarSel:@selector(objectAtIndex:)];


//- (void)testAlphaArrayMethod {
//    {
//        NSString *strings[3];
//        strings[0] = @"First";
//        strings[1] = nil;
//        strings[2] = @"Third";
//
//        NSArray *array2 = [NSArray arrayWithObjects:strings count:3];
//        XCTAssertNotNil(array2);
//
//        NSString *_nil = nil;
//        NSArray *array3 = @[@"a", _nil, @"b"];
//        XCTAssertNotNil(array3);
//
//        {
//            NSString *vaules[2];
//            vaules[0] = @"vaule";
//            vaules[1] = NULL;
//            NSArray *array4 = [[NSArray alloc] initWithObjects:vaules count:2];
//            XCTAssertNotNil(array4);
//        }
//    }
//
//
//    {
//        NSDate *aDate = [NSDate distantFuture];
//        NSValue *aValue = @(5);
//        NSString *aString = @"hello";
//        NSArray *array = @[aDate, aValue, aString];
//        NSString *_nil = nil;
//        XCTAssertEqual(_nil, array[3]);
//        XCTAssertEqual([array objectAtIndex:3], array[3]);
//        XCTAssertEqual([array objectAtIndexedSubscript:3], array[3]);
//        NSMutableArray *newArr = [NSMutableArray arrayWithArray:array];
//        XCTAssertEqual(_nil, newArr[3]);
//        XCTAssertEqual([newArr objectAtIndex:3], newArr[3]);
//        XCTAssertEqual([newArr objectAtIndexedSubscript:3], newArr[3]);
//
//
//        NSArray *array2 = @[];
//        XCTAssertEqual(_nil, array2[0]);
//        XCTAssertEqual([array2 objectAtIndex:1], array2[2]);
//        XCTAssertEqual([array2 objectAtIndexedSubscript:3], array2[4]);
//        XCTAssertEqual(_nil, array2[5]);
//        XCTAssertEqual([array2 objectAtIndex:6], array2[7]);
//        XCTAssertEqual([array2 objectAtIndexedSubscript:8], array2[9]);
//
//        NSArray *array0 = [[NSArray alloc]init];
//        XCTAssertEqual(_nil, [array0 objectAtIndex:0]);
//        XCTAssertEqual(_nil, [array0 objectAtIndex:1]);
//
//        XCTAssertEqual([@[] objectAtIndex:0], nil);
//    }
//
//    {
//        NSDate *aDate = [NSDate distantFuture];
//        NSValue *aValue = @(5);
//        NSString *aString = @"hello";
//        NSArray *array = @[aDate, aValue, aString];
//
//        XCTAssertEqual([array objectAtIndex:3], nil);
//        XCTAssertEqual(array[3], nil);
//        NSString *_nil = nil;
//        NSString *null = NULL;
//        XCTAssertEqual(array, [array arrayByAddingObject:_nil]);
//        XCTAssertEqual(array, [array arrayByAddingObject:null]);
//
//        NSArray<NSString *> *strings = [@"" componentsSeparatedByString:@"."];
//        long long code = [strings[0] integerValue] * 10000 + [strings[1] integerValue] * 100 + [strings[2] integerValue];
//        XCTAssertEqual(code, 0);
//    }
//
//    {
//
//        NSDate *aDate = [NSDate distantFuture];
//        NSValue *aValue = @(5);
//        NSString *aString = @"hello";
//        NSArray *array = @[aDate, aValue, aString];
//
//        NSString *_nil = nil;
//        NSString *null = NULL;
//
//
//        NSMutableArray *newArr = [NSMutableArray arrayWithArray:array];
//        NSMutableArray *oldArr = [newArr mutableCopy];
//        [newArr addObject:_nil];
//        XCTAssertEqual(newArr.count, oldArr.count);
//        [newArr insertObject:@4 atIndex:4];
//        XCTAssertEqual(newArr.count, oldArr.count);
//        [newArr insertObject:_nil atIndex:3];
//        XCTAssertEqual(newArr.count, oldArr.count);
//        [newArr removeObjectAtIndex:4];
//        XCTAssertEqual(newArr.count, oldArr.count);
//        [newArr removeObjectAtIndex:4];
//        XCTAssertEqual(newArr.count, oldArr.count);
//
//    }
//}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
