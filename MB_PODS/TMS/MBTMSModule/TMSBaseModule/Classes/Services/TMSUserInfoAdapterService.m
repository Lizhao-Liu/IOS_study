//
//  TMSUserInfoAdapterService.m
//  TMSBaseModule
//
//  Created by zht on 2021/5/14.
//

#import "TMSUserInfoAdapterService.h"
#import "TMSUserManager.h"
#import "MBTMSModule-Swift.h"
@import MBUIKit;
@import YMMModuleLib;

@serviceEX(TMSUserInfoAdapterService, YMMUserServiceProtocol)

+ (BOOL)singleton {
    return YES;
}

- (NSString *)userId{
    return TMSUserManager.sharedTMSUserManager.userInfo.userId?:@"";
}

- (NSString *)HCBUserId{
    return self.userId;
}

- (BOOL)loginSuccess{
    return [TMSUserManager.sharedTMSUserManager isLogin];
}

- (YMMUserProfileModel *)profileInfo {
    return [YMMUserProfileModel new];
}

-(YMMUserInfo *)userInfo {
    
    YMMUserInfo *userInfo = [YMMUserInfo new];
    userInfo.ymmUserId = TMSUserManager.sharedTMSUserManager.userInfo.userId?:@"";
    userInfo.ymmUserToken = TMSUserManager.sharedTMSUserManager.userInfo.token?:@"000";
    return userInfo;
}

- (NSString *)uuid {
    return TMSUserManager.sharedTMSUserManager.deviceInfo.appuuid;
}

- (BOOL)currentNavStackHasLoginVC {
    UIViewController *vc = [UIViewController mb_currentViewController];
    for (UIViewController *obj in vc.navigationController.viewControllers) {
        if ([obj isKindOfClass:[TMSNewLoginVC class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isLogin {
    return [TMSUserManager.sharedTMSUserManager isLogin];
}

- (MBFinancialUserClientInfo *)mbFinancialUserClientInfo {
    return [MBFinancialUserClientInfo new];
}

- (CGFloat)getFitScale {
    return 1;
}

- (void)postLoginSuccesseedNotificationWithIsManualLogin:(BOOL)isManualLogin {
    [[TMSUserManager sharedTMSUserManager] postLoginSuccesseedNotificationWithIsManualLogin:isManualLogin];
}
@end
