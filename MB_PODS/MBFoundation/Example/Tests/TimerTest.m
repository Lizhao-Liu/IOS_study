//
//  TimerTest.m
//  MBFoundation_Tests
//
//  Created by 汪灏 on 2021/11/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import MBFoundation;
@import MBToolKit;

@interface TimerTest : XCTestCase

@end

@implementation TimerTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTimer {
    static int i = 0;
    NSTimer *toolkitTimer = [NSTimer mb_scheduledTimerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"toolkit timer ---- %d", i++);
        if (i >= 10) {
            [timer invalidate];
            timer = nil;
        }
    }];
    XCTAssertNotNil(toolkitTimer);
    
    static int j = 0;
    NSTimer *foundationTimer = [NSTimer mb_scheduledTimerWithTimeInterval:1.f repeats:YES completion:^(NSTimer * _Nonnull timer) {
        NSLog(@"foundation timer ---- %d", j++);
        if (j >= 10) {
            [timer invalidate];
            timer = nil;
        }
    }];
    XCTAssertNotNil(foundationTimer);
    
    static int k = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer ---- %d", k++);
        if (k >= 10) {
            [timer invalidate];
            timer = nil;
        }
    }];
    XCTAssertNotNil(timer);
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
