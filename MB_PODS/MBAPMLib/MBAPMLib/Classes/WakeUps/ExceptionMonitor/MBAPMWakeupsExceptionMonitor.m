//
//  MBAPMWakeupsExceptionMonitor.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/10.
//

#import "MBAPMWakeupsExceptionMonitor.h"
#import "MBAPMWakeupsExceedLimitExceptionMonitor.h"
#import "MBAPMWakeupsSuddenIncreaseExceptionMonitor.h"
#import "MBAPMWakeupsContinuousHighExceptionMonitor.h"
#import "MBAPMWakeupsExceptionStateUtil.h"
@import MBDoctorService;

@interface MBAPMWakeupsExceptionMonitor ()

@property (nonatomic, assign) BOOL isMonitoring;

@property (nonatomic, strong) MBAPMWakeupsExceedLimitExceptionMonitor *exceedLimitMonitor;

@property (nonatomic, strong) MBAPMWakeupsSuddenIncreaseExceptionMonitor *suddenIncreaseMonitor;

@property (nonatomic, strong) MBAPMWakeupsContinuousHighExceptionMonitor *continuousHighMonitor;

@end

@implementation MBAPMWakeupsExceptionMonitor

- (instancetype)initWithReportBlock:(MBAPMWakeupsReportBlock)reportBlock 
                      monitorConfig:(MBAPMWakeupsMonitorConfig *)config {
    self = [super init];
    if(self){
        _exceedLimitMonitor = [[MBAPMWakeupsExceedLimitExceptionMonitor alloc] initWithReportBlock:reportBlock monitorConfig:config];
        _suddenIncreaseMonitor = [[MBAPMWakeupsSuddenIncreaseExceptionMonitor alloc] initWithReportBlock:reportBlock monitorConfig:config];
        _continuousHighMonitor = [[MBAPMWakeupsContinuousHighExceptionMonitor alloc] initWithReportBlock:reportBlock monitorConfig:config];

        // app启动后，检查上次app启动是否存在连续wakeups异常后退出现象，并上报埋点
        [[MBAPMWakeupsExceptionStateUtil sharedInstance] checkLastStateAndReportExceptionCrash];
    }
    return self;
}

- (void)startMonitor {
    _isMonitoring = YES;
}

- (void)stopMonitor {
    _isMonitoring = NO;
}

- (void)didRecordWakeups:(NSInteger)wakeupsRecord {
    if(!_isMonitoring){
        return;
    }
    [self.suddenIncreaseMonitor didRecordWakeups:wakeupsRecord];
    [self.continuousHighMonitor didRecordWakeups:wakeupsRecord];
    [self.continuousHighMonitor didRecordWakeups:wakeupsRecord];
}

@end
