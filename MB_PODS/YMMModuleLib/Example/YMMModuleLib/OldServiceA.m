//
//  OldServiceA.m
//  YMMModuleLib_Example
//
//  Created by Xiaohui on 2020/4/14.
//  Copyright © 2020 knop. All rights reserved.
//

#import "OldServiceA.h"

@interface OldServiceA ()<ServiceXProtocol>

@end

@service(OldServiceA)
@implementation OldServiceA

- (void)testServiceX {
    NSLog(@"%s", __func__);
}

@end
