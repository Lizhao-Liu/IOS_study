//
//  NewServiceB.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import "NewServiceB.h"

@interface NewServiceB ()<ServiceYProtocol>

@end

@serviceEX(NewServiceB, ServiceYProtocol)

- (void)testServiceY {
//    NSLog(@"%s, from:%@", __func__, (!self.fromContext ? @"unknown" : self.fromContext.getModuleInfo.moduleName));
}

@end
