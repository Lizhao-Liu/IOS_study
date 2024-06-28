//
//  MBTestTigaBridge.m
//  MBBridgeLibDebug
//
//  Created by admin on 2023/4/7.
//

#import "MBTestTigaBridge.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface MBTestTigaBridge ()<YMMPluginProtocol>

@end

@implementation MBTestTigaBridge

- (void)testTigaUser:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testTigaUser:(NSDictionary *)params
       container:(id<MBBridgeContainer>)container
        callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"container params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        response.data = @{
            @"key1":@(100),
            @"key2":@"value2"
        };
        completion(response);
    }
    
}

@end
