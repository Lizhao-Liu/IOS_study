//
//  MBAPMLagMonitor.m
//  MBAPMLib
//
//  Created by xp on 2020/8/15.
//

#import "MBAPMLagMonitor.h"
#import "MBRunloopStateLagDetector.h"
#import "MBFPSLagDetector.h"
#import "MBAPMLagMetric.h"
#import "MBAPMSystemDataGather.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMUUIDUtil.h"
#import "MBMatrixLagDetector.h"
#import "MBDeviceInfo.h"
#import "MBAPMLogDef.h"
#import "MBAPMCurrentPageInfo.h"
@import MBDoctorService;

static NSString * const kMetricDataKeyGatherfrequency = @"timeInterval";
static NSString * const kMetricDataKeyFPSInfo = @"fps";

@interface MBAPMLagMonitor()

@property (nonatomic, strong) NSObject<MBAPMLagDetectProtocol> *lagDetector;

@end

@implementation MBAPMLagMonitor

- (void)start {
    [super start];
    if (![MBDeviceInfo canEnableMonitor]) {
        MBAPMLogInfo(@"lag monitor can't be started on simulator or debugging status");
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [self.lagDetector startLagDetector:^(MBAPMReportChannel reportChannel, MBAPMLagType lagType, NSString *stack, NSString *keyFunction, NSTimeInterval startTime, NSTimeInterval duration, NSDictionary *systemInfo, NSInteger dumpType) {
        [weakSelf reportLagMetric:stack lagStartTime:startTime lagTotalTime:duration withKeyFunction:keyFunction withLagType:lagType reportChannel:reportChannel systemInfo:systemInfo dumpType:dumpType];
    }];
}

- (void)stop {
    [super stop];
    [self.lagDetector stopLagDetector];
//    [self.fpsLagDetector stopLagDetector];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagLagDetect;
}

#pragma mark - Private Method

- (void)reportLagMetric:(NSString *)callStack lagStartTime:(NSTimeInterval)startTime lagTotalTime:(NSTimeInterval)totalTime withKeyFunction:(NSString *)keyFunction withLagType:(MBAPMLagType)lagType reportChannel:(MBAPMReportChannel)reportChannel systemInfo:(NSDictionary *)systemInfo
    dumpType:(NSInteger)dumpType {
    MBAPMLagMetric *metric = [MBAPMLagMetric new];
    metric.reportChannel = reportChannel;
    metric.performanceType = MBAPMPerformanceTypeLag;
    metric.metricType = MBAPMMetricTypeCounter;
    metric.metricName = @"performance.lag";
    metric.metricValue = 1;
    metric.keyFunction = keyFunction;
    metric.lagType = lagType;
    metric.dumpType = dumpType;
    metric.lagStartTime = startTime;
    metric.lagTotalTime = totalTime;
    metric.pageId = [MBAPMCurrentPageInfo currentPageName];
    metric.stack = callStack;
    metric.bundles = [MBAPMUUIDUtil getUnsystemImageUUIDs];
    NSDictionary *cachedCpuInfo = [[[MBAPMSystemDataGather sharedIntance]getCacheClient]getCPUInfo];
    if(cachedCpuInfo) {
        NSMutableDictionary *cpuInfo = [NSMutableDictionary dictionaryWithDictionary:cachedCpuInfo];
        [cpuInfo setObject:@([MBAPMSystemDataGather sharedIntance].dataGatherfrequency) forKey:kMetricDataKeyGatherfrequency];
        metric.cpuInfo = cpuInfo;
    }
    if (systemInfo) {
        metric.systemInfo = systemInfo;
    }
    NSDictionary *cachedMemoryInfo = [[[MBAPMSystemDataGather sharedIntance]getCacheClient]getMemoryInfo];
    if(cachedMemoryInfo) {
        NSMutableDictionary *memoryInfo = [NSMutableDictionary dictionaryWithDictionary:cachedMemoryInfo];
        [memoryInfo setObject:@([MBAPMSystemDataGather sharedIntance].dataGatherfrequency) forKey:kMetricDataKeyGatherfrequency];
        metric.memoryInfo = memoryInfo;
    }
    
    NSArray *cachedFPSInfo = [[[MBAPMSystemDataGather sharedIntance]getCacheClient].fpsArray getAllItems];
    if(cachedFPSInfo) {
        NSMutableDictionary *fpsInfo = [NSMutableDictionary new];
        [fpsInfo setObject:@([MBAPMSystemDataGather sharedIntance].dataGatherfrequency) forKey:kMetricDataKeyGatherfrequency];
        [fpsInfo setObject:cachedFPSInfo forKey:kMetricDataKeyFPSInfo];
        metric.fpsInfo = fpsInfo;
    }
    [self reportMetrics:metric];
}


#pragma mark - Property Method

- (NSObject<MBAPMLagDetectProtocol> *)lagDetector {
    switch (_channel) {
        case MBAPMReportChannelMatrix:
            if(!_lagDetector) {
                _lagDetector = [MBMatrixLagDetector new];
            }
            return _lagDetector;
            break;
            
        default:
            if(!_lagDetector) {
                _lagDetector = [MBRunloopStateLagDetector new];
            }
            return _lagDetector;
            break;
//            if(!_fpsLagDetector) {
//                _fpsLagDetector = [MBFPSLagDetector new];
//            }
//            return _fpsLagDetector;
    }
}

@end
