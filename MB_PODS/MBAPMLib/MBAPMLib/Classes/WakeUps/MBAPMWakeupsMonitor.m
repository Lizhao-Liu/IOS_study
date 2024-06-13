//
//  MBAPMWakeupsMonitor.m
//  AAChartKit
//
//  Created by Lizhao on 2024/1/8.
//

#import "MBAPMWakeupsMonitor.h"
#import "MBDeviceInfo.h"
#import "MBAPMWakeupsPageMonitor.h"
#import "MBAPMWakeupsUtil.h"
#import "MBAPMWakeupsMonitorConfig.h"
#import "MBAPMWakeupsExceptionStateModel.h"
#import "MBAPMDoctorEventTracker.h"
#import <math.h>


@interface MBAPMWakeupsMonitor ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong, readwrite) dispatch_queue_t monitorQueue;
@property (nonatomic, assign) NSInteger lastWakeupsRecord;

@end


@implementation MBAPMWakeupsMonitor

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagWakeUps;
}

- (instancetype)init {
    self = [super init];
    if(self){
        _lastWakeupsRecord = 0;
    }
    return self;
}

- (void)start {
    [super start];
    [self registerObserver];
    [self startMonitor];
}

- (void)stop {
    [super stop];
    [self stopMonitor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self stopMonitor];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerObserver {
    // 注册前后台监听，进入后台时间停止计时器，暂停wakeups相关监控统计
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopMonitor)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startMonitor)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)startMonitor {
    [self startTimer];
    [self.exceptionMonitor startMonitor];
    [self.pageMonitor startMonitor];
}

- (void)stopMonitor {
    [self invalidateTimer];
    [self.exceptionMonitor stopMonitor];
    [self.pageMonitor stopMonitor];
}

- (void)startTimer {
    // 开启时机记录一次当前wakeups总量，避免统计1s后数据存在误差
    self.lastWakeupsRecord = [MBAPMWakeupsUtil getCurrentSystemWakeups];
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, self.monitorQueue);
    
    uint64_t interval = [self monitorConfig].dataCollectionInterval * NSEC_PER_SEC;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)interval);
    
    dispatch_source_set_timer(self.timer, startTime, interval, 0);
    __weak typeof(self) weakSelf = self;
    // 固定时间间隔查询当前进程的interrupt wakeups总数，计算增量
    dispatch_source_set_event_handler(self.timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSInteger interruptWakeups = [MBAPMWakeupsUtil getCurrentSystemWakeups];
        NSInteger lastWakeupsRecord = interruptWakeups - strongSelf.lastWakeupsRecord;
        strongSelf.lastWakeupsRecord = interruptWakeups;
        [strongSelf didRecordWakeups:lastWakeupsRecord];
//        NSLog(@"采集到 wakeups: %ld", lastWakeupsRecord);
    });
    dispatch_resume(self.timer);
}

- (void)invalidateTimer {
    if(self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)didRecordWakeups:(NSInteger)lastWakeupsRecord {
    [self.pageMonitor didRecordWakeups:lastWakeupsRecord];
    [self.exceptionMonitor didRecordWakeups:lastWakeupsRecord];
}

- (dispatch_queue_t)monitorQueue {
    if (!_monitorQueue) {
        _monitorQueue = dispatch_queue_create("com.mb.wakeups.monitor.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _monitorQueue;
}

- (MBAPMWakeupsPageMonitor *)pageMonitor {
    if(!_pageMonitor){
        __weak typeof(self) weakSelf = self;
        _pageMonitor = [[MBAPMWakeupsPageMonitor alloc] initWithReportBlock:^(MBAPMMetric * _Nonnull metric) {[weakSelf reportMetrics:metric];} monitorConfig:[weakSelf monitorConfig]];
    }
    return _pageMonitor;
}

- (MBAPMWakeupsExceptionMonitor *)exceptionMonitor {
    if(!_exceptionMonitor){
        __weak typeof(self) weakSelf = self;
        _exceptionMonitor = [[MBAPMWakeupsExceptionMonitor alloc] initWithReportBlock:^(MBAPMMetric * _Nonnull metric) {[weakSelf reportMetrics:metric];} monitorConfig:[weakSelf monitorConfig]];
        _exceptionMonitor.monitorQueue = weakSelf.monitorQueue;
    }
    return _exceptionMonitor;
}

- (MBAPMWakeupsMonitorConfig *)monitorConfig {
    if([self.config isKindOfClass:[MBAPMWakeupsMonitorConfig class]]){
        return (MBAPMWakeupsMonitorConfig *)self.config;
    }
    return nil;
}


@end

