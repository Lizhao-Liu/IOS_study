//
//  YMMOldBridgeTest.m
//  YMMBridgeLib_Example
//
//  Created by 常贤明 on 2020/8/12.
//  Copyright © 2020 wyyincheng@yeah.net. All rights reserved.
//

#import "YMMOldBridgeTest.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface YMMOldBridgeTest()<YMMPluginProtocol>

@end

@implementation YMMOldBridgeTest

YMM_PLUGIN_EXPORT(cargo)

- (void)cargodetail:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"old bridge params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)cargodetail:(NSDictionary *)params
          container:(id<MBBridgeContainer>)container
           callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"两段式 带container参数 bridge params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

@end
