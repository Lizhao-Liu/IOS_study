//
//  MBTestAccessBridge.m
//  MBBridgeLibDebug
//
//  Created by 常贤明 on 2022/1/6.
//

#import "MBTestAccessBridge.h"
@import YMMBridgeLib;

@interface MBTestAccessBridge()<YMMPluginProtocol>

@end

@implementation MBTestAccessBridge

- (void)apptestbridgeA:(NSDictionary *)params
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeA params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)apptestbridgeB:(NSDictionary *)params
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeB params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)apptestbridgeC:(NSDictionary *)params
               callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeC params:%@", params);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

- (void)apptestbridgeX:(NSDictionary *)params
             container:(id<MBBridgeContainer>)container
               visitor:(MBBridgeVisitor *)visitor
              callBack:(YMMMethodResponseBlock)completion {
    NSLog(@"apptestbridgeX params:%@, visitor.bundleName:%@", params, visitor.bundleName);
    if (completion) {
        YMMMethodResponse *response = [YMMMethodResponse defaultSuccessResponse];
        completion(response);
    }
}

#pragma mark - YMMPluginProtocol method
- (NSDictionary<NSString *, MBBridgeAccessModel *> *)bridgeAccessControlsForMethod {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[@"trade", @"trade.base", @"user.base", @"app"]
                                                                       level:MBBridgeAccessLevelWarning];
    MBBridgeAccessModel *model2 = [[MBBridgeAccessModel alloc] initWithAccess:@[@"trade", @"cargo.base", @"user.base", @"app"]
                                                                       level:MBBridgeAccessLevelError];
    return @{
        @"apptestbridgeA":model,
        @"apptestbridgeB":model2
    };
}


- (MBBridgeAccessModel *)bridgeAccessControlsForAllMethods {
    MBBridgeAccessModel *model = [[MBBridgeAccessModel alloc] initWithAccess:@[@"user", @"cargo.base", @"app"]
                                                                       level:MBBridgeAccessLevelWarning];
    return model;
}

@end
