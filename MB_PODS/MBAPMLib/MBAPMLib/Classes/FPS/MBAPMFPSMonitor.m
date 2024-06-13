//
//  MBAPMFPSMonitor.m
//  AAChartKit-AAChartKitLib
//
//  Created by 别施轩 on 2023/7/11.
//

#import "MBAPMFPSMonitor.h"
#import "MBAPMFPSDataManager.h"
#import "MBAPMFPSDetector.h"
#import "MBDeviceInfo.h"
#import "MBAPMLogDef.h"
#import "MBAPMFPSMetric.h"
#import "MBDeviceInfo.h"
#import "MBAPMContext.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMFPSUtil.h"

@import MBAPMServiceLib;
@import MBDoctorService;

@interface MBAPMFPSMonitor () <MBAPMFPSDetectorDelegate>

@property (nonatomic, strong) MBAPMFPSDetector *fpsDetector;

@end

@implementation MBAPMFPSMonitor
- (void)start {
    [super start];
    if (self.context.configuration.enableFPSMonitor) {
        if (![MBDeviceInfo canEnableMonitor]) {
            MBAPMLogInfo(@"fps monitor can't be started on simulator or debugging status");
            return;
        }
        [self.fpsDetector startDetectWithDelegate:self];
    }
}

- (void)stop {
    [super stop];
    [self.fpsDetector stopDetect];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagFPS;
}

//MARK: - MBAPMFPSDetectorDelegate
- (void)pageFpsAvg:(nonnull NSString *)pageName fpsData:(nonnull MBAPMFPSDataResponse *)fpsData moduleInfo:(nonnull MBModuleInfo *)moduleInfo {
    MBAPMFPSMetric *metric = [[MBAPMFPSMetric alloc]init];
    metric.performanceType = MBAPMPerformanceTypeFPS;
    metric.metricName = @"performance.fps";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = pageName?:@"";
    metric.pageClassName = fpsData.pageClassName;
    metric.pagePath = fpsData.pagePath;
    metric.metricValue = [@(fpsData.fpsAvg ?: 0) integerValue];
    metric.isHighFps = [[MBAPMFPSUtil sharedInstance] isHighFps];
    
    metric.type = MBAPMFPSMetricTypePageAvg;
    metric.duration = fpsData.duration;
    metric.deviceLevel = [MBDeviceInfo deviceScore];
    metric.fpsDetail = fpsData.fpsData;
    
    metric.moduleInfo = moduleInfo;
    [self reportMetrics:metric];
}

- (void)scrollFps:(nonnull NSString *)pageName fpsData:(nonnull MBAPMFPSDataResponse *)fpsData moduleInfo:(nonnull MBModuleInfo *)moduleInfo {
    MBAPMFPSMetric *metric = [[MBAPMFPSMetric alloc]init];
    metric.performanceType = MBAPMPerformanceTypeFPS;
    metric.metricName = @"performance.fps_scroll";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = pageName?:@"";
    metric.pageClassName = fpsData.pageClassName;
    metric.pagePath = fpsData.pagePath;
    metric.metricValue = [@(fpsData.fpsScore ?: 0) integerValue];
    metric.isHighFps = [[MBAPMFPSUtil sharedInstance] isHighFps];
    
    metric.type = MBAPMFPSMetricTypeScroll;
    metric.duration = fpsData.duration;
    metric.deviceLevel = [MBDeviceInfo deviceScore];
    metric.fpsDetail = fpsData.fpsData;
    metric.cpuDetail = fpsData.cpuData;
    
    metric.moduleInfo = moduleInfo;
    [self reportMetrics:metric];
}

//MARK: - Property
- (MBAPMFPSDetector *)fpsDetector {
    if (_fpsDetector) {
        return _fpsDetector;
    }
    _fpsDetector = [[MBAPMFPSDetector alloc] init];
    return _fpsDetector;
}
@end
