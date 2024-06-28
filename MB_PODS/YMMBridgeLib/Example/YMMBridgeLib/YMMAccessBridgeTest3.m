//
//  YMMAccessBridgeTest3.m
//  YMMBridgeLib_Example
//
//  Created by 常贤明 on 2022/1/4.
//  Copyright © 2022 wyyincheng@yeah.net. All rights reserved.
//

#import "YMMAccessBridgeTest3.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface YMMAccessBridgeTest3()<YMMPluginProtocol>

@end

@implementation YMMAccessBridgeTest3
MB_BRIDGE_PLUGIN_EXPORT(push, ymm)

- (void)pushinfo:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)pushlist:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (MBBridgeAccessModel *)bridgeAccessControlsForAllMethods {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[@"user", @"trade.ymm"]
                                                                       level:MBBridgeAccessLevelError];
    return model;
}

@end
