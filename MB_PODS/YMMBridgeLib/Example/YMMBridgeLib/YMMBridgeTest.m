//
//  YMMBridgeTest.m
//  YMMBridgeLib_Example
//
//  Created by 常贤明 on 2020/8/12.
//  Copyright © 2020 wyyincheng@yeah.net. All rights reserved.
//

#import "YMMBridgeTest.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface YMMBridgeTest()<YMMPluginProtocol>

@end

@implementation YMMBridgeTest

MB_BRIDGE_PLUGIN_EXPORT(user, ymm)

- (void)testUser:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testUser:(NSDictionary *)params
       container:(id<MBBridgeContainer>)container
        callBack:(YMMMethodResponseBlock)completion {
    if ([container respondsToSelector:@selector(addContainerListener:unique:)]) {
        [container addContainerListener:[MBBridgeContainerListener listenDealloc:^{
            NSLog(@"listen dealloc ----------");
        }] unique:nil];
    }
        
    NSLog(@"带容器testUser:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testMore:(NSDictionary *)params
       container:(id<MBBridgeContainer>)container
        callBack:(YMMMethodResponseBlock)completion {
    
    if ([container respondsToSelector:@selector(addContainerListener:unique:)]) {
        [container addContainerListener:[MBBridgeContainerListener listenDealloc:^{
            NSLog(@"listen dealloc ----------");
        }] unique:nil];
    }
        
    NSLog(@"testMore:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}


@end
