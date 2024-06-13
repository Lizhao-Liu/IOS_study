//
//  HCBStationModel.h
//  GasStationBiz
//
//  Created by ty on 2017/11/14.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBBaseJSONModel.h"

@interface HCBStationModel : HCBBaseJSONModel

@property (nonatomic, strong) NSString *orgName;// = "成都公司";
@property (nonatomic, strong) NSString *gasStationId;// = 6631;
@property (nonatomic, strong) NSString *userId;// = 1154587;
@property (nonatomic, strong) NSString *mobile;// = "19112345678";
@property (nonatomic, strong) NSString *orgId;// = 8;
@property (nonatomic, strong) NSString *orgCode;// = "000100010000";
@property (nonatomic, strong) NSString *realname;// = "zhang";
@property (nonatomic, strong) NSString *gasStationName;// = "中化测试-001";
@property (nonatomic, strong) NSString *walletUid;// = "YPQBV20010133";
@property (nonatomic, assign) BOOL isWalletUserLoggedIn;

- (void)updateUserInfo:(NSDictionary *)dict;

- (BOOL)saveToUserDefaults;
- (NSMutableDictionary *)toDictionary;
- (void)readFromCache;
- (void)clearCache;
@end
