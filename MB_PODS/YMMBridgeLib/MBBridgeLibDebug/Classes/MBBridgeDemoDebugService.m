//
//  MBBridgeDemoDebugService.m
//  MBBridgeLibDebug
//
//  Created by zhaozhao on 2024/3/28.
//

#import "MBBridgeDemoDebugService.h"
@import YMMRouterLib;
@import YMMModuleLib;

@serviceEX(MBBridgeDemoDebugService, MBDebugServiceProtocol)

@synthesize handleBlock;
@synthesize itemTitle;
@synthesize summary;

- (NSString *)itemTitle {
    return @"bridge调试";
}

- (NSString *)summary {
    return @"flutter/rn/js bridge调试入口";
}

- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        [[YMMRouterCenter shared] performWithURLString:@"https://devstatic.ymm56.com/mbBridge-demo/"
                                            completion:^(YMMRouterResponse * _Nullable response) {
            if ([response.result isKindOfClass:[UIViewController class]]) {
                [vc.navigationController pushViewController:(UIViewController *)response.result animated:YES];
            }
        }];
    };
}

@end
