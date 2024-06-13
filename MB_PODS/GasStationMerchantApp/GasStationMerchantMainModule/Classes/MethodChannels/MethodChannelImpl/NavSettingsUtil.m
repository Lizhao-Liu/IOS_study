//
//  NavSettingsUtil.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavSettingsUtil.h"
#import "HCBLoginRequest.h"
#import "HCBUserManager.h"
#import "HCBStationModel.h"
#import "HCBStationManager.h"
#import <JSONKIT/JSONKIT.h>
@import YMMUserModuleService;
@import HCBAppBasis;
@implementation NavSettingsUtil

- (void)logout:(NSArray *)arguments {
    [[HCBUserManager shareManager].currentUser clearUserDefaults];
    [[HCBSessionManager sharedManager] clearSession];
    [[HCBAppBasis defaultAppBasis] logout];
    [HCBLoginRequest reqLoginOutWithCompleteBlock:nil onFailedBlock:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MBUserLogoutNotification object:nil];
    !self.result ?: self.result(@"OK");
}

- (void)canModifyHost:(NSArray *)arguments {
    !self.result ?: self.result(@"NO");
}

- (void)getAccountInfo:(NSArray *)arguments {
    HCBStationModel *station = [HCBStationManager shareManager].stationModel;
    if (!station) {
        !self.result ?: self.result(@"");
    }
    NSMutableDictionary *stationDic = [station toDictionary].mutableCopy;
    
    [stationDic setObject:@([station.gasStationId integerValue]) forKey:@"gasStationId"];
    NSString *stationJson = [stationDic JSONStringHCB];
    !self.result ?: self.result(stationJson);
}

- (void)getAppVersion:(NSArray *)arguments {
    !self.result ?: self.result(NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"]);
}
@end
