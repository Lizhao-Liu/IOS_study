//
//  MBAPMDataManager.m
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import "MBAPMDataManager.h"

@import YYModel;
@import MBFoundation;
@import MBLogLib;

#define kProcessDataModel @"kProcessDataModel"
#define kDayDataModel @"kDayDataModel"

@interface MBAPMDataManager ()
@property (nonatomic, strong) MBAPMDataModel *processDataModel;
@property (nonatomic, strong) MBAPMDataModel *dayDataModel;
@property (nonatomic, strong) MBAPMDataModel *minDataModel;

@end

@implementation MBAPMDataManager

+ (instancetype)sharedInstance {
    static MBAPMDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - data read

- (void)readCacheDayData {
    // 天流量
    NSString *dayStr = [[NSUserDefaults standardUserDefaults] objectForKey:kDayDataModel];
    if (dayStr.length) {
        MBAPMDataModel *lastDayModel = [MBAPMDataModel yy_modelWithJSON:dayStr];
        NSString *curDay = [[NSDate date] mb_convertWith:@"yyyyMMdd"];
        if ([curDay isEqualToString:lastDayModel.date]) { // 是同一天
            self.dayDataModel = lastDayModel;
        } else { // 非同一天, 直接进行数据上报
            if (self.uploadTraffic) {
                self.uploadTraffic(lastDayModel);
            }
            // 清空磁盘数据
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kDayDataModel];
        }
    }
}

#pragma mark - public mehtod

- (void)updateTrafficModel:(MBAPMModel *)model {
    // 进程
    self.processDataModel.sumTraffic += model.traffic;
    if (model.isForeground) {
        self.processDataModel.foregroundSumTraffic += model.traffic;
    } else {
        self.processDataModel.backgroundSumTraffic += model.traffic;
    }
    self.processDataModel.upSumTraffic += model.upTraffic;
    self.processDataModel.downSumTraffic += model.downTraffic;
    if (model.networkStatus == NetworkStatusWifi) {
        self.processDataModel.wifiSumTraffic += model.traffic;
    } else if (model.networkStatus == NetworkStatusMobile) {
        self.processDataModel.mobileSumTraffic += model.traffic;
    }
    
    // 天
    self.dayDataModel.sumTraffic += model.traffic;
    if (model.isForeground) {
        self.dayDataModel.foregroundSumTraffic += model.traffic;
    } else {
        self.dayDataModel.backgroundSumTraffic += model.traffic;
    }
    self.dayDataModel.upSumTraffic += model.upTraffic;
    self.dayDataModel.downSumTraffic += model.downTraffic;
    if (model.networkStatus == NetworkStatusWifi) {
        self.dayDataModel.wifiSumTraffic += model.traffic;
    } else if (model.networkStatus == NetworkStatusMobile) {
        self.dayDataModel.mobileSumTraffic += model.traffic;
    }
    
    // 10 分钟
    self.minDataModel.sumTraffic += model.traffic;
    if (model.isForeground) {
        self.minDataModel.foregroundSumTraffic += model.traffic;
    } else {
        self.minDataModel.backgroundSumTraffic += model.traffic;
    }
    self.minDataModel.upSumTraffic += model.upTraffic;
    self.minDataModel.downSumTraffic += model.downTraffic;
    if (model.networkStatus == NetworkStatusWifi) {
        self.minDataModel.wifiSumTraffic += model.traffic;
    } else if (model.networkStatus == NetworkStatusMobile) {
        self.minDataModel.mobileSumTraffic += model.traffic;
    }
}

- (void)cacheTraffic {
    self.processDataModel.calculationPeriod += 1;// 计算周期 +1
    self.dayDataModel.calculationPeriod += 1;// 计算周期 +1

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 进程
    NSString *processStr = [self.processDataModel yy_modelToJSONString];
    [defaults setObject:processStr forKey:kProcessDataModel];
    
    // 天
    if (!self.dayDataModel.date || [self.dayDataModel.date isEqualToString:[[NSDate date] mb_convertWith:@"yyyyMMdd"]]) { // 是同一天的数据, 储存
        self.dayDataModel.date = [[NSDate date] mb_convertWith:@"yyyyMMdd"];
        NSString *dayStr = [self.dayDataModel yy_modelToJSONString];
        [defaults setObject:dayStr forKey:kDayDataModel];
    } else { // 跨天了,直接上报
        if (self.uploadTraffic) {
            self.uploadTraffic(self.dayDataModel.copy);
        }
        MBModuleDebug("MBAPMLib", @"流量 - 清除上一天数据");
        // 清空缓存数据
        if (_dayDataModel) {
            _dayDataModel = nil;
        }
        // 清空磁盘数据
        [defaults setObject:@"" forKey:kDayDataModel];
    }
}

- (nullable MBAPMDataModel *)lastProcessData {
    NSString *processStr = [[NSUserDefaults standardUserDefaults] objectForKey:kProcessDataModel];
    if (processStr.length) {
        MBModuleDebug("MBAPMLib", @"流量 - 清空上个进程数据");
        // 上传之后清空上次数据
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kProcessDataModel];
        return [MBAPMDataModel yy_modelWithJSON:processStr.copy];
    } else {
        return nil;
    }
}

- (MBAPMDataModel *)lastMinData {
    MBAPMDataModel *model = _minDataModel.copy;
    // 重置当前分钟数据
    if (_minDataModel) {
        MBModuleDebug("MBAPMLib", @"流量 - 清空 10 分钟数据");
        _minDataModel = nil;
    }
    return model;
}
#pragma mark - getters

- (MBAPMDataModel *)processDataModel {
    if (!_processDataModel) {
        _processDataModel = [[MBAPMDataModel alloc] init];
        _processDataModel.type = MBAPMDataModelTypeProcess;
    }
    return _processDataModel;
}

- (MBAPMDataModel *)dayDataModel {
    if (!_dayDataModel) {
        _dayDataModel = [[MBAPMDataModel alloc] init];
        _dayDataModel.type = MBAPMDataModelTypeDay;
    }
    return _dayDataModel;
}

- (MBAPMDataModel *)minDataModel {
    if (!_minDataModel) {
        _minDataModel = [[MBAPMDataModel alloc] init];
        _minDataModel.type = MBAPMDataModelTypeMin;
    }
    return _minDataModel;
}

@end
