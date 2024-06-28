//
//  SortDescriptorTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface Person : NSObject

@property (nonatomic, assign) NSInteger age;

@end

@implementation Person

- (instancetype)initWithAge:(NSInteger)age {
    self = [super init];
    if (self) {
        self.age = age;
    }
    return self;
}

@end

@interface SortDescriptorTest : XCTestCase

@end

@implementation SortDescriptorTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSortDescriptor {
    Person *one = [[Person alloc] initWithAge:20];
    Person *two = [[Person alloc] initWithAge:18];
    Person *three = [[Person alloc] initWithAge:22];
    NSArray *array1 = @[one, two, three];
    NSArray *array2 = @[three, one, two];
    NSArray *arr1 = [NSSortDescriptor ascDescriptorsWithKey:@"age"];
    NSArray *arr2 = [NSSortDescriptor mb_ascDescriptorsWithKey:@"age"];
    NSArray *arr3 = [NSSortDescriptor descDescriptorsWithKey:@"age"];
    NSArray *arr4 = [NSSortDescriptor mb_descDescriptorsWithKey:@"age"];
    NSArray *result1 = [array1 sortedArrayUsingDescriptors:arr1];
    NSArray *result2 = [array1 sortedArrayUsingDescriptors:arr3];
    NSArray *result3 = [array2 sortedArrayUsingDescriptors:arr2];
    NSArray *result4 = [array2 sortedArrayUsingDescriptors:arr4];
    XCTAssertTrue(((Person *)result1[0]).age == ((Person *)result3[0]).age);
    XCTAssertTrue(((Person *)result2[0]).age == ((Person *)result4[0]).age);
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
