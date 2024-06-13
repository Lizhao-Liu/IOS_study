//
//  ObjcImplClasses.m
//  YMMModuleLib_Tests
//
//  Created by Lizhao on 2023/3/21.
//  Copyright © 2023 knop. All rights reserved.
//

#import "ObjcImplClasses.h"
#import "YMMModuleLib_Tests-Swift.h"


@implementation ObjcImplClassB


- (void)runTest {
    self.methodCalled = YES;
}

@end

@interface ObjcImplClassA ()<swiftServiceForOCImpl>

@end

@implementation ObjcImplClassA


- (void)runTest {
    self.methodCalled = YES;
}

@end

@interface ObjcImplClassC () <OCServiceNotRegistered, swiftServiceNotRegistered>

@end

@implementation ObjcImplClassC

- (void)runTest {
    self.methodCalled = YES;
}

@synthesize methodCalled;

@end

@interface ObjcImplClassD () <swiftServiceRenamedInOC>

@end

@implementation ObjcImplClassD

- (void)runTest {
    self.methodCalled = YES;
}

@synthesize methodCalled;

@end
