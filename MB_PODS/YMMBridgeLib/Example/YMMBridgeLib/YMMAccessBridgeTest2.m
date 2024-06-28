//
//  YMMAccessBridgeTest2.m
//  YMMBridgeLib_Example
//
//  Created by 常贤明 on 2022/1/4.
//  Copyright © 2022 wyyincheng@yeah.net. All rights reserved.
//

#import "YMMAccessBridgeTest2.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface YMMAccessBridgeTest2()<YMMPluginProtocol>

@end

@implementation YMMAccessBridgeTest2

MB_BRIDGE_PLUGIN_EXPORT(main, ymm)

- (void)maintab:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)mainicon:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (NSDictionary<NSString *, MBBridgeAccessModel *> *)bridgeAccessControlsForMethod {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[@"trade", @"main", @"user.ymm"]
                                                                       level:MBBridgeAccessLevelWarning];
    return @{
        @"maintab":model
    };
}

@end
