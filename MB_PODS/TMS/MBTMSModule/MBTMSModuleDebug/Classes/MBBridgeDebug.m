//
//  MBBridgeDebug.m
//  AAChartKit
//
//  Created by Lizhao on 2023/12/20.
//

#import "MBBridgeDebug.h"
@import YMMRouterLib;
@import YMMModuleLib;

@serviceEX(MBBridgeDebug, MBDebugServiceProtocol)

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
