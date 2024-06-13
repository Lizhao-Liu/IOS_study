//
//  MBAPMWakeupsContinuousHightExceptionMonitor.m
//  MBAPMLib
//
//  Created by zhaozhao on 2024/3/13.
//

#import "MBAPMWakeupsContinuousHighExceptionMonitor.h"
#import "MBAPMWakeupsContinuousHighExceptionModel.h"
#import "MBAPMWakeupsMetric.h"
#import "MBAPMWakeupsExceptionStateModel.h"
#import "MBAPMWakeupsExceptionStateUtil.h"
#import "MBAPMCurrentPageInfo.h"
@import YYModel;

@interface MBAPMWakeupsContinuousHighExceptionMonitor ()

@property (nonatomic, copy) MBAPMWakeupsExceptionReportBlock reportBlock;

@property (nonatomic, assign) NSInteger lastWakeupsRecord;
@property (nonatomic, assign) NSInteger currentWakeupsRecord;

@property (nonatomic, assign) NSInteger continuousHighReportThreshold;

@property (nonatomic, strong) MBAPMWakeupsContinuousHighExceptionModel * continuousHighModel;


@end

@implementation MBAPMWakeupsContinuousHighExceptionMonitor


- (instancetype)initWithReportBlock:(MBAPMWakeupsExceptionReportBlock)reportBlock monitorConfig:(MBAPMWakeupsMonitorConfig *)config {
    self = [super init];
    if(self){
        _reportBlock = reportBlock;
        _continuousHighModel = [MBAPMWakeupsContinuousHighExceptionModel new];
        _continuousHighReportThreshold = config.heavySectionReportThreshold;
    }
    return self;
}


- (void)didRecordWakeups:(NSInteger)wakeups {
    self.currentWakeupsRecord = wakeups;
    [self checkAndReportContinuousHighException];
    self.lastWakeupsRecord = self.currentWakeupsRecord;
    self.currentWakeupsRecord = 0;
}

- (void)checkAndReportContinuousHighException {
    if(self.currentWakeupsRecord > self.continuousHighReportThreshold){ // 超过连续高位门槛值
        if(self.continuousHighModel.isRecording){ // 不是首次
            [self.continuousHighModel addRecordedWakeups:self.currentWakeupsRecord];
        } else { // 首次
            [self.continuousHighModel startRecording];
            [self.continuousHighModel addRecordedWakeups:self.currentWakeupsRecord];
        }
        [self updateWakeupsExceptionState]; // 更新异常状态
    } else {
        if(self.continuousHighModel.isRecording){ // 结束高位，上报异常
            [self.continuousHighModel endRecording];
            [self autoCleanWakeupsExceptionState];
            [self reportContinuousHighExceptionMetrics];
            [self.continuousHighModel reset];
        }
    }
}

- (void)reportContinuousHighExceptionMetrics {
    MBAPMWakeupsMetric *metric = [[MBAPMWakeupsMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWakeups;
    metric.metricName = @"app.wakeups_exception";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = self.continuousHighModel.averageWakeups; // 平均值

    metric.tags = @{
        @"error_feature": @"wakeups continuous high"
    };
    metric.metricSections = @{
        @"continuous_count": @(self.continuousHighModel.recordedWakeups.count) // 异常wakeups数量
    };
    
    metric.attrs = @{
        @"values": [self.continuousHighModel.recordedWakeups yy_modelToJSONString],
        @"startTime": self.continuousHighModel.startTime,
        @"endTime": self.continuousHighModel.endTime
    };
    
    self.reportBlock(metric);
}

- (void)updateWakeupsExceptionState {
    // 更新 wakeups state
    MBAPMWakeupsExceptionStateModel *state = [MBAPMWakeupsExceptionStateModel new];
    state.type = MBAPMWakeupsExceptionTypeContinuousHigh;
    state.exceptionValue = self.currentWakeupsRecord;
    state.continuousExceptionCount = self.continuousHighModel.recordedWakeups.count;
    state.continuousExceptionValues = self.continuousHighModel.recordedWakeups;
    state.pageId = [MBAPMCurrentPageInfo currentPageName];
    [[MBAPMWakeupsExceptionStateUtil sharedInstance] updateExceptionState:state forType:MBAPMWakeupsExceptionTypeContinuousHigh];;
}

- (void)autoCleanWakeupsExceptionState {
    [[MBAPMWakeupsExceptionStateUtil sharedInstance] fireCleanTimerForType: MBAPMWakeupsExceptionTypeContinuousHigh];
}

@end
