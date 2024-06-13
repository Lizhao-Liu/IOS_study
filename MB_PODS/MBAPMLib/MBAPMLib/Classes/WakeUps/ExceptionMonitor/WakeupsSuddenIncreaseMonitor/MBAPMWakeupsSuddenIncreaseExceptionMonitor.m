//
//  MBAPMWakeupsSuddenIncreaseExceptionMonitor.m
//  MBAPMLib
//
//  Created by zhao on 2024/3/13.
//

#import "MBAPMWakeupsSuddenIncreaseExceptionMonitor.h"
#import "MBAPMWakeupsSuddenIncreaseExceptionModel.h"
#import "MBAPMDoctorEventTracker.h"
#import "MBAPMWakeupsMetric.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMWakeupsExceptionStateModel.h"
#import "MBAPMWakeupsExceptionStateUtil.h"
@import YYModel;

@interface MBAPMWakeupsSuddenIncreaseExceptionMonitor()

@property (nonatomic, copy) MBAPMWakeupsExceptionReportBlock reportBlock;

@property (nonatomic, strong) MBAPMWakeupsSuddenIncreaseExceptionModel *suddenIncreaseModel;

@property (nonatomic, assign) NSInteger lastWakeupsRecord;
@property (nonatomic, assign) NSInteger currentWakeupsRecord;
@property (nonatomic, assign) NSInteger suddenIncreaseReportThreshold;

@end


@implementation MBAPMWakeupsSuddenIncreaseExceptionMonitor

- (instancetype)initWithReportBlock:(MBAPMWakeupsExceptionReportBlock)reportBlock monitorConfig:(MBAPMWakeupsMonitorConfig *)config {
    self = [super init];
    if(self){
        _reportBlock = reportBlock;
        _suddenIncreaseModel = [MBAPMWakeupsSuddenIncreaseExceptionModel new];
        _suddenIncreaseReportThreshold = config.suddenIncreaseThreshold;
    }
    return self;
}

- (void)didRecordWakeups:(NSInteger)wakeups {
    self.currentWakeupsRecord = wakeups;
    [self checkAndReportSuddenIncreaseException];
    self.lastWakeupsRecord = self.currentWakeupsRecord;
    self.currentWakeupsRecord = 0;
}

- (void)checkAndReportSuddenIncreaseException{
    if(!self.suddenIncreaseModel.isRecording){ // 首次
        if([self didDetectSuddenIncrease]){ // 符合突增条件
            [self.suddenIncreaseModel startRecording];
            // 绑定事件
            [self bindActionEvent];
            // 增加突增记录
            [self addSuddenIncreaseValue:self.currentWakeupsRecord];
            // 闪退标记 （不自动清除）
            [self updateWakeupsExceptionState];
        } else { // 不符合突增条件
            // 过
        }
    } else { // 不是首次
        if(self.currentWakeupsRecord >= self.lastWakeupsRecord){ // 增加了
            // 增加突增记录
            [self addSuddenIncreaseValue:self.currentWakeupsRecord];
            // 闪退标记（不自动清除）
            [self updateWakeupsExceptionState];
        } else { // 下降了
            [self.suddenIncreaseModel endRecording];
            // 上报异常
            [self reportSuddenIncreaseExceptionMetrics];
            // 闪退标记设置自动清除
            [self autoCleanWakeupsExceptionState];
            // 清理
            [self.suddenIncreaseModel reset];
        }
    }
}


- (void)bindActionEvent {
    self.suddenIncreaseModel.actionModel = [[MBAPMDoctorEventTracker sharedInstance] getActionEvent];
}

- (void)addSuddenIncreaseValue:(NSInteger)val {
    [self.suddenIncreaseModel addRecordedWakeups:val];
}

- (BOOL)didDetectSuddenIncrease{
    if(self.currentWakeupsRecord <= self.suddenIncreaseReportThreshold){
        return NO;
    }
    // 0328: 突增检测判断涨幅，避免频繁上报
    if(self.lastWakeupsRecord > 600){
        return self.currentWakeupsRecord > self.lastWakeupsRecord * 1.1;
    } else {
        return self.currentWakeupsRecord > self.lastWakeupsRecord * 1.2;
    }
    return NO;
}


- (void)reportSuddenIncreaseExceptionMetrics {
    MBAPMWakeupsMetric *metric = [[MBAPMWakeupsMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWakeups;
    metric.metricName = @"app.wakeups_exception";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = self.suddenIncreaseModel.averageWakeups;
    metric.metricSections = @{@"continuous_count": @(self.suddenIncreaseModel.recordedWakeups.count)};
    /**
     字段说明：
     action_type :
     0-未知 1-pv 2-点击 3-进入前台 4-长链接/push
     
     action_feature:
     未知事件：固定 “unknown”
     pv事件：页面名称
     点击事件：页面名称.元素名称
     进入前台：enter_foreground
     长链接：消息类型.业务类型
     */
    metric.tags = @{
        @"error_feature": @"wakeups sudden increase",
        @"action_type": @(self.suddenIncreaseModel.actionModel.eventType),
        @"action_feature": self.suddenIncreaseModel.actionModel.eventFeature,
    };
    metric.attrs = @{@"values":[self.suddenIncreaseModel.recordedWakeups yy_modelToJSONString]};
    metric.pageName = [MBAPMCurrentPageInfo currentPageName];
    self.reportBlock(metric);
}

- (void)updateWakeupsExceptionState {
    MBAPMWakeupsExceptionStateModel *state = [MBAPMWakeupsExceptionStateModel new];
    state.type = MBAPMWakeupsExceptionTypeSuddenIncrease;
    state.continuousExceptionCount = self.suddenIncreaseModel.recordedWakeups.count;
    state.continuousExceptionValues = self.suddenIncreaseModel.recordedWakeups.copy;
    state.actionModel = self.suddenIncreaseModel.actionModel;
    state.pageId = [MBAPMCurrentPageInfo currentPageName];
    state.exceptionValue = self.currentWakeupsRecord;
    [[MBAPMWakeupsExceptionStateUtil sharedInstance] updateExceptionState:state forType:MBAPMWakeupsExceptionTypeSuddenIncrease];
}

- (void)autoCleanWakeupsExceptionState {
    [[MBAPMWakeupsExceptionStateUtil sharedInstance] fireCleanTimerForType:MBAPMWakeupsExceptionTypeSuddenIncrease];
}


@end
