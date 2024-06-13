//
//  MBAPMWakeupsExceedLimitExceptionMonitor.m
//  MBAPMLib
//
//  Created by zhao on 2024/3/13.
//

#import "MBAPMWakeupsExceedLimitExceptionModel.h"
#import "MBAPMWakeupsExceedLimitExceptionMonitor.h"
#import "MBAPMWakeupsExceptionStateModel.h"
#import "MBAPMWakeupsExceptionStateUtil.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMWakeupsMetric.h"
@import YYModel;
@import MBDoctorService;

@interface MBAPMWakeupsExceedLimitExceptionMonitor ()

@property (nonatomic, copy) MBAPMWakeupsExceptionReportBlock reportBlock;

@property (nonatomic, assign) NSInteger wakeupsLimitPerSec;
@property (nonatomic, assign) NSInteger durationLimit;
@property (nonatomic, assign) NSInteger monitorInterval;

@property (nonatomic, strong) MBAPMWakeupsExceedLimitExceptionModel *monitoringModel;

@property (nonatomic, assign) NSInteger currentWakeupsRecord;

@end

@implementation MBAPMWakeupsExceedLimitExceptionMonitor

- (instancetype)initWithReportBlock:(MBAPMWakeupsExceptionReportBlock)reportBlock monitorConfig:(MBAPMWakeupsMonitorConfig *)config {
    self = [super init];
    if(self){
        _reportBlock = reportBlock;
        _wakeupsLimitPerSec = config.wakeupsLimitPerSec;
        _durationLimit = config.monitorDurationLimit;
        _monitorInterval = config.dataCollectionInterval;
        _currentWakeupsRecord = 0;
        _monitoringModel = [MBAPMWakeupsExceedLimitExceptionModel new];
        
    }
    return self;
}


- (void)didRecordWakeups:(NSInteger)wakeups {
    
    self.currentWakeupsRecord = wakeups;
    
    // 更新采集数据
    [self updateMonitoringData];
    
    // 检查并上报数据
    [self checkAndReportLimitExceededException];

}


- (void)updateMonitoringData {
    self.monitoringModel.wakeupsDurationSampled  = self.monitoringModel.wakeupsDurationSampled + self.monitorInterval;
    self.monitoringModel.wakeupsSampled = self.monitoringModel.wakeupsSampled + self.currentWakeupsRecord;
    if(self.currentWakeupsRecord > 300){
        if(self.monitoringModel.sectionInRecording){ // 存在正在记录的wakeups section
            // 添加数据
            [self.monitoringModel addSectionData:self.currentWakeupsRecord];
        } else { // 首次
            // 重新开启一段section记录
            [self.monitoringModel startSectionRecording];
            [self.monitoringModel addSectionData:self.currentWakeupsRecord];
        }
    } else {
        // 结束分段记录
        if(self.monitoringModel.sectionInRecording){
            [self.monitoringModel endSectionRecording];
        }
    }
}


- (void)checkAndReportLimitExceededException {
    if([self wakeupsLimitExceeded] && ![self durationLimitExceeded]) {
        CGFloat averageWakeups = self.monitoringModel.wakeupsSampled / self.monitoringModel.wakeupsDurationSampled;
        if(averageWakeups > 300){ // 调高wakeups平均值闪退标记阈值
            [self updateWakeupsExceptionState:averageWakeups];
        }
        [self reportLimitExceededException:averageWakeups];
        [self.monitoringModel reset];
    } else if ([self durationLimitExceeded]) {
        [self.monitoringModel reset];
    }
}

- (BOOL)wakeupsLimitExceeded {
    return self.monitoringModel.wakeupsSampled > self.wakeupsLimitPerSec * self.durationLimit;
}

- (BOOL)durationLimitExceeded {
    return self.monitoringModel.wakeupsDurationSampled > self.durationLimit;
}


- (void)updateWakeupsExceptionState:(CGFloat)averageWakeups {
    MBAPMWakeupsExceptionStateModel *state = [MBAPMWakeupsExceptionStateModel new];
    state.type = MBAPMWakeupsExceptionTypeAvgLimitExceeded;
    state.pageId = [MBAPMCurrentPageInfo currentPageName];
    state.exceptionValue = averageWakeups;
    [[MBAPMWakeupsExceptionStateUtil sharedInstance] updateExceptionState:state forType:MBAPMWakeupsExceptionTypeAvgLimitExceeded];
    [[MBAPMWakeupsExceptionStateUtil sharedInstance] fireCleanTimerForType:MBAPMWakeupsExceptionTypeAvgLimitExceeded];
}


- (void)reportLimitExceededException: (CGFloat)averageWakeups {
    // 正在记录中的异常section，表示wakeups在上报时机还没有跌落,补上当前时间作为section结束时间
    if(self.monitoringModel.sectionInRecording){
        [self.monitoringModel endSectionRecording];
    }
    
    MBAPMWakeupsMetric *metric = [[MBAPMWakeupsMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWakeups;
    metric.metricName = @"app.wakeups_exception";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = averageWakeups;
    
    // 监控数据信息
    metric.metricSections = @{
        @"wakeups_caused": @(self.monitoringModel.wakeupsSampled), //监控wakeups总数
        @"wakeups_duration": @(self.monitoringModel.wakeupsDurationSampled), //监控wakeups时长
        @"heavy_sections_count": @(self.monitoringModel.recordedSections.count)
    };
    
    if(self.monitoringModel.recordedSections.count > 0){
        metric.attrs = @{@"heavy_sections": [self.monitoringModel.recordedSections yy_modelToJSONString]};
    }
    
    metric.tags = @{
        @"error_feature": @"wakeups limit exceeded"
    };

    // 其他信息 （监控阈值、异常详情)
    NSString *errorDescription = [NSString stringWithFormat:@"%ld wakeups over the last %ld seconds (%f wakeups per second average), exceeding limit of %ld wakeups per second over %ld seconds", self.monitoringModel.wakeupsSampled, self.monitoringModel.wakeupsDurationSampled, averageWakeups, self.wakeupsLimitPerSec, self.durationLimit];
    
    metric.extraData = @{
        @"wakeups_limit" : @(self.durationLimit * self.wakeupsLimitPerSec),
        @"duration_limit": @(self.durationLimit),
        @"wakeups_limit_per_sec": @(self.wakeupsLimitPerSec),
        @"error_description": errorDescription // 异常详情
    };
 
    self.reportBlock(metric);
}


@end
