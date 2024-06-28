//
//  MBTestTigaBridge2.m
//  MBBridgeLibDebug
//
//  Created by admin on 2023/4/7.
//

#import "MBTestTigaBridge2.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface MBTestTigaBridge2()<YMMPluginProtocol>

@end

@implementation MBTestTigaBridge2

- (void)testv2Info:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"testv2Info params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testv2Detail:(NSDictionary *)params
       container:(id<MBBridgeContainer>)container
        callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"testv2Detail container params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        response.data = @{
            @"key1":@"v2 version",
            @"key2":@"test two duan"
        };
        completion(response);
    }
    
}

@end
