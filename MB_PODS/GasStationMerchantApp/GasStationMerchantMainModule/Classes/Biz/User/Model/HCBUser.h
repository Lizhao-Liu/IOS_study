//
//  HCBUser.h
//  GasStationBiz
//
//  Created by ty on 2017/10/31.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCBUser : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *hw;
@property (nonatomic, strong) NSString *daid;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *d;
@property (nonatomic, strong) NSString *bindMobile;
@property (nonatomic, strong, readonly) NSString *bindMobile_secure;
@property (nonatomic, strong) NSString *attachment;
@property (nonatomic, strong) NSString *un;
@property (nonatomic, strong) NSString *m;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) NSString *dv;
@property (nonatomic, strong) NSString *authStatus;

@property (nonatomic) BOOL isLogined;


- (BOOL)saveToUserDefaults;
+ (id)getFromUserDefaults;
+ (HCBUser *)fromDictionary:(NSDictionary *)dic;

- (void)clearUserDefaults;
@end
