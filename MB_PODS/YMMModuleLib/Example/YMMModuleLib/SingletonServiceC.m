//
//  SingletonServiceC.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import "SingletonServiceC.h"

@interface SingletonServiceC ()<ServiceZProtocol>

@end

@serviceEX(SingletonServiceC, ServiceZProtocol)

+ (BOOL)singleton {
    return YES;
}

- (void)testServiceZ {
//    NSLog(@"%@, %s, from:%@", self, __func__, (!self.fromContext ? @"unknown" : self.fromContext.name));
}

@end


