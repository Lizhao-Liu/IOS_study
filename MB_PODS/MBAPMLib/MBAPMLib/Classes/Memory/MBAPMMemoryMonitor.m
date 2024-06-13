//
//  MBMemoryMonitor.m
//  YMMPerformanceModule
//
//  Created by seal on 2020/5/27.
//

#import "MBAPMMemoryMonitor.h"
#import "MBMatrixWechatManager.h"
#import "MBAPMMemoryMetric.h"
#import "MBAPMSystemDataGather.h"
#import "MBAPMContext.h"
#import "MBAPMLogDef.h"
#import "MBAPMUUIDUtil.h"
#import "MBAPMDataUploader.h"
#import "UIImage+MBImageSize.h"
#import "MBMemoryLogDetector.h"
#import "MBAPMCrashMetric.h"
#import "MBAPMStorageUtil.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMMemoryUtil.h"
#import "MBDeviceInfo.h"
#import "MBAPMCrashHandlerHook.h"
#import "NSObject+MemoryLeak.h"
#import "MBAPMMemoryUtil.h"
#import "MBAPMTimeUtil.h"
#import "MBMemoryOOMCounter.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMDoctorEventTracker.h"

@import MBAPMServiceLib;
@import MBFoundation;
@import MBUIKit;
@import MBProjectConfig;
@import MBBuildPreLib;

static NSString * const kMetricDataKeyGatherfrequency = @"timeInterval";
static NSString * const kMMKV_StorageOOMInfo = @"kMMKV_APM_StorageOOMInfo";

@interface MBAPMMemoryMonitor ()

@property (nonatomic, strong) MBMemoryLogDetector *memoryLogDet;
@property (nonatomic, strong) MBMemoryOOMCounter *memoryOOMCounter;

@end

@implementation MBAPMMemoryMonitor

- (void)start {
    if (self.context.configuration.enableHookBCECheckerFrida) {
        [MBAPMCrashHandlerHook hookBCECheckerFrida];
    }
    if (![MBDeviceInfo canEnableMonitor]) {
        MBAPMLogInfo(@"memory monitor can't be started on simulator or debugging status");
        return;
    }
    [super start];
    [self startMemoryMonitor];
}

- (void)startMemoryMonitor {
    __weak typeof(self) weakSelf = self;
    
    MBAPMLogInfo(@"Memory monitor start");
    /// OOM
    BOOL localAnalysisNeedOpenMatrixOOM = [self needOpenMatrixOOM];
    BOOL openMatrixOOM = self.context.configuration.enableFOOMMonitor || localAnalysisNeedOpenMatrixOOM;
    if (openMatrixOOM) {
        [self startMatrixOOM];
    }
    
    /// memory warning
    // oom收集
    if (self.context.configuration.enableMemoryWarningLog) {
        [self.memoryOOMCounter setCallBack:^(BOOL isOOM, BOOL isBackground) {
            MBAPMLogInfo(@"memory monitor memoryOOMCounter, isOOM: %d, isBackground: %d", isOOM, isBackground);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                BOOL crashUploaded = [MBAPMAppStateUtil shared].lastLaunchCrashReported;
                MBAPMLogInfo(@"memory monitor memoryOOMCounter, isOOM: %d, isBackground: %d, matrixOOMUpload: %d", isOOM, isBackground, crashUploaded);
                if (isOOM && !isBackground) {
                    if (!crashUploaded) {
                        MBAPMLogInfo(@"memory monitor memoryOOMCounter, reported");
                        [MBAPMAppStateUtil shared].lastLaunchCrashReported = YES;
                        [weakSelf reportFOOMCounter];
                        [MBAPMMemoryMonitor updateStorageOOMInfo:YES];
                    }
                } else {
                    [MBAPMMemoryMonitor updateStorageOOMInfo:NO];
                }
            });
        }];
    }
    // 上报memory warning
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    /// memory log
    // 固定分钟上报；页面首次内存；页面平均内存上报
    self.memoryLogDet.timeIntervals = self.context.configuration.memoryLogIntervals;
    if (self.context.configuration.enableMemoryLog) {
        [self startMemoryLogMonitor];
    }
    
    // 补充，固定百分比递增时上报
    if (self.context.configuration.enableMemoryWarningLog) {
        [self.memoryLogDet begainRefreshMemoryLogWithCallBack:^(MBMemoryLogModel * _Nonnull model) {
            [weakSelf uploadMemeoryLogWithModel:model];
        }];
    }
    
    
    /// big image
    if (self.context.configuration.enableLargeImageMonitor || self.context.configuration.enableFOOMMonitor) {
        [self startBigImageMonitor];
    }
    
    /// Leak
    BOOL openLeakFinder = self.context.configuration.enableLeakMonitor || (self.context.configuration.enableLeakMonitorOnOOM && self.context.configuration.enableFOOMMonitor);
    [NSObject setEnableLeaksFinder:openLeakFinder];
    [NSObject setEnableLeaksAlert:self.context.configuration.debugEnableLeakAlert];
    [NSObject setEnableCheckRetainCycle:self.context.configuration.debugEnableRetainCycleFinder];
    
}

- (BOOL)needOpenMatrixOOM {
    if ([[MBDeviceInfo deviceScore] isEqual: @"low"]) {
        return NO;
    }
    NSString *configS = self.context.configuration.foomAutoStartConfig;
    NSArray *configA = [configS componentsSeparatedByString:@","];
    
    NSInteger launchTimesConfig = 3;
    NSInteger memoryWarningErrorTimesConfig = 2;//最近launchTimesConfig次启动发生崩溃阈值
    NSInteger recentNoErrorTimes = 1; //最近一次没有发生oom，进行清空
    if (configA.count > 2) {
        launchTimesConfig = MAX([configA.firstObject integerValue], launchTimesConfig);
        memoryWarningErrorTimesConfig = MAX([configA[1] integerValue], memoryWarningErrorTimesConfig);
        recentNoErrorTimes = MAX([configA[2] integerValue], recentNoErrorTimes);
    }
    
    NSUInteger exitInfo = [self.memoryOOMCounter storageWarningExitInfo];
    NSUInteger mixCount = 0;
    NSUInteger recentNoMixCount = 0;
    for (int i = 0; i < (MIN(launchTimesConfig, 32)); i++) {
        BOOL mix = (exitInfo >> i) & 1;
        mixCount += mix;
        if (i < recentNoErrorTimes && mix == NO) {
            recentNoMixCount += 1;
        }
    }
    if (recentNoMixCount == recentNoErrorTimes) {
        [self.memoryOOMCounter cleanStorageWarningExitInfo];
    }
    
    return mixCount >= memoryWarningErrorTimesConfig;
}

- (void)startMatrixOOM {
    __weak typeof(self) weakSelf = self;
    [[MBMatrixWechatManager sharedInstance] setFOOMReportBlock:^(MatrixIssue * _Nonnull issue) {
        MBAPMLogInfo(@"memory monitor aatrixIssue, isOOM: yes, isBackground: %ld", (long)[[MBAPMAppStateUtil shared] lastLaunchApplicationState]);
        [MBAPMAppStateUtil shared].lastLaunchCrashReported = YES;
        if (self.memoryOOMCounter.lastExitWithMemoryWarning || [MBMemoryLogDetector appLaunchMBLastMemoryPercent] > 0.25 || [MBMemoryLogDetector appLaunchMBLastFreeMemoryPercent] < 0.3)  {
            [weakSelf uploadFOOMData:issue];
            [MBAPMMemoryMonitor updateStorageOOMInfo:YES];
        }
    }];
}

- (void)stop {
    [super stop];
    MBAPMLogInfo(@"Memory monitor stop");
    if (self.context.configuration.enableLargeImageMonitor || self.context.configuration.enableFOOMMonitor) {
        [UIImage stopMonitorImageSize];
    }
    
    // 内存统计单独上报，其他要跟随oom一起开启
    if (self.context.configuration.enableMemoryLog) {
        [self.memoryLogDet stopMemoryLogDetector];
    }
    
    [NSObject setEnableLeaksFinder:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagMemory;
}

#pragma mark -- public Method

- (MBMemoryLogDetector *)memoryLogDetector {
    return self.memoryLogDet;
}

- (void)logMemoryLeak:(id<MBAPMMemoryLeakProtocol>)leakMessage {
    if (self.context.configuration.enableLeakMonitor || self.context.configuration.enableFOOMMonitor) {
        MBAPMMemoryMetric *metric = [MBAPMMemoryMetric new];
        metric.performanceType = MBAPMPerformanceTypeMemory;
        metric.exceptionType = MBAPMMemoryExceptionTypeLeak;
        metric.metricType = MBAPMMetricTypeCounter;
        metric.metricValue = 1;
        metric.metricName = @"performance.memory_leak";
        metric.errorFeature = leakMessage.title;
        metric.errorDetail = leakMessage.message;
        metric.attrs = @{@"error_detail":metric.errorDetail ?: @""};
        MBAPMDoctorEventModel *actionModel = [[MBAPMDoctorEventTracker sharedInstance] getActionEvent];
        metric.actionEvents = @[@{
            @"action_type": @(actionModel.eventType),
            @"action_feature": actionModel.eventFeature ?: @"",}];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reportMetrics:metric];
        });
        MBAPMLogInfo(@"memory monitor leaks: %@ %@", leakMessage.title, leakMessage.message);
    }
}
/// 内存泄漏的忽略类
- (void)addClassNamesToLeaksWhitelist:(NSArray *)classNames {
    [NSObject addClassNamesToLeaksWhitelist:classNames];
}

- (void)setEnableLeaksFinder:(BOOL)enable {
    [NSObject setEnableLeaksFinder:enable];
}

- (BOOL)isEnableLeaksFinder {
    return [NSObject isEnableLeaksFinder];
}

- (void)setEnableLeaksAlert:(BOOL)enable {
    [NSObject setEnableLeaksAlert:enable];
}

- (BOOL)isEnableLeaksAlert {
    return [NSObject isEnableLeaksAlert];
}

- (void)setEnableCheckRetainCycle:(BOOL)enable {
    [NSObject setEnableCheckRetainCycle:enable];
}

- (BOOL)isEnableCheckRetainCycle {
    return [NSObject isEnableCheckRetainCycle];
}


#pragma mark -- Private Method

- (void)startMemoryLogMonitor {
    if (self.context.configuration.memoryLogAvgMaxCount && self.context.configuration.memoryLogAvgMaxCount > 0) {
        self.memoryLogDet.avgTotalTimes = self.context.configuration.memoryLogAvgMaxCount;
    }
    __weak typeof(self) weakSelf = self;
    [self.memoryLogDet startMemoryLogDetectorWithCallBack:^(MBMemoryLogModel * _Nonnull model) {
        [weakSelf uploadMemeoryLogWithModel:model];
    }];
    
    [self.memoryLogDet startFirstDisappearMemoryLogDetectorWithCallBack:^(CGFloat increment, CGFloat peakIncrement, MBMemoryLogModel * _Nonnull loadMemory, MBMemoryLogModel * _Nonnull current) {
        [weakSelf uploadFirstMemeoryLogWithModel:current oldMemory:loadMemory increment:increment peakIncrement:peakIncrement];
    }];
    
    [self.memoryLogDet startMemonryAvgIncrementDetectorWithCallBack:^(CGFloat increment, CGFloat peakIncrement, CGFloat avgPeakIncrement, NSArray * _Nonnull memorys, MBMemoryLogModel * _Nonnull current) {
        [weakSelf uploadAvgMemeoryLogWithLast:current increment:increment peakIncrement:peakIncrement avgPeakIncrement:avgPeakIncrement historyJsonMessage:memorys];
    }];
}

- (void)uploadMemeoryLogWithModel:(MBMemoryLogModel * _Nonnull)model {
    if (model.runTime == 0) {
        return;
    }
    MBAPMMemoryMetric *metric = [MBAPMMemoryMetric new];
    metric.performanceType = MBAPMPerformanceTypeMemory;
    metric.exceptionType = MBAPMMemoryExceptionTypeUsage;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.saveBehaviorLog = [self localAnalysisNeedMemoryLogOnLine];
    metric.metricValue = @(model.appMemoryUsagePercent * 100).unsignedIntegerValue;
    metric.metricName = @"performance.memory_log";
    metric.metricSections = @{@"app_memory_usage": @(model.appMemoryUsage)};
    metric.runTime = model.runTime;
    metric.logType = 0;
    metric.apmVersion =  [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
    metric.attrs = @{@"device_total_memory": @(model.deviceTotalMemory),
                     @"available_memory": @(model.availableMemory),
                     @"available_memory_percent": @(model.availableMemoryPercent * 100)};
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (void)uploadFirstMemeoryLogWithModel:(MBMemoryLogModel * _Nonnull)model oldMemory:(MBMemoryLogModel * _Nonnull)loadMemory increment:(CGFloat)increment peakIncrement:(CGFloat)peakIncrement {
    MBAPMMemoryMetric *metric = [MBAPMMemoryMetric new];
    metric.performanceType = MBAPMPerformanceTypeMemory;
    metric.exceptionType = MBAPMMemoryExceptionTypeUsage;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.saveBehaviorLog = [self localAnalysisNeedMemoryLogOnLine];
    CGFloat metricValue = MAX(increment, 0);
    metric.metricValue = @(metricValue).unsignedIntegerValue;
    metric.metricName = @"performance.memory_log";
    CGFloat incrementPeak = MAX(metricValue, peakIncrement);
    metric.metricSections = @{@"app_memory_usage": @(model.appMemoryUsage),@"page_memory_increment_peak": @(incrementPeak)};
    metric.runTime = model.runTime;
    metric.logType = 1;
    metric.pageName = model.pageName;
    metric.apmVersion =  [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
    metric.attrs = @{@"device_total_memory": @(model.deviceTotalMemory),
                     @"available_memory": @(model.availableMemory),
                     @"available_memory_percent": @(model.availableMemoryPercent * 100),
                     @"history": @[loadMemory.jsonMessage, model.jsonMessage]
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (void)uploadAvgMemeoryLogWithLast:(MBMemoryLogModel *)model increment:(CGFloat)increment peakIncrement:(CGFloat)peakIncrement avgPeakIncrement:(CGFloat)avgPeakIncrement historyJsonMessage:(NSArray *)historyJsonMessage {
    MBAPMMemoryMetric *metric = [MBAPMMemoryMetric new];
    metric.performanceType = MBAPMPerformanceTypeMemory;
    metric.exceptionType = MBAPMMemoryExceptionTypeUsage;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.saveBehaviorLog = [self localAnalysisNeedMemoryLogOnLine];
    CGFloat metricValue = MAX(increment, 0);
    metric.metricValue = @(metricValue).unsignedIntegerValue;
    metric.metricName = @"performance.memory_log";
    CGFloat incrementPeak = MAX(metricValue, peakIncrement);
    CGFloat incrementPeakAvg = MAX(incrementPeak, avgPeakIncrement);
    metric.metricSections = @{@"app_memory_usage": @(model.appMemoryUsage),@"page_memory_increment_peak": @(incrementPeak),@"page_memory_increment_peak_avg": @(incrementPeakAvg)};
    metric.logType = 2;
    metric.pageName = model.pageName;
    metric.apmVersion =  [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
    metric.attrs = @{@"device_total_memory": @(model.deviceTotalMemory),
                     @"available_memory": @(model.availableMemory),
                     @"available_memory_percent": @(model.availableMemoryPercent * 100),
                     @"history": historyJsonMessage};
    MBAPMDoctorEventModel *actionModel = [[MBAPMDoctorEventTracker sharedInstance] getActionEvent];
    metric.actionEvents = @[@{
        @"action_type": @(actionModel.eventType),
        @"action_feature": actionModel.eventFeature ?: @"",}];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (void)startBigImageMonitor {
    [UIImage startMonitorImageSize];
    if (self.context.configuration.largeImageThreshold != 0) {
        [UIImage largeImageSizeThreshold:self.context.configuration.largeImageThreshold];
    }
    __weak typeof(self) weakSelf = self;
    [UIImage largeImageCallBack:^(NSString * _Nullable path, double imageLength) {
        [weakSelf uploadBigImageIssueWithPath:path imageLength:imageLength];
        MBAPMLogInfo(@"memory monitor big image: %@ %f", path, imageLength);
    }];
}

- (void)uploadBigImageIssueWithPath:(NSString * _Nullable)path imageLength: (double)imageLength {
    MBAPMMemoryMetric *metric = [MBAPMMemoryMetric new];
    metric.performanceType = MBAPMPerformanceTypeMemory;
    metric.exceptionType = MBAPMMemoryExceptionTypeBigImage;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = imageLength;
    metric.pageName = [MBAPMCurrentPageInfo noMainThreadCurrentPageName];
    metric.metricName = @"performance.memory_big_image";
    metric.errorFeature = path ?: @"unkonwn path";
    MBAPMDoctorEventModel *actionModel = [[MBAPMDoctorEventTracker sharedInstance] getActionEvent];
    metric.actionEvents = @[@{
        @"action_type": @(actionModel.eventType),
        @"action_feature": actionModel.eventFeature ?: @"",}];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (void)uploadFOOMData:(MatrixIssue *)issue {
    if (issue.issueData) {
        MBAPMDataUploader *uploader = [MBAPMDataUploader new];
        __weak typeof(self) weakSelf = self;
        [uploader uploadData:issue.issueData success:^(NSString * _Nullable uri) {
            __strong typeof(self) strongSelf = weakSelf;
            MBAPMLogInfo(@"FOOM stack upload success, uri = %@", uri);
            WCMemoryStatPlugin *plugin = [[MBMatrixWechatManager sharedInstance] getMemoryStatPlugin];
            [plugin deleteRecord:[plugin recordOfLastRun]];
            [strongSelf reportFOOMMetric:uri issue:issue];
        } failure:^(NSError * _Nullable errorObj) {
            MBAPMError(@"FOOM stack upload fails, errorCode = %ld", (long)errorObj.code);
        }];
    } else {
        [self reportFOOMMetric:nil issue: issue];
    }
}

- (void)reportFOOMMetric:(NSString *)stackUrl issue:(MatrixIssue *)issue {
    MBAPMCrashMetric *metric = [MBAPMCrashMetric new];
    metric.performanceType = MBAPMPerformanceTypeCrash;
    metric.metricType = MBAPMMetricTypeCounter;
    metric.metricName = @"app.crash";
    metric.metricValue = 1;
    metric.bundles = [MBAPMUUIDUtil getUnsystemImageUUIDs];
    metric.crashType = [self oomErrorFeature:issue.issueData];
    metric.crashTag = @"oom";
    metric.isMemoryLog = self.context.configuration.enableMemoryLog;
    metric.isOOMStack = self.context.configuration.foomConfigDumpCallStacks != 0;
    metric.isForeground = [[MBAPMAppStateUtil shared] lastLaunchApplicationState] != UIApplicationStateBackground;
    metric.extInfo = @{@"launch_id": [[MBAPMAppStateUtil shared] lastLaunchId] ?: @"", @"app_start_time": @([MBAPMAppStateUtil shared].lastLaunchStartTime), @"app_crash_time": @([MBAPMAppStateUtil shared].lastLaunchEndTime)};
    metric.stackUrl = stackUrl;
    metric.stackType = @"oom_file";
    metric.attrs = @{@"stack_type": @"oom_file", @"stack_url": stackUrl ?: @"", @"current_memory": @{@"device_total_memory": @([MBAPMMemoryUtil totalMemoryForDevice])}, @"bundles":metric.bundles?:@[], @"mapping_type":@"dsym", @"is_jail": @([MBAppDelegate appInfo].isJail)};
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (void)reportFOOMCounter {
    MBAPMLogInfo(@"oom,memory_warning upload");
    MBAPMCrashMetric *metric = [MBAPMCrashMetric new];
    metric.performanceType = MBAPMPerformanceTypeCrash;
    metric.metricType = MBAPMMetricTypeCounter;
    metric.metricName = @"app.crash";
    metric.metricValue = 1;
    metric.crashType = @"oom,memory_warning";
    metric.crashTag = @"oom";
    metric.isMemoryLog = NO;
    metric.isOOMStack = NO;
    metric.isForeground = [[MBAPMAppStateUtil shared] lastLaunchApplicationState] != UIApplicationStateBackground;
    metric.extInfo = @{@"launch_id": [[MBAPMAppStateUtil shared] lastLaunchId] ?: @"", @"app_start_time": @([MBAPMAppStateUtil shared].lastLaunchStartTime), @"app_crash_time": @([MBAPMAppStateUtil shared].lastLaunchEndTime)};
    metric.attrs = @{@"current_memory": @{@"device_total_memory": @([MBAPMMemoryUtil totalMemoryForDevice])}, @"is_jail": @([MBAppDelegate appInfo].isJail)};
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (NSString *)oomErrorFeature:(NSData *)data {
    NSString *issueString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] substringToIndex:2000];
    NSArray *issueArr = [issueString componentsSeparatedByString:@"\""];
    issueString = nil;
    __block NSString *tag = @"tag";
    __block NSString *name = @"name";
    __block NSString *offsetString = @"offset";
    __block int flag = 0;
    __block int done = 0;
    for (NSString *  _Nonnull obj in issueArr) {
//        NSLog(@"<-------obj-%@", [obj stringByNormalizingWhitespace]);
        if (flag > 0 && flag < 10) { flag += 10; continue; }
        if ([obj isEqualToString:@"tag"]) { flag = 1; continue; }
        if ([obj isEqualToString:@"name"]) { flag = 2; continue; }
        if ([obj isEqualToString:@"caller"]) { flag = 3; continue; }
        if (flag == 11) { tag = obj; flag = 0; done += 1; continue; }
        if (flag == 12) { name = obj; flag = 0; done += 10; continue; }
        if (flag == 13) { offsetString = obj; flag = 0; done += 100; continue; }
        if (done == 111) { break; }
    }
    issueArr = nil;
    NSString * offset = [offsetString componentsSeparatedByString:@"@"].lastObject ?: @"offset";
    return [NSString stringWithFormat:@"%@,%@,%@", tag, name, offset];
}

- (void)reportMemoryWarningMetric {
    MBAPMLogInfo(@"memory monitor low memory warning");
    MBAPMMemoryMetric *metric = [MBAPMMemoryMetric new];
    metric.performanceType = MBAPMPerformanceTypeMemory;
    metric.exceptionType = MBAPMMemoryExceptionTypeWarning;
    metric.metricName = @"performance.memory_warning";
    metric.metricType = MBAPMMetricTypeCounter;
    metric.pageName = [MBAPMCurrentPageInfo currentPageName];
    MBMemoryLogModel *memory = [MBMemoryLogDetector lastMemoryLog];
    metric.metricValue = @(memory.appMemoryUsage).unsignedIntegerValue;
    NSDictionary *cachedMemoryInfo = [[[MBAPMSystemDataGather sharedIntance]getCacheClient]getMemoryInfo];
    if(cachedMemoryInfo) {
        NSMutableDictionary *memoryInfo = [NSMutableDictionary dictionaryWithDictionary:cachedMemoryInfo];
        [memoryInfo setObject:@([MBAPMSystemDataGather sharedIntance].dataGatherfrequency) forKey:kMetricDataKeyGatherfrequency];
        metric.memoryInfo = memoryInfo;
    }
    metric.apmVersion =  [[[MBPluginInfos infos] objectForKey:@"MBAPMLib"] versionName];
    metric.attrs = @{@"device_total_memory": @(memory.deviceTotalMemory),
                     @"available_memory": @(memory.availableMemory),
                     @"available_memory_percent": @(memory.availableMemoryPercent * 100),
                     @"app_memory_usage": @(memory.appMemoryUsage),
                     @"app_memory_usage_percent": @(memory.appMemoryUsagePercent * 100)
    };
    MBAPMLogInfo(@"memory monitor low memory warning: %@ / %@", @(memory.appMemoryUsage), @(memory.deviceTotalMemory));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reportMetrics:metric];
    });
}

- (void)applicationDidReceiveMemoryWarning {
    // 收到memorywarning后更新appState
    [[MBAPMAppStateUtil shared] updateApplicationState];
    [self reportMemoryWarningMetric];
}

- (BOOL)localAnalysisNeedMemoryLogOnLine {
    static BOOL needCustomMemoryLog;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger launchTimesConfig = 3;
        NSInteger oomTimesConfig = 2;
        
        NSString *configS = self.context.configuration.memoryLogAutoTagConfig;
        NSArray *configA = [configS componentsSeparatedByString:@","];
        if (configA.count > 1) {
            launchTimesConfig = MAX([configA.firstObject integerValue], launchTimesConfig);
            oomTimesConfig = MAX([configA[1] integerValue], oomTimesConfig);
        }
        
        NSUInteger exitInfo = [MBAPMMemoryMonitor storageOOMInfo];
        NSUInteger mixCount = 0;
        for (int i = 0; i < (MIN(launchTimesConfig, 32)); i++) {
            BOOL mix = (exitInfo >> i) & 1;
            mixCount += mix;
        }
        
        needCustomMemoryLog = mixCount >= oomTimesConfig;
    });
    return needCustomMemoryLog;
}

#pragma mark - Property Method
- (MBMemoryLogDetector *)memoryLogDet {
    if (_memoryLogDet) {
        return _memoryLogDet;
    }
    _memoryLogDet = [[MBMemoryLogDetector alloc] init];
    return _memoryLogDet;
}

- (MBMemoryOOMCounter *)memoryOOMCounter {
    if (_memoryOOMCounter) {
        return _memoryOOMCounter;
    }
    _memoryOOMCounter = [[MBMemoryOOMCounter alloc] init];
    return _memoryOOMCounter;
}

+ (void)updateStorageOOMInfo:(BOOL)lastIsExitWithMemoryWarning {
    NSUInteger value = [[MMKV defaultMMKV] getInt64ForKey:kMMKV_StorageOOMInfo];
    if (value > INT32_MAX) {
        value = (value >> 16);
    }
    value = (value << 1) + lastIsExitWithMemoryWarning;
    [[MMKV defaultMMKV] setInt64:value forKey:kMMKV_StorageOOMInfo];
}

+ (NSUInteger)storageOOMInfo {
    static NSUInteger oomExitInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger value = [[MMKV defaultMMKV] getInt64ForKey:kMMKV_StorageOOMInfo];
        oomExitInfo = value;
    });
    return oomExitInfo;
}

@end
