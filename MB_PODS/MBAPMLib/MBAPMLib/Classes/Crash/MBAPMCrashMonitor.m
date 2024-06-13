//
//  MBAPMCrashMonitor.m
//  MBAPMLib
//
//  Created by xp on 2020/8/17.
//

#import "MBAPMCrashMonitor.h"
#import "MBAPMCrashMetric.h"
#import "MBAPMSystemDataGather.h"
#import "MBAPMStorageUtil.h"
#import "MBAPMLogDef.h"
#import "MBAPMUUIDUtil.h"
#import "MBAPMContext.h"
#import "MBAPMMonitor.h"
#import "MBMatrixWechatManager.h"
#import "MBAPMAppLaunchMonitor.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMCrashHandlerHook.h"
#import "MBDeviceInfo.h"
#import "MBAPMZombieSniffer.h"
#import "MBAPMConfiguration+Zombie.h"
#import "MBAPMCurrentPageInfo.h"
#import "MBAPMAppStateUtil.h"

@import MBProjectConfig;
@import MBBuildPreLib;
@import MBDoctorService;
@import MBMapLibModuleService;

static NSString * const kMetricDataKeyGatherfrequency = @"timeInterval";


@interface MBAPMCrashMonitor() {
}

@end

@implementation MBAPMCrashMonitor

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagCrash;
}

- (void)start {
    [super start];
    if (![MBDeviceInfo canEnableMonitor]) {
        MBAPMLogInfo(@"crash monitor can't be started on simulator or debugging status");
        return;
    }
    if (self.context.configuration.enableHookCrashHandler) {
        [MBAPMCrashHandlerHook hookBCECrashChecker];
    }
    __weak typeof(self) weakSelf = self;
    [MBMatrixWechatManager sharedInstance].additionalInfoBlock = ^NSDictionary * _Nullable{
        __strong typeof(self) strongSelf = weakSelf;
        return [strongSelf additionalDataWriteToCrashFile];
    };
    [[MBMatrixWechatManager sharedInstance] setCrashReportBlock:^(MatrixReportModel * _Nonnull reportModel) {
        if (!reportModel) {
            MBAPMError(@"crash occur, but report data is empty");
            return;
        }
        MBAPMError(@"crash occur stack frame = %@", [reportModel.crash crashFeatureStackFrame]);
        NSDictionary *apmDic = nil;
        NSDictionary *customUserInfo = reportModel.user;
        if (!customUserInfo) {
            MBAPMError(@"crash occur, but user info in report data is empty");
            return;
        }
        NSDictionary *mbDataDic = [customUserInfo objectForKey:@"mb_data"];
        if (mbDataDic && [mbDataDic isKindOfClass:NSDictionary.class]) {
            apmDic = [mbDataDic objectForKey:@"apm"];
        }
        if (!apmDic) {
            MBAPMError(@"crash occur, but apm data in report data is empty");
        }
        MBAPMCrashMetric *crashMetric = [MBAPMCrashMetric yy_modelWithDictionary:apmDic];
        NSString *crashType = [NSString stringWithFormat:@"%@,%@", reportModel.crash.error.errorType, reportModel.crash.crashFeatureStackFrame];
        reportModel.user = nil;
        crashMetric.bundles = [MBAPMUUIDUtil getUnsystemImageUUIDs];
        NSString *crashStack = [reportModel yy_modelToJSONString]?:@"";
        crashMetric.crashType = crashType;
        crashMetric.stack = crashStack;
        NSString *relatedStack;
        if (reportModel.process && reportModel.process.last_dealloced_nsexception && reportModel.process.last_dealloced_nsexception.backtrace) {
            NSArray<MatrixReportCrashThreadTraceModel *> *backtraceModels = reportModel.process.last_dealloced_nsexception.backtrace.contents;
            if (backtraceModels.count > 0) {
                relatedStack = [backtraceModels yy_modelToJSONString];
            }
        }
        if (relatedStack) {
            crashMetric.related_stacks = @[relatedStack];
        }
        crashMetric.attrs = @{@"stack_type": @"crash_json", @"cpu":crashMetric.cpuInfo?:@"", @"memory":crashMetric.memoryInfo?:@"", @"availableStorage":@(crashMetric.availableStorage?:0), @"bundles":crashMetric.bundles?:@[], @"mapping_type":@"dsym"};
        [MBAPMAppStateUtil shared].lastLaunchCrashReported = YES;
        [self reportMetrics:crashMetric];
    }];
    
    [[MBMatrixWechatManager sharedInstance] setCrashLagReportBlock:^(MatrixReportModel * _Nonnull reportModel) {
        if (!reportModel) {
            MBAPMError(@"crash lag occur, but report data is empty");
            return;
        }
        MBAPMError(@"crash lag occur stack frame = %@", [reportModel.crash crashFeatureStackFrame]);
        
        BOOL isForeground = [[MBAPMAppStateUtil shared] lastLaunchApplicationState] != UIApplicationStateBackground;
        if (self.context.configuration.disableBackgroundLagCrash == YES && isForeground == NO) {
            return;
        }
        
        MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
        performance.performanceType = MBDoctorPerformanceTypeLag;
        performance.metricName = @"app.error";
        performance.metricType = MBDoctorMetricTypeCounter;
        performance.metricValue = 0;
        NSString *crashType = [NSString stringWithFormat:@"%@,%@", reportModel.crash.error.reason, reportModel.crash.lagFeatureStackFrame];
        performance.tags = @{@"page_id": @"", @"app_foreground": @(isForeground), @"error_feature": crashType, @"error_tag": @"lag", @"mapSDK": [self fetchMapSdk] ?: @""};
        
        NSString *crashStack = [reportModel yy_modelToJSONString]?:@"";
        performance.attrs = @{@"stack_type": @"crash_json", @"cpu":@"", @"memory":@"", @"availableStorage":@(0), @"bundles":[MBAPMUUIDUtil getUnsystemImageUUIDs]?:@[], @"mapping_type":@"dsym", @"stack": crashStack};
        
        performance.ext = @{@"launch_id": [[MBAPMAppStateUtil shared] lastLaunchId] ?: @"", @"app_start_time": @([MBAPMAppStateUtil shared].lastLaunchStartTime), @"app_crash_time": @([MBAPMAppStateUtil shared].lastLaunchEndTime)};

//        [MBAPMAppStateUtil shared].lastLaunchCrashReported = YES;
        
        MBModuleInfo *moduleInfo = [MBModuleInfo new];
        moduleInfo.moduleName = @"app";
        moduleInfo.subModuleName = @"apm";
        MBDoctorContext *context = [[MBDoctorContext alloc]initWithModuleInfo:moduleInfo];
        id<MBDoctorServiceProtocol> service = BIND_SERVICE(context, MBDoctorServiceProtocol);
        service.fromContext = context;
        [service doctor:performance];
    }];
    
    [[MBMatrixWechatManager sharedInstance]setCrashHandleStartBlock:^(NSString * _Nonnull crashType) {
            MBDoctorEventError *errorEvent = [[MBDoctorEventError alloc]initWithPlatform:MBDoctorPlatformHubble];
            errorEvent.tag = @"crash_matrix_start";
            errorEvent.feature = [NSString stringWithFormat:@"matrix exception start: %@", crashType];
            MBBaseContext *context = [MBBaseContext new];
            MBModuleInfo *moduleInfo = [MBModuleInfo new];
            moduleInfo.moduleName = @"app";
            moduleInfo.subModuleName = @"apm";
            context.moduleInfo = moduleInfo;
            id<MBDoctorServiceProtocol> doctorService = BIND_SERVICE(context, MBDoctorServiceProtocol);
            [doctorService doctor:errorEvent];
        }];
    
    if (self.context.configuration.enableZombieMonitor) {
        MBAPMZombieConfig *config = self.context.configuration.zombieConfig;
        [MBAPMZombieSniffer startSniffer:config];
    }
}

- (void)stop {
    [super stop];
    if (self.context.configuration.enableZombieMonitor) {
        [MBAPMZombieSniffer stopSniffer];
    }
}

#pragma mark - Private Method

- (NSDictionary * __nullable)obtainAttachment:(MBAPMMetric * __nullable)metric {
    if (self.context.delegate) {
        return [self.context.delegate attachmentForMetric:metric];
    }
    return nil;
}

- (__kindof NSDictionary *)additionalDataWriteToCrashFile {
    MBAPMCrashMetric *metric = [MBAPMCrashMetric new];
    metric.performanceType = MBAPMPerformanceTypeCrash;
    metric.metricType = MBAPMMetricTypeCounter;
    metric.metricName = @"app.crash";
    metric.metricValue = 1;
    metric.pageName = [MBAPMCurrentPageInfo currentPageName];
    metric.isPageLoading = [MBAPMCurrentPageInfo currentPageIsLoading]?1:0;
    metric.pagePath = [MBAPMCurrentPageInfo currentPagePath];
    metric.pageClassName = [MBAPMCurrentPageInfo currentPageClassName];
    metric.isForeground = [[MBAPMAppStateUtil shared] lastLaunchApplicationState] != UIApplicationStateBackground;
    metric.crashScene = self.context.hasLaunchSuccess?@"default":@"launch";
    metric.availableStorage = (NSInteger)[MBAPMStorageUtil getAvailableStorage];
    metric.bizTags = @{@"mapSDK": [self fetchMapSdk] ?: @""};
    NSDictionary *cachedCpuInfo = [[[MBAPMSystemDataGather sharedIntance]getCacheClient]getCPUInfo];
    if(cachedCpuInfo) {
        NSMutableDictionary *cpuInfo = [NSMutableDictionary dictionaryWithDictionary:cachedCpuInfo];
        [cpuInfo setObject:@([MBAPMSystemDataGather sharedIntance].dataGatherfrequency) forKey:kMetricDataKeyGatherfrequency];
        metric.cpuInfo = cpuInfo;
    }
    NSDictionary *cachedMemoryInfo = [[[MBAPMSystemDataGather sharedIntance]getCacheClient]getMemoryInfo];
    if(cachedMemoryInfo) {
        NSMutableDictionary *memoryInfo = [NSMutableDictionary dictionaryWithDictionary:cachedMemoryInfo];
        [memoryInfo setObject:@([MBAPMSystemDataGather sharedIntance].dataGatherfrequency) forKey:kMetricDataKeyGatherfrequency];
        metric.memoryInfo = memoryInfo;
    }
    NSMutableDictionary *metricExtInfo = [NSMutableDictionary new];
    NSDictionary *extInfo = [self getExtData];
    if (extInfo) {
        [metricExtInfo addEntriesFromDictionary:extInfo];
    }
    NSDictionary *attachmentInfo = [self obtainAttachment:metric];
    if (attachmentInfo) {
        [metricExtInfo addEntriesFromDictionary:attachmentInfo];
    }
    metric.extInfo = [metricExtInfo copy];
    return [metric yy_modelToJSONObject];
}

- (NSDictionary *)getExtData {
    NSMutableDictionary *ext = @{}.mutableCopy;
    // App
    BOOL isDriver = ([MBAppDelegate projectConfig].appTypeForBiz == MBAppTypeForBizYMMDriver ||
                        [MBAppDelegate projectConfig].appTypeForBiz == MBAppTypeForBizHCBDriver);
    NSString *appID = isDriver ? @"2" : @"1";
    NSString *bundleID = [MBAppDelegate projectConfig].realAppBundleId;
    // Crash
    NSString *crashID = [[NSUUID UUID] UUIDString]?:@"";
    NSDate *now = [NSDate date];
    NSString *crashOccureTime = [self.dateFormatter stringFromDate:now];
    long long crashOccureTimestamp = [now timeIntervalSince1970] * 1000;
    NSDate *appLaunchDate = [NSDate dateWithTimeIntervalSince1970:[MBAPMAppStateUtil shared].launchStartTime / 1000];
    if (appLaunchDate) {
        NSString *appLauchTime = [self.dateFormatter stringFromDate:appLaunchDate];
        [ext setObject:appLauchTime?:@"" forKey:@"app_start_time"];
    }
    [ext setObject:@([MBAPMAppStateUtil shared].appRunTime) forKey:@"use_time"];
    [ext setObject:appID forKey:@"app_id"];
    [ext setObject:crashOccureTime?:@"" forKey:@"app_crash_time"];
    [ext setObject:crashID forKey:@"crash_id"];
    [ext setObject:[MBAppLaunchInfo launchID]?:@"" forKey:@"event_occur_launch_id"];
    [ext setObject:@(crashOccureTimestamp) forKey:@"event_occur_time"];
    [ext setObject:bundleID?:@"" forKey:@"package_name"];
    [ext addEntriesFromDictionary:[self deviceHardwareInfo]];
    return ext.copy;
}

#pragma mark - Private - DateTime

- (NSDateFormatter *)dateFormatter {
    static dispatch_once_t once;
    static NSDateFormatter *formatter;
    dispatch_once(&once, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return formatter;
}

#pragma mark - Private - Device

- (NSDictionary *)deviceHardwareInfo {
    NSMutableDictionary *container = [NSMutableDictionary dictionaryWithCapacity:2];
    if ([MBFMacro ymm_buildDebug]) {
        [container setValue:@"DEBUG" forKey:@"CrashResource"];
    } else if ([MBFMacro ymm_buildAdhoc]) {
        [container setValue:@"ADHOC" forKey:@"CrashResource"];
    } else {
        [container setValue:@"RELEASE" forKey:@"CrashResource"];
    }
    return container;
}

#pragma mark - Private - sdk

- (NSString *)fetchMapSdk {
    id <MBMapLibServiceProtocol> service = BIND_SERVICE(nil, MBMapLibServiceProtocol);
    return [service fetchMapSdk];
}

@end
