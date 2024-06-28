//
//  MBTigaTestBridge3.m
//  MBBridgeLibDebug
//
//  Created by admin on 2023/4/7.
//

#import "MBTigaTestBridge3.h"
#import <YMMBridgeLib/YMMPluginProtocol.h>

@interface MBTigaTestBridge3()<YMMPluginProtocol>

@end

@implementation MBTigaTestBridge3

- (void)testallInfo:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"testallInfo params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)testallDetail:(NSDictionary *)params
       container:(id<MBBridgeContainer>)container
        callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"testallDetail container params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        response.data = @{
            @"key1":[NSString stringWithFormat:@"version v2"],
            @"key2":@"test 3 duan"
        };
        completion(response);
    }
    
}

@end
