//
//  MBAPMWakeupsMonitorConfig.m
//  AAChartKit
//
//  Created by Lizhao on 2024/1/8.
//

#import "MBAPMWakeupsMonitorConfig.h"

@implementation MBAPMWakeupsMonitorConfig

- (instancetype)init {
    self = [super init];
    if(self){
        _monitorDurationLimit = MBAPM_TASK_WAKEUPS_DEFAULT_MINITOR_INTERVAL;
        _wakeupsLimitPerSec = MBAPM_TASK_WAKEUPS_DEFAULT_MONITOR_LIMIT_PER_SECOND;
        _dataCollectionInterval = MBAPM_TASK_WAKEUPS_DEFAULT_DATA_COLLECTION_INTERVAL;
        _heavySectionReportThreshold = MBAPM_TASK_WAKEUPS_DEFAULT_REPORT_THRESHOLD;
        _suddenIncreaseThreshold = MBAPM_TASK_WAKEUPS_SUDDEN_INCREASE_DEFAULT_THRESHOLD;
        self.isEnable = YES;
    }
    return self;
}

@end

@implementation MBAPMConfiguration(WakeupsMonitor)

- (MBAPMWakeupsMonitorConfig *)wakeupsMonitorConfig {
    return objc_getAssociatedObject(self, @selector(wakeupsMonitorConfig));
}

- (void)setWakeupsMonitorConfig:(MBAPMWakeupsMonitorConfig *)wakeupsMonitorConfig {
    objc_setAssociatedObject(self, @selector(wakeupsMonitorConfig), wakeupsMonitorConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

