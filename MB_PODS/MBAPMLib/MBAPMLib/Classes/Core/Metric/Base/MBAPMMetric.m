//
//  MBAPMMetric.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import "MBAPMMetric.h"
#import "MBAPMUUIDUtil.h"
#import "MBAPMAppStateUtil.h"
#import "MBDeviceInfo.h"
@import YMMModuleLib;

@implementation MBAPMMetric

- (instancetype)init {
    if (self == [super init]) {
        self.isPageLoading = -1;
    }
    return self;
}

- (NSString *)binaryImagesDescription {
    return [MBAPMUUIDUtil getBinaryImagesDescription];
}

- (NSString *)deviceLeval {
    return [MBDeviceInfo deviceScore] ?: @"";
}

- (NSInteger)appForeground {
    return [[MBAPMAppStateUtil shared] applicationState] != UIApplicationStateBackground?1:0;
}

@end
