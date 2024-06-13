//
//  GasStationLaunchTaskUser.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/11.
//

#import "GasStationLaunchTaskUser.h"
#import "HCBStationManager.h"
#import "HCBUserManager.h"
#import "HCBUser.h"
#import "HCBLoginRequest.h"
#import "HCBLoginVC.h"
#import "config.h"
@import MBLauncherLib;
@import MBFoundation;
@import HCBNetwork;
@import HCBAppBasis;
@import HCBLoginSDK;
@import YMMUserModuleService;
@import MBAppBasisModule;
@import MBWalletModuleService;

@interface GasStationLaunchTaskUser() <MBLaunchTask, HCBNetworkDelegate>

@end

@MBLaunchTaskEX(GasStationLaunchTaskUser)

@implementation GasStationLaunchTaskUser


- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneBizSDK;
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    [[HCBStationManager shareManager].stationModel readFromCache];
    [HCBLoginSDK setup];
    [HCBNetworkDataManager shareDataManager].delegate = self;
    [self autoLogin];
    [self registerNotifications];
    return YES;
}

- (nonnull NSString *)taskName {
    return @"user";
}

- (MBLaunchPriority)taskPriority {
    return MBMainLaunchBasicTaskPriorityUser;
}

- (void)dealloc {
    [self unregisterNotifications];
}


- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginSuccess:) name:MBUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutSuccess:) name:MBUserLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFailed:) name:KHCB_RequestDidFailedNotificationName object:nil];
}

- (BOOL)hcbRequestIsAutoLoginCommonError:(NSString *)errorCode {
    if ([errorCode integerValue] == 5 || [errorCode integerValue] == 120001) {
        // 自动登录, 120001 为兼容老版本
        return YES;
    } else if ([errorCode isEqualToString:@"001001"] ||
               [errorCode isEqualToString:@"002001"]) {
        // 客户端请求到服务器,加解密过程中失败的情况
        return YES;
    }
    return NO;
}

- (BOOL)isLogoutError:(NSString *)errorCode {
    if ([errorCode integerValue] == 120002) {
        // 被挤掉下线
        return YES;
    } else if ([errorCode integerValue] == 120010) {
        // 认证状态发生变化，踢出下线。
        // 认证后的状态需要返回到登录界面（Server定义），
        // 认证前的状态直接重新登录. 目前无法区分这两种状态
        return YES;
    } else if ([errorCode integerValue] == 401 ) {
        return YES;
    }
    return NO;
}

- (void)requestFailed:(NSNotification *)notification {
    if(notification.object && [notification.object isKindOfClass:[HCBError class]]){
        HCBError *requestFailedError = (HCBError *)notification.object;
        if([self isLogoutError:requestFailedError.errorCode]){
            [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLogoutNotification object:nil]; //发送登出通知
        }
    }
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidLoginSuccess:(NSNotification *)notification {
}

- (void)userDidLogoutSuccess:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MBWalletNeedLogoutNotification object:nil]; //发送钱包登出通知
    [[HCBAppBasis defaultAppBasis] logout];
    [[HCBUserManager shareManager].currentUser clearUserDefaults];
}


/// 启动阶段用户自动登录
- (void)autoLogin {
    HCBUser *user = [HCBUserManager shareManager].currentUser; // 读缓存的历史user，自动登录
    if (user.isLogined) {
        YMM_Weakify(self, weakSelf)
        [HCBLoginRequest reqRelogin:user.un pwd:user.pwd withTimeOut:15.f onCompleteBlock:^(NSDictionary *dic) {
            [weakSelf setupUserInfo]; // 更新station信息并存入UserDefaults
            [[HCBNetworkLoginManager sharedManager] notifyAutoLoginCompleteWithContent:dic error:nil]; //自动登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLoginNotification object:nil userInfo:@{kReloginNotificationKey:@(YES)}]; // 发送登录成功通知
            /**
              bug 修复：https://dmpt.amh-group.com/dmpt/index.html#/bug/bugDetail?id=139298
              自动登录不再调用接口更新用户本地缓存信息
             */
            [[HCBUserManager shareManager] setupAutoLogin];
        } onFailedBlock:^(HCBError *error) {
            [[HCBUserManager shareManager].currentUser clearUserDefaults]; //清除缓存
            [HCBLoginRequest reqLoginOutWithCompleteBlock:nil onFailedBlock:nil]; //登出
            [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLogoutNotification object:nil]; //发送登出通知
        }];
    } else {
        [[HCBAppBasis defaultAppBasis]  logout];
        [[HCBUserManager shareManager].currentUser clearUserDefaults];
    }
}


- (void)setupUserInfo {
    [HCBLoginRequest reqUserInfoWithCompleteBlock:^(NSDictionary *dic) {
        /**
          bug 修复：https://dmpt.amh-group.com/dmpt/index.html#/bug/bugDetail?id=139298
          请求user/info接口不再更新油站信息缓存，由 flutter 调用setGasStationInfo设置
         */
        [[HCBStationManager shareManager].stationModel updateUserInfo:dic];
        [[HCBStationManager shareManager].stationModel saveToUserDefaults];
    } onFailedBlock:^(HCBError *error) {
        
    }];
}


@end
