//
//  HCBVerifycodeRequest.m
//  GasStationBiz
//
//  Created by ty on 2017/11/20.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBVerifycodeRequest.h"
#import "HCBAPIs.h"
#import "HCBUserManager.h"
@import HCBNetwork;

@implementation HCBVerifycodeRequest

//登录验证码
+ (void)reqLoginVerifyCodeWithMobileNum:(NSString *)mobileNum
                        onCompleteBlock:(void (^)(BOOL result))completeBlock
                          onFailedBlock:(void (^)(HCBError *error))failedBlock {
    
    HCBRequest *request = [HCBRequest new];
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"jyz");
    [request setApi:req_login_verifycode];
    [request setPostValue:@"GAS_MERCHANT_LOGIN" forKey:@"type"];
    [request setPostValue:mobileNum forKey:@"mobile"];
    [request setPostValue:@"gs" forKey:@"bizDept"];
    if([HCBUserManager shareManager].currentUser.ID){
        [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
    }
    request.authenticate = NO;
    [request setCompletionBlock:^(NSDictionary *content) {
        if (completeBlock) {
            completeBlock(YES);
        }
    }];
    
    [request setFailedBlock:^(HCBError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    [request startAsynchronous];
}

//更换绑定手机号验证码
+ (void)reqModifyMobileBindingVerifyCodeWithMobileNum:(NSString *)mobileNum
                        onCompleteBlock:(void (^)(NSDictionary *dic))completeBlock
                          onFailedBlock:(void (^)(HCBError *error))failedBlock {
    
    HCBRequest *request = [HCBRequest new];
    request.host = HCBNetworkGetHost(@"HCBGasStation", @"jyz");
    [request setApi:req_gasstation_verifycode];
    [request setPostValue:mobileNum forKey:@"mobile"];
    if([HCBUserManager shareManager].currentUser.ID){
        [request setValue:[HCBUserManager shareManager].currentUser.ID forHTTPHeaderField:@"x-real-uid"];
    }
    
    [request setCompletionBlock:^(NSDictionary *content) {
        if (completeBlock) {
            completeBlock(content);
        }
    }];
    
    [request setFailedBlock:^(HCBError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    [request startAsynchronous];
}

@end
