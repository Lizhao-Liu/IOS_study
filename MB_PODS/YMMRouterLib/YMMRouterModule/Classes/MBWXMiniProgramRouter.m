//
//  MBWXMiniProgramRouter.m
//  YMMRouterModule
//
//  Created by Lizhao on 2023/5/9.
//

#import "MBWXMiniProgramRouter.h"
#import "MBRouterModuleLog.h"
@import MBShareWX;

@implementation MBWXMinProgramRouter

- (nullable id)handle:(id<YMMRouterRoutable>)routable {
    if (!routable.params.count) {
        return nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        // mb-wx://min_program/index?user_name=xxxxxx&type=0&path=xxxxx
        NSString *userName = [routable.params objectForKey:@"user_name"];
        NSString *path = [routable.params objectForKey:@"path"];
        NSNumber *type = [routable.params objectForKey:@"type"];
        MBShareWechatHandler *wxHandler = (MBShareWechatHandler *)[[MBShareChannelManager defaultManager] shareHandlerWithChannelType:MBShareChannelTypeWechatSession];
        [wxHandler mb_sendMiniProgramUsername:userName path:path type:type.integerValue completion:^(BOOL success){
            MBRouterModuleLogInfo(@"open minProgram success:%d", success);
        }];
    });
    return nil;
}
@end
