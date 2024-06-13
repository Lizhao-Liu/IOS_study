//
//  HCBLoginRequest.m
//  GasStationBiz
//
//  Created by ty on 2017/10/31.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBLoginRequest.h"
#import "HCBUserManager.h"
#import "config.h"
#import "HCBAPIs.h"
#import "HCBUserManager.h"
@import HCBLoginSDK;
@import HCBNetwork;

@implementation HCBLoginRequest

+ (void)reqLogin:(NSString *)userName
           code:(NSString *)code
    withTimeOut:(NSTimeInterval)timeOut
onCompleteBlock:(void (^)(NSDictionary *))completeBlock
  onFailedBlock:(void (^)(HCBError *))failedBlock {
    
    [HCBLogin initRequestBlock:^(HCBRequest *request, BOOL isAutoLogin) {
        NSString *version = [self appVersion];
        NSUInteger ver = [self appVersionValue];
        NSString *bundleId = [self bundleId];

        request.notShowToast = NO;
        request.host = HCBNetworkGetHost(@"HCBGasStation", @"sso");
        [request setApi:req_login_accountandcode];
        [request setPostValue:userName forKey:@"mobile"];
        [request setPostValue:code forKey:@"code"];
        [request setPostValue:[OpenUDID value] forKey:@"dfp"]; //openUdid作为设备标识不可靠.
        [request setPostValue:version forKey:@"version"];
        [request setPostValue:@(ver) forKey:@"vc"];
        [request setPostValue:@"GAS_MERCHANT_LOGIN&" forKey:@"codeType"];
        [request setPostValue:@(appClientID) forKey:@"appClientId"];
        [request setPostValue:bundleId forKey:@"appClientFlag"]; /**< 客户端标识: Android为package name,iOS 为bundle id */
        NSString *client = [NSString stringWithFormat:@"%@_v%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
        [request setPostValue:client forKey:@"client"];
        [request setPostValue:@(1) forKey:@"domainId"];  /**< 地区区域ID */
        if([HCBUserManager shareManager].currentUser.ID){
            [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
        }
    } completeBlock:^(NSDictionary *content) {
        !completeBlock ? : completeBlock(content);
    } faildBlock:^(HCBError *error) {
        !failedBlock ? : failedBlock(error);
    } autoLoginBlock:^BOOL{
        return [HCBUserManager shareManager].currentUser.isLogined;
    }];
    [HCBLogin login];
}

+ (void)reqRelogin:(NSString *)userName
           pwd:(NSString *)pwd
    withTimeOut:(NSTimeInterval)timeOut
onCompleteBlock:(void (^)(NSDictionary *))completeBlock
  onFailedBlock:(void (^)(HCBError *))failedBlock {
    
    [self setupReloginFunc:userName
                       pwd:pwd
               withTimeOut:timeOut
           onCompleteBlock:completeBlock
             onFailedBlock:failedBlock];
    [HCBLogin login];
}



+ (void)setupReloginFunc:(NSString *)userName
                    pwd:(NSString *)pwd
            withTimeOut:(NSTimeInterval)timeOut
        onCompleteBlock:(void (^)(NSDictionary *))completeBlock
          onFailedBlock:(void (^)(HCBError *))failedBlock {
    
    [HCBLogin initRequestBlock:^(HCBRequest *request, BOOL isAutoLogin) {
        NSString *version = [self appVersion];
        NSUInteger ver = [self appVersionValue];
        NSString *bundleId = [self bundleId];

        request.notShowToast = NO;
        request.host = HCBNetworkGetHost(@"HCBGasStation", @"sso");
        [request setApi:req_login_accountandpwd];
        [request setPostValue:userName forKey:@"username"];
        [request setPostValue:pwd forKey:@"password"];
        [request setPostValue:[OpenUDID value] forKey:@"dfp"]; //openUdid作为设备标识不可靠.
        [request setPostValue:version forKey:@"version"];
        [request setPostValue:@(ver) forKey:@"vc"];
        [request setPostValue:@"GAS_MERCHANT_LOGIN&" forKey:@"codeType"];
        [request setPostValue:@(appClientID) forKey:@"appClientId"];
        [request setPostValue:bundleId forKey:@"appClientFlag"]; /**< 客户端标识: Android为package name,iOS 为bundle id */
        NSString *client = [NSString stringWithFormat:@"%@_v%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
        [request setPostValue:client forKey:@"client"];
        [request setPostValue:@(1) forKey:@"domainId"];  /**< 地区区域ID */
        if([HCBUserManager shareManager].currentUser.ID){
            [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
        }
    } completeBlock:^(NSDictionary *content) {
        !completeBlock ? : completeBlock(content);
    } faildBlock:^(HCBError *error) {
        !failedBlock ? : failedBlock(error);
    } autoLoginBlock:^BOOL{
        return [HCBUserManager shareManager].currentUser.isLogined;
    }];
}

+ (void)reqUserInfoWithCompleteBlock:(void (^)(NSDictionary *))completeBlock
                      onFailedBlock:(void (^)(HCBError *))failedBlock {
    
    HCBRequest *request = [HCBRequest new];
    request.timeOut = 30;
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"jyz");
    request.authenticate = YES;
    [request setApi:req_posuser_userinfo];
    if([HCBUserManager shareManager].currentUser.ID){
        [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
    }
    
    [request setCompletionBlock:^(NSDictionary *content) {
        !completeBlock ? : completeBlock(content);
    }];
    
    [request setFailedBlock:^(HCBError *error) {
        !failedBlock ? : failedBlock(error);
    }];
    [request startAsynchronous];
}


+ (void)reqModifyMobileWithNewMobileNum:(NSString *)newMobile
                            verifyCode:(NSString *)verifyCode
                       onCompleteBlock:(void (^)(NSDictionary *))completeBlock
                      onFailedBlock:(void (^)(HCBError *))failedBlock {
    
    HCBRequest *request = [HCBRequest new];
    request.timeOut = 15;
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"jyz");
    [request setApi:req_gasstation_modifymobile];
    [request setPostValue:newMobile forKey:@"mobile"];
    [request setPostValue:verifyCode forKey:@"verifyCode"];
    if([HCBUserManager shareManager].currentUser.ID){
        [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
    }
    [request setCompletionBlock:^(NSDictionary *content) {
        !completeBlock ? : completeBlock(content);
    }];
    
    [request setFailedBlock:^(HCBError *error) {
        !failedBlock ? : failedBlock(error);
    }];
    [request startAsynchronous];
}

+ (void)reqLoginOutWithCompleteBlock:(void (^)(NSDictionary *))completeBlock
                         onFailedBlock:(void (^)(HCBError *))failedBlock {
    
    HCBRequest *request = [HCBRequest new];
    request.timeOut = 15;
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"sso");
    [request setApi:req_loginout];
    if([HCBUserManager shareManager].currentUser.ID){
        [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
    }
    
    [request setCompletionBlock:^(NSDictionary *content) {
        !completeBlock ? : completeBlock(content);
    }];
    
    [request setFailedBlock:^(HCBError *error) {
        !failedBlock ? : failedBlock(error);
    }];
    [request startAsynchronous];
}

#pragma mark - private methods

+ (NSString *)appVersion {
    return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSUInteger)appVersionValue {
    return [self appVersionValueForVersionString:[self appVersion]];
}

+ (NSUInteger)appVersionValueForVersionString:(NSString *)str {
    if (str.length == 0) {
        return 0;
    }

    // 5.13.0 -> 5130000
    NSMutableArray<NSString *> *components = [str componentsSeparatedByString:@"."].mutableCopy;

    if (components.count == 0) {
        return 0;
    }

    NSUInteger version = 0, scale = 1000000, max_count = 3, count = 1;

    do {
        NSString *component = components.firstObject;
        NSUInteger value = [component integerValue];
        version += value * scale;
        scale /= 100;
        [components removeObjectAtIndex:0];
    } while (components.count > 0 && ++count <= max_count);

    return version;
}

+ (NSString *)bundleId {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return bundleId;
}

@end
