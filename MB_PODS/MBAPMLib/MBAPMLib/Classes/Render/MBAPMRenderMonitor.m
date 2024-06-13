//
//  MBRenderMonitorPlugin.m
//  MBAPMLib
//
//  Created by xp on 2020/7/6.
//

#import "MBAPMRenderMonitor.h"
#import "MBAPMRenderDetector.h"
#import "MBAPMPageRenderMetric.h"
#import "MBAPMViewPageContext.h"
#import "MBAPMContext.h"
#import "MBAPMPluginConfig.h"
#import "MBAPMTimeTrack.h"
#import "MBAPMEventTimeTrackTask.h"
#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMSystemDataGather.h"
#import "MBAPMLogDef.h"
#import "MBAPMRouterIntercepter.h"
#import "MBAPMPageLaunchDivideCenter.h"
#import "MBAPMNetworkInterceptor.h"
@import MBFoundation;

@import MBAPMServiceLib;
@import YYModel;
@import MBUIKit;
@import MBDoctorService;
@import YMMModuleLib;

static NSString * const kMBRenderMonitorEventID = @"render_detect";

@interface MBAPMRenderMonitor() <MBRenderDetectDelegate>

@end

@implementation MBAPMRenderMonitor

#pragma mark - public method

- (void)start{
    [super start];
    if (self.context.configuration.enablePageDivideMonitor) {
        [[YMMRouterCenter shared]addInterceptor:[MBAPMRouterIntercepter new]];
        
        [[MBAPMPageLaunchDivideCenter sharedInstance] startMonitor];
        __weak typeof(self) weakSelf = self;
        [[MBAPMPageLaunchDivideCenter sharedInstance] setReportBlock:^(MBDoctorEventPerformance * _Nonnull performance, MBModuleInfo * _Nonnull moduleInfo) {
            [weakSelf reportDivideCenterEventTime:performance moduleInfo:moduleInfo];
        }];
        
        [MBAPMNetworkInterceptor configPlugin];
    }
}

- (void)abort {
    [super abort];
}

- (void)stop {
    [super stop];
    [[MBAPMPageLaunchDivideCenter sharedInstance] stopMonitor];
}

- (id<MBAPMEventTrack>)startTrackWithPageContext:(MBAPMViewPageContext *)context {
    if(![self isPageRenderDetectEnabled:context]) {
        return nil;
    }
    if(context.detectType == MBAPMViewPageRenderDetectTypeManaul || context.detectType == MBAPMViewPageRenderDetectTypeLifeCycle) {
        MBAPMTimeTrackTask *track = [[MBAPMTimeTrack shared]createTask:kMBRenderMonitorEventID];
           [track begin];
           __weak typeof(self) weakSelf = self;
           [track caculateDividedByPoints:^(UInt64 totalTime, NSDictionary<NSString *,NSNumber *> * _Nonnull timeDic) {
               [weakSelf reportTimeTrack:totalTime withTimeSections:timeDic pageContext:context withExtraData:track.extraData];
           }];
        return track;
    } else if(context.detectType == MBAPMViewPageRenderDetectTypeText){
        MBAPMRenderDetector *detector = [[MBAPMRenderDetector alloc]initWithPageContext:context];
        [detector setDetectDelegate:self];
        [detector begin];
        return detector;
    }
    return nil;
}

- (id<MBAPMEventTrack>)startTrack:(id<MBAPMViewPageProtocol>)viewPage {
    if(![self.config isEnable]) {
        return nil;
    }
    NSAssert(viewPage != nil, @"viewPage can't be nil");
    MBAPMViewPageContext *context = [[MBAPMViewPageContext alloc]initWithPageProtocol:viewPage];
    if([NSString mb_isNilOrEmpty:context.pageName]) {
           context.pageName = NSStringFromClass([viewPage class]);
    }
    return [self startTrackWithPageContext:context];
}

- (id<MBAPMEventTimeTrack>)startEventTimeTrack:(id<MBAPMViewPageProtocol>)viewPage {
    if(![self.config isEnable]) {
        return nil;
    }
    NSAssert(viewPage != nil, @"viewPage can't be nil");
    MBAPMViewPageContext *context = [[MBAPMViewPageContext alloc]initWithPageProtocol:viewPage];
    if([NSString mb_isNilOrEmpty:context.pageName]) {
           context.pageName = NSStringFromClass([viewPage class]);
    }
    if(![self isPageRenderDetectEnabled:context]) {
        return nil;
    }
    
    if(context.detectType == MBAPMViewPageRenderDetectTypeManaul) {
        id<MBAPMEventTimeTrack> trackTask = [MBAPMEventTimeTrackMgr createTrack];
        __weak typeof(self) weakSelf = self;
        [trackTask setCompleteBlock:^(BOOL result, NSString * _Nullable msg, id<MBAPMEventTimeTrackRecordProtocol> _Nonnull timeTrackResult) {
            if (result) {
                [weakSelf reportEventTimeTrackResult:timeTrackResult pageContext:context];
            } else {
                MBAPMWarning(@"event time truck fails: %@", msg);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBAPMEventTimeTrackMgr removeTrack:timeTrackResult.trackID];
            });
        }];
        return trackTask;
    } else {
        MBAPMWarning(@"detectType obtained by renderDetectTypeForAPM function is incorrect");
    }
    return nil;
}

- (void)startPagePerformanceTrack:(MBAPMViewPageContext *)pageContext {
    if (pageContext.pageName && [self.context.configuration.pageDataGatherWhiteList containsObject:pageContext.pageName]) {
        [[MBAPMSystemDataGather sharedIntance]startPageDataGather:pageContext.pageName];
    }
}

- (void)stopPagePerformanceTrack:(MBAPMViewPageContext *)pageContext {
    if (pageContext.pageName && [self.context.configuration.pageDataGatherWhiteList containsObject:pageContext.pageName]) {
        MBAPMSystemDataCache *dataCache = [[MBAPMSystemDataGather sharedIntance]getCacheClient];
        CGFloat averageCPUUsage = [dataCache getAverageCPUUsage];
        NSDictionary *extraData = [dataCache getCPUInfo];
        [self reportPagePerformanceData:averageCPUUsage pageName:pageContext.pageName withExtraData:extraData];
        [[MBAPMSystemDataGather sharedIntance]stopPageDataGather:pageContext.pageName];
        
    }
}

- (void)reportMetrics:(MBAPMMetric *)metric {
    [super reportMetrics:metric];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagRenderDetect;
}

#pragma mark - private method

- (void)reportPagePerformanceData:(CGFloat)averageCPUUsage pageName:(NSString *)pageName withExtraData:(NSDictionary *)extraData {
    MBAPMMetric *metric = [[MBAPMMetric alloc]init];
    metric.performanceType = MBAPMPerformanceTypePageCPUUsage;
    metric.metricName = @"app.apm.pageCPUUsage";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = pageName?:@"";
    metric.metricValue = averageCPUUsage;
    metric.extraData = extraData;
    [self reportMetrics:metric];
}

- (void)reportTimeTrack:(UInt64)totalTime withTimeSections:(NSDictionary<NSString *, NSNumber *> *)timeSections pageContext:(MBAPMViewPageContext *)pageContext withExtraData:(NSDictionary *)extraData{
    MBAPMPageRenderMetric *metric = [[MBAPMPageRenderMetric alloc]init];
    metric.performanceType = MBAPMPerformanceTypePageRender;
    metric.metricName = @"performance.pageview";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = pageContext.pageName;
    metric.metricValue = totalTime;
    metric.detectType = pageContext.detectType;
    metric.renderResult = YES;
    metric.pageType = pageContext.renderType;
    metric.detectStatus = MBAPMRenderDetectSuccess;
    metric.timeSections = timeSections;
    metric.extraData = extraData;
    [self reportMetrics:metric];
}

- (void)reportEventTimeTrackResult:(id<MBAPMEventTimeTrackRecordProtocol>)trackResult pageContext:(MBAPMViewPageContext *)pageContext {
    MBAPMPageRenderMetric *metric = [[MBAPMPageRenderMetric alloc]init];
    metric.performanceType = MBAPMPerformanceTypePageRender;
    metric.metricName = @"performance.pageview";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = pageContext.pageName;
    metric.metricValue = [trackResult getTotalElapsedTime];
    metric.detectType = pageContext.detectType;
    metric.renderResult = YES;
    metric.pageType = pageContext.renderType;
    metric.detectStatus = MBAPMRenderDetectSuccess;
    metric.timeSections = [trackResult getSectionsDict];
    NSMutableDictionary *extraData = [NSMutableDictionary new];
    NSDictionary *wholeExt = [trackResult getWholeExt];
    if (wholeExt) {
        [extraData addEntriesFromDictionary:wholeExt];
    }
    NSDictionary *sectionsExt = [trackResult getSectionsExt];
    if (sectionsExt) {
        [extraData setObject:sectionsExt forKey:@"sections_ext"];
    }
    metric.extraData = extraData;
    [self reportMetrics:metric];
}

- (void)reportDivideCenterEventTime:(MBDoctorEventPerformance * _Nonnull)performance moduleInfo:(MBModuleInfo * _Nonnull)moduleInfo {
    MBBaseContext *context = [MBBaseContext new];
    context.moduleInfo = moduleInfo;
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(context, MBDoctorServiceProtocol);
    [service doctor:performance];
}

- (BOOL)isPageRenderDetectEnabled:(MBAPMViewPageContext *)pageContext {
    if(!pageContext || !pageContext.renderDetectEnabled || ![self.config isEnable]) {
        return NO;
    }
    NSString *pageClassName = pageContext.className;
    NSArray *blockList = self.context.allRenderDetectBlockList;
    if([blockList containsObject:pageClassName] || [pageClassName hasPrefix:@"_"] || [pageClassName hasPrefix:@"UI"]) {
        return NO;
    }
    Class pageClass = NSClassFromString(pageClassName);
    if([pageClass isKindOfClass:[UINavigationController class]] || [self isKindOfClass:[UITabBarController class]] || [self conformsToProtocol:@protocol(MBUITabBarControllerProtocol)] || [self isKindOfClass:[UIInputViewController class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - MBRenderDetectDelegate回调

- (void)onRenderDetectFinish:(MBAPMPageRenderMetric *)metric {
    [self reportMetrics:metric];
}

@end
