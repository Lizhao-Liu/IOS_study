//
//  testAdapters.m
//  YMMModuleLib_Tests
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

@import XCTest;
@import YMMModuleLib;
#import "ObjcProtocols.h"
#import "YMMModuleLib_Tests-Swift.h"
#import "ObjcImplClasses.h"

@interface TestAdapters : XCTestCase

@end

@implementation TestAdapters

- (void)setUp
{
    [super setUp];
    [[MBAdapter shared] registerAdapterOfProtocol: @protocol(swiftServiceForSwiftImpl) usedImplClass:[serviceImplSSSI class]];
    [[MBAdapter shared] registerAdapterOfProtocol:@protocol(OCServiceForOCImpl) usedImplClass:[ObjcImplClassB class]];
    [[MBAdapter shared] registerAdaptersWithImplClass:[serviceImplCSSI class]];
    [[MBAdapter shared] registerAdaptersWithImplClass:[ObjcImplClassA class]];
    [[MBAdapter shared] registerAdapterOfProtocol:@protocol(swiftServiceRenamedInOC) usedImplClass:[ ObjcImplClassD class]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    NSLog(@"test end");
    [super tearDown];
}


- (void)testDiscovery {
    id<swiftServiceForSwiftImpl> test1 = GET_ADAPTER(nil, swiftServiceForSwiftImpl);
    NSAssert(test1 != nil, @"swiftServiceForSwiftImpl not found");
    id<OCServiceForSwiftImpl> test2 = GET_ADAPTER(nil, OCServiceForSwiftImpl);
    NSAssert(test2 != nil, @"OCServiceForSwiftImpl not found");
    id<swiftServiceForOCImpl> test3 = GET_ADAPTER(nil, swiftServiceForOCImpl);
    NSAssert(test3 != nil, @"swiftServiceForOCImpl not found");
    id<OCServiceForOCImpl> test4 = GET_ADAPTER(nil, OCServiceForOCImpl);
    NSAssert(test4 != nil, @"");
    
    [test1 runTest];
    [test2 runTest];
    [test3 runTest];
    [test4 runTest];
    NSAssert(test1.methodCalled == YES, @"");
    NSAssert(test2.methodCalled == YES, @"");
    NSAssert(test3.methodCalled == YES, @"");
    NSAssert(test4.methodCalled == YES, @"");
}

- (void)testNotFound {
    id<OCServiceNotFound> test = GET_ADAPTER(nil,  OCServiceNotFound);
    NSAssert(test == nil, @"");
}

//- (void)testFoundInBundle {
//    id<OCServiceNotRegistered> test = GET_ADAPTER(nil, OCServiceNotRegistered);
//    NSAssert(test != nil, @"");
//    [test runTest];
//    NSAssert(test.methodCalled == YES, @"");
//
//    id<swiftServiceNotRegistered> test2 = GET_ADAPTER(nil, swiftServiceNotRegistered);
//    NSAssert(test2 != nil, @"");
//    [test2 runTest];
//    NSAssert(test2.methodCalled == YES, @"");
//}

- (void)testRenamedService {
    id<swiftServiceRenamedInOC> test = GET_ADAPTER(nil, swiftServiceRenamedInOC);
    NSAssert(test != nil, @"");
    [test runTest];
    NSAssert(test.methodCalled == YES, @"");
}


@end


