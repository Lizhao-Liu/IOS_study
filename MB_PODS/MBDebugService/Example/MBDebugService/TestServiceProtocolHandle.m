//
//  TestServiceProtocolHandle.m
//  MBDebugService
//
//  Created by Ymm on 2019/12/30.
//  Copyright © 2019 billows. All rights reserved.
//

#import "TestServiceProtocolHandle.h"
#import <YMMModuleLib/YMMModuleManager.h>
#import "TestDEBUGViewController.h"

@service(TestServiceProtocolHandle)

@implementation TestServiceProtocolHandle

@synthesize itemTitle;
@synthesize summary;
@synthesize handleBlock;
    
- (NSString *)itemTitle {
    return @"TestServiceProtocolHandle";
}
    
- (NSString *)summary {
    return @"这是一段描述信息，这是一段描述信息";
}

- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        NSLog(@"%@", NSStringFromSelector(_cmd));
        if (vc) {
            TestDEBUGViewController *viewController = [[TestDEBUGViewController alloc] init];
            [vc.navigationController pushViewController:viewController animated:YES];
        }
    };
}

@end
