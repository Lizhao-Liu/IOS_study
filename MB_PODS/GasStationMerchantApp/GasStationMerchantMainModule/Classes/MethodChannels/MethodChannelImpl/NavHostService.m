//
//  NavHostService.m
//  Runner
//
//  Created by heyAdrian on 2018/10/21.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "NavHostService.h"
#import "HCBStationManager.h"
#import "HCBStationModel.h"
@import MBFoundation;
@import MBWalletModuleService;
@implementation NavHostService

- (void)getGasStationName:(NSArray *)arguments {
    HCBStationModel *station = [HCBStationManager shareManager].stationModel;
    if (!station) {
        !self.result ?: self.result(@"");
    }
    if(!station.gasStationName){
        !self.result ?: self.result(@"");
    }
    !self.result ?: self.result(station.gasStationName);
    
}

- (void)getGasStationId:(NSArray *)arguments {
    HCBStationModel *station = [HCBStationManager shareManager].stationModel;
    if (!station) {
        !self.result ?: self.result(@"");
    }
    if(!station.gasStationId){
        !self.result ?: self.result(@"");
    }
    !self.result ?: self.result(station.gasStationId);
}


// 设置油站信息
/**
  1294期 - 油站信息存在两种情况设置：
  1. 进入flutter首页，首页加载过程中调用 user/query 获取默认油站信息并传递给原生页面设置油站信息缓存
  2. 首页切换油站，选择油站后，flutter传入更新油站信息缓存
 */
/**
 arguments[0]: gasStationName
 arguments[1]: gasStationId
 arguments[2]: walletUid
 */
- (void)setGasStationInfo:(NSArray *)arguments {
    if (!arguments || arguments.count != 3) {
        !self.result ?: self.result(@(NO));
    } else {
        id gasStationName = arguments[0];
        id gasStationId = arguments[1];
        if([gasStationId isKindOfClass:[NSNumber class]]){
            gasStationId = [gasStationId stringValue];
        }
        if([NSString mb_isNilOrEmpty:gasStationName] || [NSString mb_isNilOrEmpty:gasStationId]) {
            !self.result ?: self.result(@(NO));
        } else {
            NSString *gasStationNameStr = (NSString *)gasStationName;
            NSString *gasStationIdStr = (NSString *)gasStationId;
            HCBStationModel *station = [HCBStationManager shareManager].stationModel;
            if(station){
                station.gasStationId = gasStationIdStr;
                station.gasStationName = gasStationNameStr;
                id walletUid = arguments[2];
                if([walletUid isKindOfClass:[NSNumber class]]){
                    walletUid = [walletUid stringValue];
                }
                if (![NSString mb_isNilOrEmpty:walletUid]) {
                    NSString *walletUidStr = (NSString *)walletUid;
                    station.walletUid = walletUidStr;
                    station.isWalletUserLoggedIn = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:MBWalletNeedLoginNotification object:nil]; //发送钱包登录通知
                } else {
                    station.walletUid = nil;
                    station.isWalletUserLoggedIn = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:MBWalletNeedLogoutNotification object:nil]; //发送钱包登出通知
                }
                !self.result ?: self.result(@(YES));
            }
            !self.result ?: self.result(@(NO));
        }
    }
}

@end
