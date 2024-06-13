//
//  MBAPMWakeupsPageMonitor.m
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import "MBAPMWakeupsPageMonitor.h"
#import "MBAPMWakeupsPageModel.h"
#import "MBAPMWakeupsUtil.h"
#import "MBAPMWakeupsMetric.h"
#import "MBAPMWakeupsMonitorConfig.h"

@interface MBAPMWakeupsPageMonitor ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, MBAPMWakeupsPageModel *> *pageWakeupsCache;

@property (nonatomic, strong) NSMutableSet<NSString *> *needReportPages;

@property (nonatomic, copy) MBAPMWakeupsReportBlock reportBlock;
@property (nonatomic, strong) MBAPMWakeupsMonitorConfig *wakeupsMonitorConfig;

@property (nonatomic, assign) BOOL isMonitoring;

@property (nonatomic, strong) NSDate *pauseTimestamp;
@property (nonatomic, assign) NSInteger pauseTimestampWakeups;

@end

@implementation MBAPMWakeupsPageMonitor

- (instancetype)initWithReportBlock:(MBAPMWakeupsReportBlock)reportBlock monitorConfig:(MBAPMWakeupsMonitorConfig *)config {
    self = [super init];
    if(self){
        self.reportBlock = reportBlock;
        self.wakeupsMonitorConfig = config;
        _needReportPages = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)startMonitor {
    _isMonitoring = YES;
    [self calculateHaltDuration];
}

- (void)stopMonitor {
    _isMonitoring = NO;
    _pauseTimestamp = [NSDate date];
    _pauseTimestampWakeups = [MBAPMWakeupsUtil getCurrentSystemWakeups];
}


- (void)calculateHaltDuration {
    if(_pauseTimestamp) {
        NSTimeInterval excludedDuration = [[NSDate date] timeIntervalSinceDate:_pauseTimestamp];
        NSInteger excludedWakeups = [MBAPMWakeupsUtil getCurrentSystemWakeups] - _pauseTimestampWakeups;
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.monitorQueue, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSArray<MBAPMWakeupsPageModel *> *currentPageModels = strongSelf.pageWakeupsCache.allValues;
            if(currentPageModels.count == 0){
                return;
            }
            for(MBAPMWakeupsPageModel *currentPageModel in currentPageModels){
                currentPageModel.excludedDuration = currentPageModel.excludedDuration + excludedDuration;
                currentPageModel.excludedWakeups = currentPageModel.excludedWakeups + excludedWakeups;
            }
        });
        _pauseTimestamp = nil;
        _pauseTimestampWakeups = 0;
    }
}

- (void)didPageIn:(MBAPMViewPageContext * _Nonnull)pageContext {
    if(!_isMonitoring){
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.monitorQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *pagePointer = pageContext.objcetPointer;
        if(!pagePointer) {
            return;
        }
        
        if(![strongSelf.needReportPages containsObject:pagePointer]){
            return;
        }
        
        if([strongSelf.pageWakeupsCache.allKeys containsObject:pagePointer]){
            return;
        }
        
        MBAPMWakeupsPageModel *model = [MBAPMWakeupsPageModel pageModelWithPageName:pageContext.pageName pagePointer:pagePointer];
        strongSelf.pageWakeupsCache[pagePointer] = model;
        
        [model startWithInitialWakeups:[MBAPMWakeupsUtil getCurrentSystemWakeups]];
       
    });
}

- (void)didPageOut:(MBAPMViewPageContext * _Nonnull)pageContext {
    if(!_isMonitoring){
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.monitorQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *pagePointer = pageContext.objcetPointer;
        
        if(!pagePointer) {
            return;
        }
        
        if(![strongSelf.needReportPages containsObject:pagePointer]){
            return;
        }
        
        if(![strongSelf.pageWakeupsCache.allKeys containsObject:pagePointer]){
            return;
        }
        
        MBAPMWakeupsPageModel *model = [strongSelf.pageWakeupsCache objectForKey:pagePointer];
        [model finishWithFinalWakeups:[MBAPMWakeupsUtil getCurrentSystemWakeups]];
        [strongSelf reportPageMetrics:model];
        
        strongSelf.pageWakeupsCache[pagePointer] = nil;
        
    });
}

- (void)didPageLoad:(MBAPMViewPageContext * _Nonnull)pageContext {
    if(!_isMonitoring){
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.monitorQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(![strongSelf.needReportPages containsObject:pageContext.objcetPointer]){
            [strongSelf.needReportPages addObject:pageContext.objcetPointer];
        }
    });
    
}

- (void)didPageDealloc:(MBAPMViewPageContext * _Nonnull)pageContext {
    if(!_isMonitoring){
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.monitorQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!pageContext.objcetPointer) return;
        if([strongSelf.needReportPages containsObject:pageContext.objcetPointer]){
            [strongSelf.needReportPages removeObject:pageContext.objcetPointer];
        }
    });
}

- (void)didRecordWakeups:(NSInteger)wakeups {
    if(!_isMonitoring){
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.monitorQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSArray<MBAPMWakeupsPageModel *> *currentPageModels = strongSelf.pageWakeupsCache.allValues;
        if(currentPageModels.count == 0){
            return;
        }
        for(MBAPMWakeupsPageModel *currentPageModel in currentPageModels){
            [currentPageModel updateWakeupsRecord:wakeups];
        }
    });
}


#pragma mark - report

- (void)reportPageMetrics:(MBAPMWakeupsPageModel *)model {
    if(![self isValidMetrics:model]){
        return;
    }
    MBAPMWakeupsMetric *metric = [[MBAPMWakeupsMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWakeups;
    metric.metricName = @"app.page_wakeups";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = model.averageWakeupsPerSec;
    metric.metricSections = @{
        @"average_wakeups": @(model.averageWakeupsPerSec),
        @"total_wakeups": @(model.totalWakeups),
        @"peak_wakeups": @(model.peakWakeups),
        @"duration": @(model.duration),
    };
    metric.attrs = @{
        @"start_time": @(model.enterTime.timeIntervalSince1970),
        @"end_time": @(model.exitTime.timeIntervalSince1970),
        @"background_duration": @(model.excludedDuration)
    };
    metric.pageName = model.pageName;
    self.reportBlock(metric);
}

- (BOOL)isValidMetrics:(MBAPMWakeupsPageModel *)model {
    return model.duration >= 1; // 如果展示时长小于1，就不上报
}

#pragma mark - getters & setters

- (NSMutableDictionary<NSString *, MBAPMWakeupsPageModel *> *)pageWakeupsCache {
    if(!_pageWakeupsCache){
        _pageWakeupsCache = [NSMutableDictionary new];
    }
    return _pageWakeupsCache;
}

- (dispatch_queue_t)monitorQueue {
    if(!_monitorQueue){
        _monitorQueue =  dispatch_queue_create("com.mb.wakeups.pagemonitor.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _monitorQueue;
}

@end
