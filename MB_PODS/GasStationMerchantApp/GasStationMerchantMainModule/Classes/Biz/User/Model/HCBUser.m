//
//  HCBUser.m
//  GasStationBiz
//
//  Created by ty on 2017/10/31.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBUser.h"
#import "HCBLoginRequest.h"
@import MBFoundation;

static NSString *userInfoKey = @"gasUserInfo_Key";

@implementation HCBUser

+ (HCBUser *)fromDictionary:(NSDictionary *)dic {
    
    HCBUser *user = [HCBUser new];
    user.ID = [dic mb_stringForKey:@"id"]; //number
    user.hw = [dic mb_stringForKey:@"hw"]; //boolean
    user.daid = [dic mb_stringForKey:@"daid"]; //number
    user.rid = [dic mb_stringForKey:@"rid"]; //number
    user.type = [dic mb_stringForKey:@"type"]; //number
    user.d = [dic mb_stringForKey:@"d"]; //number
    user.bindMobile = [dic mb_stringForKey:@"bindMobile"];
    user.attachment = [dic mb_stringForKey:@"attachment"]; //number
    user.un = [dic mb_stringForKey:@"un"];
    user.m = [dic mb_stringForKey:@"m"];
    user.pwd = [dic mb_stringForKey:@"pwd"];
    user.dv = [dic mb_stringForKey:@"dv"]; //number
    user.authStatus = [dic mb_stringForKey:@"authStatus"];
    user.isLogined = [dic mb_boolForKey:@"isLogined"]; //bool
    return user;
}

- (NSMutableDictionary *)toDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    !self.ID ? : [dic setObject:self.ID forKey:@"id"];
    !self.hw ? : [dic setObject:self.hw forKey:@"hw"];
    !self.daid ? : [dic setObject:self.daid forKey:@"daid"];
    !self.rid ? : [dic setObject:self.rid forKey:@"rid"];
    !self.type ? : [dic setObject:self.type forKey:@"type"];
    !self.d ? : [dic setObject:self.d forKey:@"d"];
    !self.bindMobile ? : [dic setObject:self.bindMobile forKey:@"bindMobile"];
    !self.attachment ? : [dic setObject:self.attachment forKey:@"attachment"];
    !self.un ? : [dic setObject:self.un forKey:@"un"];
    !self.m ? : [dic setObject:self.m forKey:@"m"];
    !self.pwd ? : [dic setObject:self.pwd forKey:@"pwd"];
    !self.dv ? : [dic setObject:self.dv forKey:@"dv"];
    !self.authStatus ? : [dic setObject:self.authStatus forKey:@"authStatus"];
    if (self.bindMobile.length > 0
        && self.pwd.length > 0) {
        
        self.isLogined = YES;
    }
    [dic setObject:@(self.isLogined) forKey:@"isLogined"];
    
    return dic;
}

- (BOOL)saveToUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self toDictionary] forKey:userInfoKey];
    return [userDefaults synchronize];
}

- (void)clearUserDefaults {
    
    self.ID = nil;
    self.hw = nil;
    self.daid = nil;
    self.rid = nil;
    self.type = nil;
    self.d = nil;
    self.bindMobile = nil;
    self.attachment = nil;
    self.un = nil;
    self.m = nil;
    self.pwd = nil;
    self.dv = nil;
    self.authStatus = nil;
    self.isLogined = NO;
    [self saveToUserDefaults];
}

+ (id)getFromUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    HCBUser *user = [self fromDictionary:[userDefaults objectForKey:userInfoKey]];
    return user;
}

- (NSString *)bindMobile_secure {
    if (!self.bindMobile ||
        ![self.bindMobile isKindOfClass:[NSString class]] ||
        self.bindMobile.length != 11) {
        // 经讨论这里只考虑11位手机号的情况，忽略其它复杂的号码情况
        return self.bindMobile;
    }
    NSString *securePhone = [self.bindMobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return securePhone;
}


@end
