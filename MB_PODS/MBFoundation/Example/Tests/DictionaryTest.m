//
//  DictionaryTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface DictionaryTest : XCTestCase

@end

@implementation DictionaryTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - NSDictionary+MBTK_Functional
- (void)testNSDictionaryMBTK_Functional {
    NSDictionary *dic = @{@"1": @(1), @"2": @(2), @"3": @(3)};
    [dic hcb_each:^(id  _Nonnull key, id  _Nonnull obj) {
        XCTAssertTrue([key isKindOfClass:[NSString class]]);
        XCTAssertTrue([obj isKindOfClass:[NSNumber class]]);
    }];
    
    [dic mb_each:^(id _Nonnull key, id _Nullable obj) {
        XCTAssertTrue([key isKindOfClass:[NSString class]]);
        XCTAssertTrue([obj isKindOfClass:[NSNumber class]]);
    }];
    
    NSDictionary *dic1 = [dic hcb_map:^id _Nullable(id  _Nonnull key, id  _Nonnull obj) {
        NSNumber *newObj = [[NSNumber alloc] initWithInt:((NSNumber *)obj).intValue + 2];
        return newObj;
    }];
    NSDictionary *dic2 = [dic mb_map:^id _Nullable(id _Nonnull key, id _Nullable obj) {
        NSNumber *newObj = [[NSNumber alloc] initWithInt:((NSNumber *)obj).intValue + 2];
        return newObj;
    }];
    XCTAssertNotNil(dic1);
    XCTAssertNotNil(dic2);
    
    NSDictionary *dic3 = [dic hcb_filter:^BOOL(id  _Nonnull key, id  _Nonnull obj) {
        return ((NSNumber *)obj).intValue > 1;
    }];
    NSDictionary *dic4 = [dic mb_filter:^BOOL(id  _Nonnull key, id  _Nonnull obj) {
        return ((NSNumber *)obj).intValue > 1;
    }];
    XCTAssertNotNil(dic3);
    XCTAssertNotNil(dic4);
}

#pragma mark - Dictionary+MBExtends
- (void)testDictionaryMBExtends {
    NSDictionary *dic = @{@"1": @(1), @"2": @(2), @"3": @(3)};
    id obj1 = [dic ymm_objectForKey:@"1"];
    id obj2 = [dic mb_objectForKey:@"1"];
    XCTAssertTrue([obj1 isEqual:obj2]);
    XCTAssertNil([dic mb_objectForKey:nil]);
    
    XCTAssertTrue([dic ymm_integerForKey:@"1"] == [dic mb_integerForKey:@"1"]);
    
    NSString *str1 = [dic ymm_stringForKey:@"1"];
    NSString *str2 = [dic mb_stringForKey:@"1"];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [dic jsonStringEncoded];
    str2 = [dic mb_jsonString];
    XCTAssertTrue([str1 containsString:@"\"1\":1"]);
    XCTAssertTrue([str2 containsString:@"\"1\":1"]);
    XCTAssertTrue([str1 containsString:@"\"2\":2"]);
    XCTAssertTrue([str2 containsString:@"\"2\":2"]);
    XCTAssertTrue([str1 containsString:@"\"3\":3"]);
    XCTAssertTrue([str2 containsString:@"\"3\":3"]);

    dic = @{@"1": @[@1, @2, @3], @"2": @(2), @"3": @(3)};
    XCTAssertTrue([[dic mb_arrayForKey:@"1"] isKindOfClass:[NSArray class]]);
    
    dic = @{@"1": @{@"qwer": @"1234"}, @"2": @(2), @"3": @"3"};
    XCTAssertTrue([[dic mb_dictionaryForKey:@"1"] isKindOfClass:[NSDictionary class]]);
    
    id obj3 = [dic objectForKeyIgnorNil:@"4"];
    id obj4 = [dic mb_objectForKeyIgnoreNil:@"4"];
    XCTAssertNil(obj3);
    XCTAssertNil(obj4);
    
    XCTAssertTrue([dic ymm_hasKey:@"1"] == [dic mb_isContain:@"1"]);
    
    NSDecimalNumber *num1 = [dic ymm_decimalNumberForKey:@"3"];
    NSDecimalNumber *num2 = [dic mb_decimalNumberForKey:@"3"];
    NSNumber *number3 = [dic ymm_numberForKey:@"3"];
    NSNumber *number4 = [dic mb_numberForKey:@"3"];
    XCTAssertTrue(num1.integerValue == num2.integerValue);
    XCTAssertTrue(number3.integerValue == number4.integerValue);
    
    dic = @{@"1": @(-1)};
    NSUInteger num3 = [dic ymm_unsignedIntegerForKey:@"1"];
    NSUInteger num4 = [dic mb_unsignedIntegerForKey:@"1"];
    long long num5 = [dic ymm_longLongForKey:@"1"];
    long long num6 = [dic mb_int64ForKey:@"1"];
    unsigned long long num7 = [dic ymm_unsignedLongLongForKey:@"1"];
    unsigned long long num8 = [dic mb_unsignedInt64ForKey:@"1"];
    XCTAssertTrue(num3 == num4);
    XCTAssertTrue(num5 == num6);
    XCTAssertTrue(num7 == num8);
    
    dic = @{@"1": @(true), @"2": @(false), @"3": @(3), @"4": @"A"};
    XCTAssertTrue([dic ymm_boolForKey:@"1"] == [dic mb_boolForKey:@"1"]);
    
    int16_t n1 = [dic ymm_int16ForKey:@"3"];
    int16_t n2 = [dic mb_int8ForKey:@"3"];
    int32_t n3 = [dic ymm_int32ForKey:@"3"];
    int32_t n4 = [dic mb_int32ForKey:@"3"];
    int64_t n5 = [dic ymm_int64ForKey:@"3"];
    int64_t n6 = [dic mb_int64ForKey:@"3"];
    short n7 = [dic ymm_shortForKey:@"3"];
    long long n8 = [dic ymm_longLongForKey:@"3"];
    XCTAssertTrue(n1 == n2);
    XCTAssertTrue(n3 == n4);
    XCTAssertTrue(n5 == n6);
    XCTAssertTrue(n2 == n7);
    XCTAssertTrue(n6 == n8);
    
    char cha1 = [dic ymm_charForKey:@"4"];
    char cha2 = [dic mb_int8ForKey:@"4"];
    XCTAssertTrue(cha1 == cha2);
    
    dic = @{@"1": @(3.14), @"2": @(3.141596278765418687)};
    float f1 = [dic ymm_floatForKey:@"1"];
    float f2 = [dic mb_floatForKey:@"1"];
    double d1 = [dic ymm_doubleForKey:@"2"];
    double d2 = [dic mb_doubleForKey:@"2"];
    CGFloat cgf1 = [dic ymm_CGFloatForKey:@"1"];
    CGFloat cgf2 = [dic mb_CGFloatForKey:@"1"];
    XCTAssertTrue(f1 == f2);
    XCTAssertTrue(d1 == d2);
    XCTAssertTrue(cgf1 == cgf2);
    
    dic = @{@"1": @"{50,50},{100,100}", @"2": @"{100,100}"};
    CGPoint p1 = [dic ymm_pointForKey:@"2"];
    CGPoint p2 = [dic mb_CGPointForKey:@"2"];
    CGRect r1 = [dic ymm_rectForKey:@"1"];
    CGRect r2 = [dic mb_CGRectForKey:@"1"];
    XCTAssertTrue(p1.x == p2.x);
    XCTAssertTrue(p1.y == p2.y);
    XCTAssertTrue(r1.origin.x == r2.origin.x);
    XCTAssertTrue(r1.size.width == r2.size.width);
    
    NSData *data1 = [dic JSONData];
    NSData *data2 = [dic mb_jsonData];
    NSLog(@"data1--- %@", data1);
    NSLog(@"data2--- %@", data2);
    XCTAssertNotNil(data1);
    XCTAssertNotNil(data2);
    
    NSString *string1 = [dic URLEncodingString];
    NSString *string2 = [dic mb_URLEncodingString];
    NSString *string3 = [dic URLParamsString];
    NSString *string4 = [dic mb_URLParamsString];
    XCTAssertTrue([string1 isEqualToString:string2]);
    XCTAssertTrue([string3 isEqualToString:string4]);
    
    XCTAssertTrue([NSDictionary isNilOrEmpty:dic] == [NSDictionary mb_isNilOrEmpty:dic]);
    XCTAssertTrue([dic isNilOrEmpty] == [dic mb_isEmpty]);
    XCTAssertTrue([NSDictionary mb_isNilOrEmpty:nil]);
    
}

#pragma mark - NSMutableDictionary+MBExtends
- (void)testMutableDictionaryMBExtends {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic ymm_setObj:@"1" forKey:@"1"];
    [dic mb_setObject:@"2" forKey:@"2"];
    XCTAssertTrue(dic.count == 2);
    
    [dic ymm_setString:@"3" forKey:@"3"];
    [dic mb_setString:@"4" forKey:@"4"];
    [dic ymm_setBool:true forKey:@"5"];
    [dic mb_setBool:false forKey:@"6"];
    [dic ymm_setInt:123 forKey:@"7"];
    [dic mb_setInt:123 forKey:@"8"];
    [dic ymm_setInteger:123 forKey:@"9"];
    [dic mb_setInteger:123 forKey:@"10"];
    [dic ymm_setUnsignedInteger:123 forKey:@"11"];
    [dic mb_setunsignedInteger:123 forKey:@"12"];
    [dic ymm_setCGFloat:123.f forKey:@"13"];
    [dic mb_setCGFloat:123.f forKey:@"14"];
    [dic ymm_setChar:123 forKey:@"15"];
    [dic mb_setChar:123 forKey:@"16"];
    [dic ymm_setFloat:123.123 forKey:@"17"];
    [dic mb_setFloat:123.123 forKey:@"18"];
    [dic ymm_setDouble:123.123 forKey:@"19"];
    [dic mb_setDouble:123.123 forKey:@"20"];
    [dic ymm_setLongLong:123 forKey:@"21"];
    [dic mb_setLongLong:123 forKey:@"22"];
    [dic ymm_setPoint:CGPointMake(100, 100) forKey:@"23"];
    [dic mb_setCGPoint:CGPointMake(100, 100) forKey:@"24"];
    [dic ymm_setSize:CGSizeMake(100, 100) forKey:@"25"];
    [dic mb_setCGSize:CGSizeMake(100, 100) forKey:@"26"];
    [dic ymm_setRect:CGRectMake(0, 0, 100, 100) forKey:@"27"];
    [dic mb_setCGRect:CGRectMake(0, 0, 100, 100) forKey:@"28"];
    [dic setObjectContainNil:nil forKey:@"29"];
    [dic mb_setObjectContainNil:nil forKey:@"30"];
    [dic setObjectIgnoreNil:nil forKey:@"31"];
    [dic mb_setObjectIgnoreNil:nil forKey:@"32"];
    XCTAssertTrue(dic.count == 30);
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
