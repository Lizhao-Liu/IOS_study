//
//  HCBStationModel.m
//  GasStationBiz
//
//  Created by ty on 2017/11/14.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import "HCBStationModel.h"
@import MBFoundation;

static NSString *stationInfoKey = @"stationInfo_Key";

@implementation HCBStationModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isWalletUserLoggedIn = NO;
    }
    return self;
}

- (BOOL)saveToUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self toDictionary] forKey:stationInfoKey];
    return [userDefaults synchronize];
}

- (NSMutableDictionary *)toDictionary {
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    !self.orgName ? : [dic setObject:self.orgName forKey:@"orgName"];
    !self.gasStationId ? : [dic setObject:self.gasStationId forKey:@"gasStationId"];
    !self.userId ? : [dic setObject:self.userId forKey:@"userId"];
    !self.mobile ? : [dic setObject:self.mobile forKey:@"mobile"];
    !self.orgId ? : [dic setObject:self.orgId forKey:@"orgId"];
    !self.orgCode ? : [dic setObject:self.orgCode forKey:@"orgCode"];
    !self.realname ? : [dic setObject:self.realname forKey:@"realname"];
    !self.gasStationName ? : [dic setObject:self.gasStationName forKey:@"gasStationName"];
    !self.walletUid ? : [dic setObject:self.walletUid forKey:@"walletUid"];
    
    return dic;
}

- (void)readFromCache {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:stationInfoKey];
    self.orgName = [dic mb_objectForKeyIgnoreNil:@"orgName"];
    self.gasStationId = [dic mb_objectForKeyIgnoreNil:@"gasStationId"];
    self.userId = [dic mb_objectForKeyIgnoreNil:@"userId"];
    self.mobile = [dic mb_objectForKeyIgnoreNil:@"mobile"];
    self.orgId = [dic mb_objectForKeyIgnoreNil:@"orgId"];
    self.orgCode = [dic mb_objectForKeyIgnoreNil:@"orgCode"];
    self.realname = [dic mb_objectForKeyIgnoreNil:@"realname"];
    self.gasStationName = [dic mb_objectForKeyIgnoreNil:@"gasStationName"];
    self.walletUid = [dic mb_objectForKeyIgnoreNil:@"walletUid"];
}


- (void)clearCache {
    self.orgName = nil;
    self.gasStationId = nil;
    self.userId = nil;
    self.mobile = nil;
    self.orgId = nil;
    self.orgCode = nil;
    self.realname = nil;
    self.gasStationName = nil;
    self.walletUid = nil;
    self.isWalletUserLoggedIn = NO;
    [self saveToUserDefaults];
}

- (void)updateUserInfo:(NSDictionary *)dict {
    self.realname = [dict mb_stringForKey:@"realname"];
    self.mobile = [dict mb_stringForKey:@"mobile"];
    self.userId = [dict mb_stringForKey:@"userId"];
}

@end
