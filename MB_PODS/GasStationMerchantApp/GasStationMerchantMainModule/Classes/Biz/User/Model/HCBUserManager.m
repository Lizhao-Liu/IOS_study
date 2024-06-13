//
//  HCBUserManager.m
//  GasStationBiz
//
//  Created by ty on 2017/10/31.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBUserManager.h"
#import "HCBLoginRequest.h"
@import MBFoundation;
@import HCBNetwork;
@import HCBAppBasis;
@import YMMUserModuleService;

@implementation HCBUserManager

+ (instancetype)shareManager {
    
    static HCBUserManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _currentUser = [HCBUser getFromUserDefaults];
    }
    return self;
}

- (void)writeFromDictionary:(NSDictionary *)dic {
    
    _currentUser = [HCBUser fromDictionary:dic];
    [_currentUser saveToUserDefaults];
}




- (void)userLoginWithMobile:(NSString *)mobile
                       code:(NSString *)code
            onCompleteBlock:(void (^)(BOOL, NSString*))completeBlock {
    
    YMM_Weakify(self, weakSelf)
    [HCBLoginRequest reqLogin:mobile code:code withTimeOut:30 onCompleteBlock:^(NSDictionary *content) {
        
        NSDictionary *resultDic = [content mb_objectForKeyIgnoreNil:@"user"];
        weakSelf.currentUser = [HCBUser fromDictionary:resultDic];
        [weakSelf.currentUser saveToUserDefaults];
        completeBlock(weakSelf.currentUser.isLogined, nil);
        [[HCBAppBasis defaultAppBasis] loginAndCreateUserWithObject:resultDic];
        [weakSelf setupAutoLogin];
    } onFailedBlock:^(HCBError *error) {
        completeBlock(NO, error.errorMsg);
    }];
}

- (void)userReloginWithPwd:(NSString *)mobile
                       pwd:(NSString *)pwd
            onCompleteBlock:(void (^)(BOOL))completeBlock {
    
    [HCBLoginRequest reqRelogin:mobile pwd:pwd withTimeOut:15 onCompleteBlock:nil onFailedBlock:nil];
}

- (void)setupAutoLogin {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        HCBUser *user = [HCBUserManager shareManager].currentUser;
        [HCBLoginRequest setupReloginFunc:user.un pwd:user.pwd withTimeOut:15 onCompleteBlock:nil onFailedBlock:nil];
    });
   
}
@end
