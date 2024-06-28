//
//  MBTestAccessBridge2.m
//  MBBridgeLibDebug
//
//  Created by 常贤明 on 2022/1/7.
//

#import "MBTestAccessBridge2.h"
@import YMMBridgeLib;

@interface MBTestAccessBridge2()<YMMPluginProtocol>

@end

@implementation MBTestAccessBridge2

- (void)apptestbridgeD:(NSDictionary *)params
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeD params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)apptestbridgeE:(NSDictionary *)params
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeE params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)apptestbridgeY:(NSDictionary *)params
             container:(id<MBBridgeContainer>)container
               visitor:(MBBridgeVisitor *)visitor
              callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeY params:%@, visitor.bundleName:%@", params, visitor.bundleName);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

#pragma mark - YMMPluginProtocol method
- (NSDictionary<NSString *, MBBridgeAccessModel *> *)bridgeAccessControlsForMethod {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[]
                                                                       level:MBBridgeAccessLevelWarning];
    return @{
        @"apptestbridgeD":model
    };
}

@end
