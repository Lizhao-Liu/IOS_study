//
//  YMMUserBridgePlugin.m
//  YMMUserModule
//
//  Created by rensihao on 2019/4/22.
//  Copyright © 2019年 heng wu. All rights reserved.
//

#import "MBBridgeUserPlugin.h"
#import "TMSUserManager.h"
@import YMMBridgeLib;

@interface MBBridgeUserPlugin () <YMMPluginProtocol>

@end

@implementation MBBridgeUserPlugin

YMM_PLUGIN_EXPORT(user)

- (void)getUserInfo:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion {
    if (completion) {
                
        NSDictionary *tempDic = [TMSUserManager.sharedTMSUserManager.userInfo yy_modelToJSONObject];
        NSMutableDictionary *userInfoDict = [tempDic mutableCopy];
        [userInfoDict removeObjectForKey:@"token"];
        [userInfoDict removeObjectForKey:@"nakedMobile"];
        [userInfoDict setObject:@(TMSUserManager.sharedTMSUserManager.isLogin) forKey:@"isLogin"];
        
        YMMMethodResponse *success = [YMMMethodResponse defaultSuccessResponse];
        success.data = [userInfoDict copy];
        completion(success);
    }
}

@end
