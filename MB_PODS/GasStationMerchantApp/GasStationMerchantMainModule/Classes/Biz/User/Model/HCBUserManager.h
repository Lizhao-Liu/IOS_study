//
//  HCBUserManager.h
//  GasStationBiz
//
//  Created by ty on 2017/10/31.
//  Copyright © 2017年 56qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCBUser.h"

@interface HCBUserManager : NSObject

@property (nonatomic, strong) HCBUser *currentUser;
+ (instancetype)shareManager;


- (void)userLoginWithMobile:(NSString *)mobile
                       code:(NSString *)code
            onCompleteBlock:(void (^)(BOOL, NSString*))completeBlock;


- (void)setupAutoLogin;

@end
