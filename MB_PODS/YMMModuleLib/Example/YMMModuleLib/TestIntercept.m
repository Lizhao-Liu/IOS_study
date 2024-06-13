//
//  TestIntercept.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/13.
//  Copyright © 2020 knop. All rights reserved.
//

#import "TestIntercept.h"

@implementation TestIntercept

- (BOOL)functionShouldInvoke:(NSString *)function module:(NSString *)module {
    NSLog(@"%smodule:%@ function:%@", __func__, module, function);
    return YES;
}

- (void)functionDidInvoke:(NSString *)function module:(NSString *)module {
    NSLog(@"%smodule:%@ function:%@", __func__, module, function);
}

@end
