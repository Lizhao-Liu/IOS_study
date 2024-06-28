//
//  NSDataTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface NSDataTest : XCTestCase

@end

@implementation NSDataTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

//- (NSString *)UTF8String;
//- (NSString *)hexString;
//- (id)JSONObject;
//- (NSString *)base64String;
//- (NSString *)base64Filename;
//- (NSString *)hmacBase64String;
//+ (instancetype)dataWithBase64String:(NSString *)string;
//- (NSData *)zipCompressed;
//- (NSData *)zipUnCompressed;
//- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
//- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
//- (NSString *)md5;

- (void)testNSData {
    NSData *data = [@"1234qwer&*()" mb_dataValue];
    NSString *str1 = [data UTF8String];
    NSString *str2 = [data mb_utf8String];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    str1 = [data hexString];
    str2 = [data mb_hexString];
    XCTAssertTrue([str1 isEqualToString:str2]);
    
    NSDictionary *dic = @{@"1": @"1", @"2": @"2"};
    data = [dic mb_jsonData];
    NSDictionary *d1 = [data JSONObject];
    NSDictionary *d2 = [data mb_jsonValueDecoded];
    XCTAssertNotNil(d2);
    
    str1 = [data base64String];
    str2 = [data mb_base64EncodedString];
    NSString *str3 = [data base64Filename];
    NSString *str4 = [data hmacBase64String];
    XCTAssertTrue([str1 isEqualToString:str2]);
    XCTAssertNotNil(str3);
    XCTAssertNotNil(str4);
    
    data = [NSData dataWithBase64String:str1];
    NSData *data1 = [NSData mb_dataWithBase64EncodedString:str1];
    NSLog(@"data ---- %@", data);
    NSLog(@"data1 ---- %@", data1);
    XCTAssertNotNil(data1);
    
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
