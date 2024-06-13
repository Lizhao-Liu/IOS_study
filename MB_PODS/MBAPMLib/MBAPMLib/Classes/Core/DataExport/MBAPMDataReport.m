//
//  MBAPMDataReport.m
//  MBAPMLib
//
//  Created by xp on 2020/7/15.
//

#import "MBAPMDataReport.h"
#import "MBAPMAppLaunchMetric.h"
#import "MBAPMPageRenderMetric.h"
#import "MBAPMLagMetric.h"
#import "MBAPMCrashMetric.h"
#import "MBAPMMemoryMetric.h"
#import "MBAPMService.h"
#import "MBAPMServiceContext.h"
#import "MBAPMLogDef.h"
#import "MBAPMCPUMetric.h"
#import "MBAPMErrorMetric.h"
#import "MBAPMFPSMetric.h"
#import "MBAPMWhiteScreenMetric.h"
#import "MBAPMWakeupsMetric.h"
#import "MBAPMTrafficMetric.h"

@import MBFoundation;
@import YMMModuleLib;
@import MBDoctorService;

@import YYModel;

@interface MBAPMDataReport()

@property (nonatomic, strong, nonnull) MBAPMContext *context;

@end


@implementation MBAPMDataReport

- (instancetype)initWithContext:(MBAPMContext *)context {
    if (self = [super init]) {
        self.context = context;
    }
    return self;
}

- (void)exportMetricData:(MBAPMMetric *)metric {
    if(!metric) {
        return;
    }
    MBDoctorEvent *performance = [self transferMetric:metric];
    //    MBAPMDebug(@"performance metric data: %@", [performance yy_modelToJSONString]);
    if(performance) {
        MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
        id<MBDoctorServiceProtocol> service = BIND_SERVICE(serviceContext, MBDoctorServiceProtocol);
        [service doctor:performance];
    }
}

- (MBDoctorEvent *)transferMetric:(MBAPMMetric *)metric {
    MBDoctorEvent *event = nil;
    switch (metric.performanceType) {
        case MBAPMPerformanceTypePageRender:
            event = [self transferPageRenderMetric:(MBAPMPageRenderMetric *)metric];
            break;
        case MBAPMPerformanceTypeAppLaunch:
            event = [self transferAppLaunchMetric:(MBAPMAppLaunchMetric *)metric];
            break;
        case MBAPMPerformanceTypeLag: {
            MBAPMLagMetric *lagMetric = (MBAPMLagMetric *)metric;
            event = [self transferLagMetric:lagMetric];
        }
            break;
        case MBAPMPerformanceTypeCrash:
            event = [self transferCrashMetric:(MBAPMCrashMetric *)metric];
            break;
        case MBAPMPerformanceTypePageCPUUsage:
            event = [self transferPageCPUUsageMetric:metric];
            break;
        case MBAPMPerformanceTypeMemory: {
            MBAPMMemoryMetric *memoryMetric = (MBAPMMemoryMetric *)metric;
            event = [self transferMemoryException:memoryMetric];
        }
            break;
        case MBAPMPerformanceTypeCPU: {
            MBAPMCPUMetric *cpuMetric = (MBAPMCPUMetric *)metric;
            event = [self transferCpuMetric:cpuMetric];
        }
            break;
        case MBAPMPerformanceTypeError: {
            MBAPMErrorMetric *errorMetric = (MBAPMErrorMetric *)metric;
            [self uploadAPMErrorException:errorMetric];
        }
            break;
        case MBAPMPerformanceTypeFPS: {
            MBAPMFPSMetric *errorMetric = (MBAPMFPSMetric *)metric;
            [self uploadFPSMetric:errorMetric];
        }
            break;
        case MBAPMPerformanceTypeWhiteScreen: {
            MBAPMWhiteScreenMetric *errorMetric = (MBAPMWhiteScreenMetric *)metric;
            [self uploadWhiteScreenMetric:errorMetric];
        }
            break;
        case MBAPMPerformanceTypeWakeups: {
            MBAPMWakeupsMetric *wakeupsMetric = (MBAPMWakeupsMetric *)metric;
            event = [self transferWakeupsMetric:wakeupsMetric];
        }
            break;
        case MBAPMPerformanceTypeTrffic: {
            MBAPMTrafficMetric *trafficMetric = (MBAPMTrafficMetric *)metric;
            event = [self transferTrafficMetric:trafficMetric];
        }
            break;
        default:
            break;
    }
    return event;
}

- (void)uploadWhiteScreenMetric:(MBAPMWhiteScreenMetric *)metric {
    if([NSString mb_isNilOrEmpty:metric.pageName] || [NSString mb_isNilOrEmpty:metric.metricName]) {
        return;
    }
    MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
    performance.metricName = metric.metricName;
    performance.metricType = [self transferMetricType:metric.metricType];
    performance.metricValue = metric.metricValue;
    performance.journalModel = metric.metricName;
    performance.journalScenario = metric.pageName;
    
    if (metric.reportType == MBAPMWhiteScreenMetricReportTypeWhiteScreenDetect) {
        performance.tags = @{@"page_id":metric.pageName ?: @"", @"page_path":metric.pagePath ?: @"", @"page_className":metric.pageClassName ?: @"", @"apm_version": metric.apmVersion ?: @"", @"is_captured": @(@(metric.isCaptured).intValue), @"is_finished": @(@(metric.isFinished).intValue), @"interrupt_type": metric.interruptType ?: @"", @"is_whitescreen": @(@(metric.isWhiteScreen).intValue), @"device_level":metric.deviceLeval, @"has_bitmap":@(@(metric.hasBitMap).intValue), @"bitmap_detect_result":@(metric.bitmapDtectResult),};
        performance.ext = @{@"capture_cost_time": @(metric.captureCostTime ?: 0), @"analysis_cost_time": @(metric.analysisCostTime ?: 0)};
        performance.attrs = metric.attrs ?: @{};
        
    } else if (metric.reportType == MBAPMWhiteScreenMetricReportTypeWhiteScreen) {
        performance.tags = @{@"page_id":metric.pageName ?: @"", @"page_path":metric.pagePath ?: @"", @"page_className":metric.pageClassName ?: @"", @"apm_version": metric.apmVersion ?: @"", @"error_feature": metric.errorFeature ?: @"", @"exception_type": metric.exceptionType ?: @"", @"last_step": metric.lastStep ?: @"", @"source": metric.source ?: @"", @"device_level":metric.deviceLeval, @"has_bitmap":@(@(metric.hasBitMap).intValue),};
        performance.attrs = metric.attrs ?: @{};
        
    } else if (metric.reportType == MBAPMWhiteScreenMetricReportTypeFrequentWhiteScreen) {
        performance.tags = @{@"page_id":metric.pageName ?: @"", @"page_path":metric.pagePath ?: @"", @"page_className":metric.pageClassName ?: @"", @"apm_version": metric.apmVersion ?: @"", @"error_feature": metric.errorFeature ?: @"", @"detect_type": @"page", @"exception_type": metric.exceptionType ?: @"", @"source": metric.source ?: @"", @"device_level":metric.deviceLeval};
        performance.attrs = metric.attrs;
        
    } else if (metric.reportType == MBAPMWhiteScreenMetricReportTypeTechStackFrequentWhiteScreen) {
        performance.tags = @{@"page_id":metric.pageName ?: @"", @"page_path":metric.pagePath ?: @"", @"page_className":metric.pageClassName ?: @"", @"apm_version": metric.apmVersion ?: @"", @"error_feature": metric.errorFeature ?: @"", @"detect_type": @"bundle_type", @"exception_type": metric.exceptionType ?: @"", @"source": metric.source ?: @"", @"device_level":metric.deviceLeval};
        
        performance.attrs = metric.attrs;
    } else {
        return;
    }
    
    MBBaseContext *context = [MBBaseContext new];
    context.moduleInfo = metric.moduleInfo;
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(context, MBDoctorServiceProtocol);
    [service doctor:performance];
}

- (void)uploadFPSMetric:(MBAPMFPSMetric *)metric {
//    NSAssert(!([NSString mb_isNilOrEmpty:metric.pageName] || [NSString mb_isNilOrEmpty:metric.metricName]),@"transferFPSMetric:pageName and metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.pageName] || [NSString mb_isNilOrEmpty:metric.metricName]) {
        return ;
    }
    MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
    performance.metricName = metric.metricName;
    performance.metricType = [self transferMetricType:metric.metricType];
    performance.metricValue = metric.metricValue;
    performance.journalModel = metric.metricName;
    performance.journalScenario = metric.pageName;
    performance.tags = @{@"page_id":metric.pageName ?: @"", @"page_path":metric.pagePath ?: @"", @"page_className":metric.pageClassName ?: @"", @"apm_version": metric.apmVersion ?: @"", @"device_level": metric.deviceLevel ?: @"", @"high_refresh_rate": @(@(metric.isHighFps).intValue)};
    performance.attrs = @{@"fps_detail": metric.fpsDetail ?: @"",  @"fps_duration": @(metric.duration ?: 0)};
    if (metric.cpuDetail.length > 0) {
        performance.attrs = @{@"fps_detail": metric.fpsDetail ?: @"", @"cpu_detail": metric.cpuDetail, @"fps_duration": @(metric.duration ?: 0)};
    }
    
    MBBaseContext *context = [MBBaseContext new];
    context.moduleInfo = metric.moduleInfo;
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(context, MBDoctorServiceProtocol);
    [service doctor:performance];
}

- (MBDoctorEventPerformance *)transferPageRenderMetric:(MBAPMPageRenderMetric *)metric {
    NSAssert(!([NSString mb_isNilOrEmpty:metric.pageName] || [NSString mb_isNilOrEmpty:metric.metricName]),@"pageName and metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.pageName] || [NSString mb_isNilOrEmpty:metric.metricName]) {
        return nil;
    }
    if(metric.metricValue > 6000) {
        [self uploadAPMException:metric withExceptionMsg:@"APM page render cost time is anomalous"];
    }
    MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
    performance.performanceType = MBDoctorPerformanceTypePageRender;
    performance.metricName = metric.metricName;
    performance.metricType = [self transferMetricType:metric.metricType];
    performance.metricValue = metric.metricValue;
    performance.journalModel = metric.metricName;
    performance.journalScenario = metric.pageName;
    performance.metricSections = metric.timeSections;
    performance.tags = @{@"pageType":[self transferPageType:metric.pageType], @"detectType":@(metric.detectType), @"page_id":metric.pageName, @"success":@(@(metric.renderResult).integerValue), @"detectStatus":@(metric.detectStatus)};
    NSMutableDictionary *ext = [NSMutableDictionary new];
    if (metric.extraData) {
        [ext addEntriesFromDictionary:metric.extraData];
    }
    [ext setObject:@(metric.detectDuration) forKey:@"detectDuration"];
    [ext setObject:@(metric.detectTimes) forKey:@"detectTimes"];
    performance.ext = ext;
    return performance;
}

- (void)uploadAPMException:(id)metric withExceptionMsg:(NSString *)msg{
    MBDoctorEventError *error = [[MBDoctorEventError alloc]initWithPlatform:MBDoctorPlatformHubble];
    error.feature = msg;
    error.errorDetail = [metric yy_modelToJSONString];
    error.renderType = MBDoctorEventErrorRenderTypeNative;
    error.tag = @"apm";
    MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(serviceContext, MBDoctorServiceProtocol);
    [service doctor:error];
}
- (void)uploadAPMErrorException:(MBAPMErrorMetric *)metric {
    MBDoctorEventError *error = [[MBDoctorEventError alloc]initWithPlatform:MBDoctorPlatformHubble];
    error.feature = metric.feature;
    error.errorDetail = metric.errorDetail;
    error.renderType = MBDoctorEventErrorRenderTypeNative;
    error.tag = metric.tag;
    error.stack = metric.stack;
    error.attrs = metric.attrs;
    MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(serviceContext, MBDoctorServiceProtocol);
    [service doctor:error];
}

- (MBDoctorEventPerformance *)transferAppLaunchMetric:(MBAPMAppLaunchMetric *)metric {
    NSAssert(![NSString mb_isNilOrEmpty:metric.metricName],@"metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.metricName]) {
        return nil;
    }
    if (metric.isLaunchTimeOut) {
        [self uploadAPMException:metric withExceptionMsg:[NSString stringWithFormat:@"APM app launch cost time is anomalous, launchType = %lu", (unsigned long)metric.launchType]];
        return nil;
    }
    if(metric.metricValue > 15000) {
        [self uploadAPMException:metric withExceptionMsg:[NSString stringWithFormat:@"APM app launch cost time is anomalous, launchType = %lu", (unsigned long)metric.launchType]];
        metric.metricValue = 15000;
        NSMutableDictionary<NSString *, NSNumber *> *corretTimeSection = metric.timeSections.mutableCopy;
        for (NSString *key in metric.timeSections) {
            NSNumber *timeValue = [metric.timeSections objectForKey:key];
            if (timeValue.longLongValue > 10000) {
                [corretTimeSection setObject:@(10000) forKey:key];
            }
        }
        metric.timeSections = corretTimeSection.copy;
    }
    MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
    performance.performanceType = MBDoctorPerformanceTypeAppLaunch;
    performance.metricName = metric.metricName;
    performance.metricType = [self transferMetricType:metric.metricType];
    performance.metricValue = metric.metricValue;
    performance.metricSections = metric.timeSections;
    if (metric.launchType == MBAPMAppLaunchTypeCold) {
        performance.journalModel = metric.metricName;
        performance.journalScenario = @"applaunch";
    }
    NSMutableDictionary *allTags = [NSMutableDictionary new];
    [allTags addEntriesFromDictionary:@{@"launchType":[self transferLaunchType:metric.launchType], @"time_interval":@(metric.time_interval), @"app_foreground":@(metric.appForeground), @"device_level":metric.deviceLeval, @"lastShutOffType":@(metric.lastShutOffType), @"launchMode":@(metric.launchMode), @"lastLaunchMode":@(metric.lastLaunchMode)}];
    if (metric.tags) {
        [allTags addEntriesFromDictionary:metric.tags];
    }
    performance.tags = allTags.copy;
    performance.ext = metric.extraData;
    return performance;
}

- (MBDoctorEventPerformance *)transferLagMetric:(MBAPMLagMetric *)metric {
    NSAssert(![NSString mb_isNilOrEmpty:metric.metricName],@"metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.metricName]) {
        return nil;
    }
     MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformHubble priority:MBDoctorPriorityNormal];
    performance.metricName = metric.metricName;
    performance.performanceType = MBDoctorPerformanceTypeLag;
    performance.metricType = [self transferMetricType:metric.metricType];
    NSString *reportChannel = [self transferReportChannel:metric.reportChannel];
    performance.metricValue = metric.metricValue;
    performance.tags = @{@"reportChannel":reportChannel,@"lagType":[self transferLagType:metric.lagType],@"page_id":metric.pageId?:@"", @"lagFeature":metric.keyFunction?:@"", @"dumpType": @(@(metric.dumpType).integerValue)};
    performance.ext = metric.exts;
    performance.attrs = metric.attrs;
    
    return performance;
}

- (MBDoctorEventError *)transferLagException:(MBAPMLagMetric *)metric {
    NSAssert(![NSString mb_isNilOrEmpty:metric.metricName],@"metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.metricName]) {
        return nil;
    }
    NSString *lagType = [self transferLagType:metric.lagType];
    NSString *reportChannel = [self transferReportChannel:metric.reportChannel];
    MBDoctorEventError *errorEvent = [[MBDoctorEventError alloc]initWithPlatform:MBDoctorPlatformHubble priority:MBDoctorPriorityNormal];
    errorEvent.renderType = MBDoctorEventErrorRenderTypeNative;
    errorEvent.tag = @"lag";
    errorEvent.stack = metric.stack;
    errorEvent.feature = [NSString stringWithFormat: @"%@", metric.keyFunction];
    errorEvent.tags = @{@"reportChannel":reportChannel,@"lagType":lagType,@"page_id":metric.pageId?:@""};
    errorEvent.ext = metric.exts;
    errorEvent.attrs = metric.attrs;
    
    return errorEvent;
}

- (MBDoctorEventPerformance *)transferMemoryException:(MBAPMMemoryMetric *)metric {
    NSAssert(![NSString mb_isNilOrEmpty:metric.metricName],@"metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.metricName]) {
        return nil;
    }
    MBDoctorEventPerformance *performance = [[MBDoctorEventPerformance alloc]initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityNormal];
    performance.metricName = metric.metricName;
    performance.metricType = [self transferMetricType:metric.metricType];
    performance.metricValue = metric.metricValue;
    performance.metricSections = metric.metricSections;
    
    if (metric.exceptionType == MBAPMMemoryExceptionTypeUsage) {
        if (metric.logType == 2 || metric.logType == 1) {
            performance.tags = @{@"apm_version":metric.apmVersion ?: @"", @"page_id":metric.pageName ?: @"", @"app_foreground":@(metric.appForeground), @"device_level":metric.deviceLeval, @"memory_log_type":@(metric.logType)};
        } else {
            performance.tags = @{@"run_time":@(metric.runTime), @"apm_version":metric.apmVersion ?: @"", @"page_id":metric.pageName ?: @"", @"app_foreground":@(metric.appForeground), @"device_level":metric.deviceLeval, @"memory_log_type":@(metric.logType)};
        }
        
    } else if (metric.exceptionType == MBAPMMemoryExceptionTypeBigImage) {
        performance.tags = @{@"apm_version":metric.apmVersion ?: @"", @"page_id":metric.pageName ?: @"", @"error_feature":metric.errorFeature ?: @""};
    } else if (metric.exceptionType == MBAPMMemoryExceptionTypeLeak) {
        performance.tags = @{@"error_feature":metric.errorFeature ?: @"", @"apm_version":metric.apmVersion ?: @"", @"page_id":metric.pageName ?: @"", @"app_foreground":@(metric.appForeground), @"device_level":metric.deviceLeval,};
    } else {
        // memory warning
        performance.tags = @{@"error_feature":metric.errorFeature ?: @"", @"apm_version":metric.apmVersion ?: @"", @"page_id":metric.pageName ?: @"", @"app_foreground":@(metric.appForeground), @"device_level":metric.deviceLeval,};
    }
    if (metric.saveBehaviorLog) {
        performance.cTags = @{MBDoctorEventCTagSaveBehaviorLog: @(1)};
    }
    if (metric.actionEvents.count > 0 && [metric.actionEvents.firstObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:performance.tags];
        [mdic addEntriesFromDictionary:metric.actionEvents.firstObject];
        performance.tags = mdic;
    }
    
    performance.attrs = metric.attrs;
    return performance;
}

- (MBDoctorEventCustom *)transferCpuMetric:(MBAPMCPUMetric *)metric {
    MBDoctorEventPerformance *event = [[MBDoctorEventPerformance alloc] initWithPlatform:MBDoctorPlatformAll priority:(MBDoctorPriorityNormal)];
    event.metricType = MBDoctorMetricTypeGauge;
    event.metricValue = metric.metricValue;
    event.metricName = metric.metricName;
    event.tags = metric.tags;
    event.metricSections = metric.sections;
    event.attrs = metric.atts;
    return event;
}

- (MBDoctorEventCrash *)transferCrashMetric:(MBAPMCrashMetric *)metric {
    MBDoctorEventCrash *event = [[MBDoctorEventCrash alloc] initWithPlatform:MBDoctorPlatformAll priority:MBDoctorPriorityHigh];
    NSMutableDictionary *tags = [NSMutableDictionary new];
    if (metric.bizTags) {
        [tags addEntriesFromDictionary:metric.bizTags];
    }
    [tags addEntriesFromDictionary: @{@"crash_scene":metric.crashScene?:@"", @"crash_tag":metric.crashTag?:@""}];
    if (![NSString mb_isNilOrEmpty:metric.pageName]) {
        [tags setObject:metric.pageName forKey:@"page_id"];
    }
    if (![NSString mb_isNilOrEmpty:metric.pagePath]) {
        [tags setObject:metric.pagePath forKey:@"page_path"];
    }
    if (![NSString mb_isNilOrEmpty:metric.pageClassName]) {
        [tags setObject:metric.pageClassName forKey:@"page_className"];
    }
    if (metric.isPageLoading != -1) {
        [tags setObject:@(metric.isPageLoading) forKey:@"pageview_loading"];
    }
    [tags setObject:@(metric.isForeground?:1) forKey:@"app_foreground"];
    if ([[metric crashTag] isEqualToString:@"oom"]) {
        [tags addEntriesFromDictionary: @{@"is_memory_log":@(metric.isMemoryLog?:0), @"is_oom_stacks":@(metric.isOOMStack?:0), @"crash_tag":metric.crashTag?:@""}];
    }
    event.tags = tags.copy;
    event.stack = metric.stack;
    event.crashType = metric.crashType;
    event.ext = metric.extInfo;
    event.attrs = metric.attrs;
    return event;
}

- (MBDoctorEventCustom *)transferPageCPUUsageMetric:(MBAPMMetric *)metric {
    MBDoctorEventCustom *event = [[MBDoctorEventCustom alloc] initWithPlatform:MBDoctorPlatformHubble];
    event.metricName = metric.metricName;
    event.metricValue = metric.metricValue;
    event.metricType = [self transferMetricType:metric.metricType];
    event.tags = @{@"page_name":metric.pageName?:@""};
    event.ext = metric.extraData;
    return event;
}

- (MBDoctorEventPerformance *)transferWakeupsMetric:(MBAPMWakeupsMetric *)metric {
    MBDoctorEventPerformance *event = [[MBDoctorEventPerformance alloc] initWithPlatform:MBDoctorPlatformHubble priority:(MBDoctorPriorityNormal)];
    event.metricType = MBDoctorMetricTypeGauge;
    event.metricValue = metric.metricValue;
    event.metricName = metric.metricName;
    NSMutableDictionary *tags = [NSMutableDictionary new];
    if(metric.tags){
        [tags addEntriesFromDictionary:metric.tags];
    }
    if (![NSString mb_isNilOrEmpty:metric.pageName]) {
        [tags setObject:metric.pageName forKey:@"page_id"];
    }
    event.tags = tags;
    event.metricSections = metric.metricSections;
    event.attrs = metric.attrs;
    event.ext = metric.extraData;
    return event;
}

- (MBDoctorEventPerformance *)transferTrafficMetric:(MBAPMTrafficMetric *)metric {
    MBDoctorEventPerformance *event = [[MBDoctorEventPerformance alloc] initWithPlatform:MBDoctorPlatformHubble priority:(MBDoctorPriorityNormal)];
    event.metricType = MBDoctorMetricTypeGauge;
    event.metricValue = metric.metricValue;
    event.metricName = metric.metricName;
    NSMutableDictionary *tags = [NSMutableDictionary new];
    if(metric.tags){
        [tags addEntriesFromDictionary:metric.tags];
    }
    if (![NSString mb_isNilOrEmpty:metric.pageName]) {
        [tags setObject:metric.pageName forKey:@"page_id"];
    }
    event.tags = tags;
    event.metricSections = metric.metricSections;
    event.ext = metric.extraData;
    event.attrs = metric.atts;
    return event;
}


- (MBDoctorMetricType)transferMetricType:(MBAPMMetricType) metricType {
    MBDoctorMetricType doctorMetricType = MBDoctorMetricTypeGauge;
    switch (metricType) {
        case MBAPMMetricTypeGauge:
            doctorMetricType = MBDoctorMetricTypeGauge;
            break;
        case MBAPMMetricTypeCounter:
            doctorMetricType = MBDoctorMetricTypeCounter;
        default:
            break;
    }
    return doctorMetricType;
}

- (NSString *)transferPageType:(MBAPMViewPageRenderType) renderType {
    NSString *pageType = @"native";
    switch (renderType) {
        case MBAPMViewPageRenderTypeNative:
            pageType = @"native";
            break;
        case MBAPMViewPageRenderTypeRN:
            pageType = @"rn";
            break;
        case MBAPMViewPageRenderTypeFlutter:
            pageType = @"flutter";
            break;
        case MBAPMViewPageRenderTypeH5:
            pageType = @"h5";
            break;
        default:
            break;
    }
    return pageType;
}

- (NSString *)transferLaunchType:(MBAPMAppLaunchType) launchType {
    NSString *doctorLaunchType = @"cold";
    switch (launchType) {
        case MBAPMAppLaunchTypeCold:
            doctorLaunchType = @"cold";
            break;
        case MBAPMAppLaunchTypeHot:
            doctorLaunchType = @"hot";
            break;
        default:
            break;
    }
    return doctorLaunchType;
}

- (NSString *)transferLagType:(MBAPMLagType) lagType {
    NSString *doctorLagType = @"long";
    switch (lagType) {
        case MBAPMLagTypeLong:
            doctorLagType = @"long";
            break;
        case MBAPMLagTypeShort:
            doctorLagType = @"short";
            break;
        case MBAPMLagTypeDead:
            doctorLagType = @"dead";
            break;
        default:
            break;
    }
    return doctorLagType;
}

- (NSString *)transferMemoryExceptionType:(MBAPMMemoryExceptionType)type {
    NSString *doctorExceptionType = @"MemoryWaning";
    switch (type) {
        case MBAPMMemoryExceptionTypeWarning:
            doctorExceptionType = @"MemoryWaning";
            break;
        case MBAPMMemoryExceptionTypeFOOM:
            doctorExceptionType = @"FOOM";
            break;
        default:
            break;
    }
    return doctorExceptionType;
}

- (NSString *)transferReportChannel:(MBAPMReportChannel)reportChannel {
    NSString *doctorReportChannel = @"APMLib";
    switch (reportChannel) {
        case MBAPMReportChannelAPMLib:
            doctorReportChannel = @"APMLib";
            break;
        case MBAPMReportChannelMatrix:
            doctorReportChannel = @"Matrix";
            break;
        default:
            break;
    }
    return doctorReportChannel;
}

@end
