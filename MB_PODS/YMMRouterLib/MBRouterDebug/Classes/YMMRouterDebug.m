//
//  YMMRouterDebug.m
//  AliyunOSSiOS
//
//  Created by Xiaohui on 2020/1/6.
//

#import "YMMRouterDebug.h"
#import "YMMRouterDebugViewController.h"

@serviceEX(YMMRouterDebug, MBDebugServiceProtocol)

@synthesize handleBlock;
@synthesize itemTitle;
@synthesize summary;

- (NSString *)itemTitle {
    return @"路由调试";
}

- (NSString *)summary {
    return @"路由调试入口";
}

- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        [vc.navigationController pushViewController:[[YMMRouterDebugViewController alloc] init] animated:YES];
    };
}

@end
