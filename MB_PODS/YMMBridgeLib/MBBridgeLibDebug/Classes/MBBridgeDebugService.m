//
//  MBBridgeDebugService.m
//  Pods
//
//  Created by 常贤明 on 2022/1/6.
//

#import "MBBridgeDebugService.h"
#import "MBBridgeDebugController.h"
@import YMMBridgeLib;
#import "MBTestAccessBridge.h"
#import "MBTestAccessBridge2.h"

@serviceEX(MBBridgeDebugService, MBDebugServiceProtocol)

- (NSString *)itemTitle {
    return @"bridge基础库通道层测试";
}

- (NSString *)summary {
    return @"基础库基础能力测试";
}

- (MBDebugHandleBlock)handleBlock {
    
    [[YMMPluginManager shared] registerPlugin:MBTestAccessBridge.class supportModule:@"app" bizName:@"test"];
    [[YMMPluginManager shared] registerPlugin:MBTestAccessBridge2.class supportModule:@"app" bizName:@"test"];
    
    return ^(UIViewController *vc) {
        if (vc) {
            MBBridgeDebugController *viewController = [[MBBridgeDebugController alloc] init];
            [vc.navigationController pushViewController:viewController animated:YES];
        }
    };
}

@end
