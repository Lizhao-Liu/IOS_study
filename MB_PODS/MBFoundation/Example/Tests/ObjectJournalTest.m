//
//  ObjectJournalTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface ObjectJournalTest : XCTestCase

@end

@implementation ObjectJournalTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testJournal {
    NSObject *obj = [[NSObject alloc] init];
    obj.eventExtraDic = @{};
    obj.mbEventExtraDic = @{};
    obj.elementId = @"";
    obj.mbElementId = @"";
//    obj.eventType = @"";
//    obj.mbEventType = @"";
    obj.logElementId = @"";
    obj.mbLogElementId = @"";
    XCTAssertNil([obj extension]);
    XCTAssertNil([obj mb_extension]);
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
