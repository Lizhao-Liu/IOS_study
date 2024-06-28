//
//  ArrayTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface ArrayTest : XCTestCase

@end

@implementation ArrayTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - NSArray+MBExtends

- (void)testNSArrayMBExtends {
    NSArray *array = @[@"111", @"2", @"3", @(1), @(2), @(3)];
    XCTAssertEqual([NSArray isNilOrEmpty:array], [NSArray mb_isNilOrEmpty:array]);
    XCTAssertEqual([array isNilOrEmpty], [array mb_isEmpty]);
    
    BOOL b = [NSArray mb_isNilOrEmpty:nil];
    XCTAssertTrue(b);
   
    XCTAssertEqual([array ymm_objectAtIndex:0], [array mb_objectAt:0]);
    XCTAssertEqual([array ymm_integerAtIndex:0], [array mb_integerAt:0]);
    XCTAssertEqual([array ymm_stringAtIndex:0], [array mb_stringAt:0]);
    XCTAssertEqual([array ymm_numberAtIndex:0], [array mb_numberAt:0]);
    XCTAssertEqual([array ymm_decimalNumberAtIndex:0].stringValue, [array mb_decimalNumberAt:0].stringValue);
    XCTAssertEqual([array ymm_unsignedIntegerAtIndex:0], [array mb_unsignedIntegerAt:0]);
    XCTAssertEqual([array ymm_int16AtIndex:0], [array mb_int16At:0]);
    XCTAssertEqual([array ymm_int32AtIndex:0], [array mb_int32At:0]);
    XCTAssertEqual([array ymm_int64AtIndex:0], [array mb_int64At:0]);
    XCTAssertEqual([array ymm_charAtIndex:0], [array mb_int8At:0]);
    XCTAssertEqual([array ymm_shortAtIndex:0], [array mb_int16At:0]);
    XCTAssertEqual([array ymm_floatAtIndex:0], [array mb_floatAt:0]);
    XCTAssertEqual([array ymm_doubleAtIndex:0], [array mb_doubleAt:0]);
    XCTAssertEqual([array ymm_CGFloatAtIndex:0], [array mb_CGFloatAt:0 ]);
    XCTAssertEqual([array ymm_boolAtIndex:0], [array mb_boolAt:0]);
    
    array = @[@[@1, @2], @{@"1": @(1), @"2": @(2)}];
    XCTAssertEqual([array ymm_arrayAtIndex:0], [array mb_arrayAt:0]);
    XCTAssertEqual([array ymm_dictAtIndex:1], [array mb_dictionaryAt:1]);
    
    array = @[@"{50,50},{100,100}",@"{100,100}"];
    XCTAssertEqual([array ymm_pointAtIndex:1].x, [array mb_CGPointAt:1].x);
    XCTAssertEqual([array ymm_rectAtIndex:0].size.width, [array mb_CGRectAt:0].size.width);
    XCTAssertEqual([array ymm_sizeAtIndex:1].width, [array mb_CGSizeAt:1].width);
}

#pragma mark - NSArray+MBTK_Functional

- (void)testNSArrayMBTK_Functional {
    NSArray *array = @[@"1", @"2", @"3", @(1), @(2), @(3)];
    [array hcb_each:^(id  _Nonnull obj) {
        XCTAssertNotNil(obj);
    }];
    [array mb_each:^(id _Nonnull obj) {
        XCTAssertNotNil(obj);
    }];
    
    NSArray *array1 = [array hcb_map:^id _Nullable(id  _Nonnull obj) {
        return @"111";
    }];
    NSArray *array2 = [array mb_map:^id _Nullable(id _Nonnull obj) {
        return @"111";
    }];
    XCTAssertNotNil(array2);
    
    array1 = [array hcb_flatMap:^id _Nullable(id  _Nonnull obj) {
        return @{@"2": @"222"};
    }];
    array2 = [array mb_flatMap:^id _Nullable(id _Nonnull obj) {
        return @{@"2": @"222"};
    }];
    XCTAssertNotNil(array2);
    
    array1 = [array hcb_filter:^BOOL(id  _Nonnull obj) {
        return [obj isKindOfClass:[NSNumber class]];
    }];
    array2 = [array mb_filter:^BOOL(id _Nonnull obj) {
        return [obj isKindOfClass:[NSNumber class]];
    }];
    XCTAssertNotNil(array2);
    
    id obj1 = [array hcb_reduce:@"333" block:^id _Nonnull(id  _Nonnull result, id  _Nonnull obj) {
        return [NSString stringWithFormat:@"%@%@", result, obj];
    }];
    id obj2 = [array mb_reduce:@"333" block:^id _Nonnull(id _Nonnull result, id _Nonnull obj) {
        return [NSString stringWithFormat:@"%@%@", result, obj];;
    }];
    XCTAssertNotNil(obj2);
    
    obj1 = [array hcb_first:^BOOL(id  _Nonnull obj) {
        return [obj isKindOfClass:[NSString class]] && ((NSString *)obj).intValue > 2;
    }];
    obj2 = [array mb_first:^BOOL(id _Nonnull obj) {
        return [obj isKindOfClass:[NSString class]] && ((NSString *)obj).intValue > 2;
    }];
    XCTAssertNotNil(obj2);
}

#pragma mark - NSMutableArray+MBExtends

- (void)testNSMutableArrayMBExtends {
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    
    [array1 ymm_safeAddObj:@"1"];
    [array2 mb_add:@"1"];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddObj:nil];
    [array2 mb_add:nil];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 addObjectIgnoreNil:nil];
    [array2 mb_add:nil];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddInt:1];
    [array2 mb_addWithInt:1];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddBool:true];
    [array2 mb_addWithBool:true];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddString:@"1"];
    [array2 mb_addWithString:@"1"];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddChar:2];
    [array2 mb_addWithInt8:2];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddInteger:3];
    [array2 mb_addWithInteger:3];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddUnsignedInteger:4];
    [array2 mb_addWithUnsignedInteger:4];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddCGFloat:5];
    [array2 mb_addWithCgfloat:5];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddFloat:6.0];
    [array2 mb_addWithFloat:6.0];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddPoint:CGPointZero];
    [array2 mb_addWithPoint:CGPointZero];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddSize:CGSizeZero];
    [array2 mb_addWithSize:CGSizeZero];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 ymm_safeAddRect:CGRectZero];
    [array2 mb_addWithRect:CGRectZero];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 addObjectContainNil:nil];
    [array2 mb_addContainNil:nil];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 insertObjectIgnoreNil:nil atIndex:0];
    [array2 mb_insert:nil at:0];
    XCTAssertTrue([array1 isEqualToArray:array2]);
    
    [array1 insertObjectContainNil:nil atIndex:0];
    [array2 mb_insertContainNil:nil at:0];
    XCTAssertTrue([array1 isEqualToArray:array2]);
}



- (void)testMBArrayExtends {
    {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        [array1 ymm_safeAddObj:@"1"];
        [array2 mb_add:@"1"];
        NSLog(@"%@", [array1 mb_objectAt:-1]);
        NSLog(@"%@", [array1 mb_objectAt:1]);
        XCTAssertTrue([[array1 mb_objectAt:0] isEqual:[array1 mb_objectAt:0]]);
        XCTAssertTrue([@"1" isEqual:[array1 mb_objectAt:0]]);
        
        [array1 ymm_safeAddObj:@"2"];
        [array2 mb_add:@"2"];
        XCTAssertTrue([[array1 mb_objectAt:array1.count-1] isEqual:[array1 mb_objectAt:array2.count-1]]);
        XCTAssertTrue([@"2" isEqual:[array1 mb_objectAt:array2.count-1]]);
        NSLog(@"%@", [array1 mb_objectAt:array1.count]);
        NSLog(@"%@", [array1 mb_objectAt:array2.count]);
    }
    
    {
        NSMutableArray *array1 = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        [array1 ymm_safeAddObj:@1];
        [array2 mb_add:@1];
        NSLog(@"%@", [array1 mb_objectAt:-1]);
        NSLog(@"%@", [array1 mb_objectAt:1]);
        XCTAssertTrue([[array1 mb_objectAt:0] isEqual:[array1 mb_objectAt:0]]);
        XCTAssertTrue([@1 isEqual:[array1 mb_objectAt:0]]);
        
        [array1 ymm_safeAddObj:@2];
        [array2 mb_add:@2];
        XCTAssertTrue([[array1 mb_objectAt:array1.count-1] isEqual:[array1 mb_objectAt:array2.count-1]]);
        XCTAssertTrue([@2 isEqual:[array1 mb_objectAt:array2.count-1]]);
        NSLog(@"%@", [array1 mb_objectAt:array1.count]);
        NSLog(@"%@", [array1 mb_objectAt:array2.count]);
    }
}



- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
