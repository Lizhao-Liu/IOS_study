//
//  YMMAccessBridgeTest1.m
//  YMMBridgeLib_Example
//
//  Created by 常贤明 on 2022/1/4.
//  Copyright © 2022 wyyincheng@yeah.net. All rights reserved.
//

#import "YMMAccessBridgeTest1.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>
#import <YMMBridgeLib/MBBridgeAccessModel.h>

@interface YMMAccessBridgeTest1()<YMMPluginProtocol>

@end

@implementation YMMAccessBridgeTest1
MB_BRIDGE_PLUGIN_EXPORT(trade, ymm)

- (void)testtradelist:(NSDictionary *)params
             callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testtradedetail:(NSDictionary *)params
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testtradeInfo:(NSDictionary *)params
              container:(id<MBBridgeContainer>)container
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testtradeInfo:(NSDictionary *)params
             callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

#pragma mark - YMMPluginProtocol Method
- (NSDictionary<NSString *, MBBridgeAccessModel *> *)bridgeAccessControlsForMethod {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[@"trade", @"trade.ymm", @"user.ymm"]
                                                                       level:MBBridgeAccessLevelWarning];
    MBBridgeAccessModel *model2 = [[MBBridgeAccessModel alloc] initWithAccess:@[@"trade", @"cargo.ymm", @"user.ymm"]
                                                                       level:MBBridgeAccessLevelError];
    return @{
        @"testtradelist":model,
        @"testtradedetail":model2
    };
}


- (MBBridgeAccessModel *)bridgeAccessControlsForAllMethods {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[@"user"]
                                                                       level:MBBridgeAccessLevelWarning];
    return model;
}


@end

/**
 权限测试
 1、a.x,a,a.y,b
 2、a.x,a.y
 3、a,b,c
 4、a.x,b.x,c.x
 5、a.x,b.y,c.z
 
 有可能
 plugin设置：a,b
 method设置：a.x,b,b.x
 
 plugin设置：a.x,b.x
 method设置：a.x,b
 */
