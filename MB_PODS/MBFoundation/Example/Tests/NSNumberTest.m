//
//  NSNumberTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface NSNumberTest : XCTestCase

@end

@implementation NSNumberTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

///// 时间戳转成时间
//- (NSDate *)dateValue;
//
///// 数字格式化带单位金额
//- (NSString *)formatAmountToSting;
//
///// 数字格式化，分转元
//- (NSString *)formatFeeToSting;
//
//// 保留两位小数 分转元
//- (NSString *)formatFeeToStingWith2Float;


- (void)testNumber {
    NSDate *date1 = [@(1637829831716) dateValue];
    NSDate *date2 = [@(1637829831716) mb_formatToSince1970Date];
    XCTAssertNotNil(date1);
    XCTAssertNotNil(date2);
    
    NSString *fee1 = [@(-1234) formatAmountToSting];
    NSString *fee2 = [@(-1234) mb_formatCentToYuanWithCN];
    XCTAssertTrue([fee1 isEqualToString:fee2]);
    
    NSString *fee3 = [@(-1234) formatFeeToSting];
    NSString *fee4 = [@(-1234) mb_formatCentToYuanMax2];
    XCTAssertTrue([fee3 isEqualToString:fee4]);
    
    NSString *fee5 = [@(-1234) formatFeeToStingWith2Float];
    NSString *fee6 = [@(-1234) mb_formatCentToYuan2];
    XCTAssertTrue([fee5 isEqualToString:fee6]);
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
