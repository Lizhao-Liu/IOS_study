//
//  MBAPMWhiteScreenMonitor.m
//  Pods
//
//  Created by 别施轩 on 2023/7/24.
//

#import "MBAPMWhiteScreenMonitor.h"
#import "MBAPMWhiteScreenDetector.h"
#import "MBAPMWhiteScreenMetric.h"
#import "MBAPMContext.h"
#import "MBAPMWhiteScreenCounter.h"

@import MBAPMServiceLib;
@import MBDoctorService;
@import YMMNetwork;

@interface MBAPMWhiteScreenMonitor () <MBAPMWhiteScreenDetectorDelegate>

@property (nonatomic, strong) MBAPMWhiteScreenDetector *whiteScreenDetector;

@end

@implementation MBAPMWhiteScreenMonitor

- (void)start {
    [super start];
    if (self.context.configuration.enableWhiteScreenMonitor) {
        self.whiteScreenDetector.apmConfiguration = self.context.configuration;
        [self.whiteScreenDetector startDetectWithDelegate:self];
    }
    
    [[MBAPMWhiteScreenCounter shared] setEnabled:self.context.configuration.enableMultipleWhiteScreen];
    if (self.context.configuration.enableMultipleWhiteScreen) {
        if (self.context.configuration.multipleWhiteScreenPageLimit > 0) {
            [[MBAPMWhiteScreenCounter shared] setPageFrequentCount:self.context.configuration.multipleWhiteScreenPageLimit];
        }
        if (self.context.configuration.multipleWhiteScreenTechStacklimit > 0) {
            [[MBAPMWhiteScreenCounter shared] setStackFrequentCount:self.context.configuration.multipleWhiteScreenTechStacklimit];
        }
        if (self.context.configuration.multipleWhiteScreenTechStackMiniPageCount > 0) {
            [[MBAPMWhiteScreenCounter shared] setStackFrequentPageMiniCount:self.context.configuration.multipleWhiteScreenTechStackMiniPageCount];
        }
        if (self.context.configuration.multipleWhiteScreenDetectDuration > 0) {
            [[MBAPMWhiteScreenCounter shared] setDetectDuration:self.context.configuration.multipleWhiteScreenDetectDuration];
        }
    }
    __weak typeof(self) weakSelf = self;
    [[MBAPMWhiteScreenCounter shared] setPageFrequentWhiteScreen:^(MBAPMWhiteScreenData * _Nonnull data, NSDictionary * _Nonnull attrs) {
        [weakSelf pageFrequentWhiteScreen:data attrs:attrs];
    }];
    [[MBAPMWhiteScreenCounter shared] setTechnicalStackFrequentWhiteScreen:^(MBAPMWhiteScreenData * _Nonnull data, NSDictionary * _Nonnull attrs) {
        [weakSelf stackFrequentWhiteScreen:data attrs:attrs];
    }];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagWhiteScreen;
}

// MARK: - MBAPMWhiteScreenCounter action

- (void)pageFrequentWhiteScreen:(MBAPMWhiteScreenData *) data attrs:(NSDictionary *)attrs {
    MBAPMWhiteScreenMetric *metric = [[MBAPMWhiteScreenMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWhiteScreen;
    metric.reportType = MBAPMWhiteScreenMetricReportTypeFrequentWhiteScreen;
    metric.metricName = @"app.page_safemode";
    metric.metricType = MBAPMMetricTypeCounter;
    metric.pageName = data.pageId ?: @"";
    metric.pagePath = data.pagePath;
    metric.pageClassName = data.pageClassName;
    metric.metricValue = 1;
    
    metric.errorFeature = [NSString stringWithFormat:@"%@页面发生连续白屏", data.pageId];
    metric.exceptionType = data.exceptionType;
    metric.lastStep = data.lastStep;
    metric.source = data.source;
    metric.attrs = @{@"highSpeedNetwork": @([YMMNetworkStatusObserver isHighSpeedNetwork])};
    metric.moduleInfo = data.moduleInfo;
    [self reportMetrics:metric];
}

- (void)stackFrequentWhiteScreen:(MBAPMWhiteScreenData *) data attrs:(NSDictionary *)attrs {
    MBAPMWhiteScreenMetric *metric = [[MBAPMWhiteScreenMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWhiteScreen;
    metric.reportType = MBAPMWhiteScreenMetricReportTypeTechStackFrequentWhiteScreen;
    metric.metricName = @"app.page_safemode";
    metric.metricType = MBAPMMetricTypeCounter;
    metric.pageName = data.pageId ?: @"";
    metric.pagePath = data.pagePath;
    metric.pageClassName = data.pageClassName;
    metric.metricValue = 1;
    
    metric.errorFeature = [NSString stringWithFormat:@"%@技术栈发生连续白屏", data.moduleInfo.bundleType ?: @"native"];
    metric.exceptionType = data.exceptionType;
    metric.lastStep = data.lastStep;
    metric.source = data.source;
    metric.attrs = @{@"highSpeedNetwork": @([YMMNetworkStatusObserver isHighSpeedNetwork])};
    metric.moduleInfo = data.moduleInfo;
    [self reportMetrics:metric];
}

// MARK: - MBAPMFPSDetectorDelegate
- (void)whiteScreen:(nonnull NSString *)pageName data:(nonnull MBAPMWhiteScreenData *)data {
    MBAPMWhiteScreenMetric *metric = [[MBAPMWhiteScreenMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWhiteScreen;
    metric.metricName = @"performance.white_screen";
    metric.metricType = MBAPMMetricTypeCounter;
    metric.pageName = data.pageId ?: @"";
    metric.pagePath = data.pagePath;
    metric.pageClassName = data.pageClassName;
    metric.metricValue = 1;
    
    metric.errorFeature = data.errorFeature;
    if (![YMMNetworkStatusObserver isNetworkEnable]) {
        metric.exceptionType = @"networkException";
    } else {
        metric.exceptionType = data.exceptionType;
    }
    metric.lastStep = data.lastStep;
    metric.source = data.source;
    metric.attrs = data.attrs;
    metric.moduleInfo = data.moduleInfo;
    [self reportMetrics:metric];
}

- (void)whiteScreenDetect:(nonnull NSString *)pageName data:(nonnull MBAPMWhiteScreenData *)data {
    MBAPMWhiteScreenMetric *metric = [[MBAPMWhiteScreenMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeWhiteScreen;
    metric.metricName = @"performance.white_screen_detect";
    metric.metricType = MBAPMMetricTypeGauge;
    metric.pageName = data.pageId ?: @"";
    metric.pagePath = data.pagePath;
    metric.pageClassName = data.pageClassName;
    metric.metricValue = 1;
    metric.reportType = MBAPMWhiteScreenMetricReportTypeWhiteScreenDetect;
    metric.hasBitMap = data.hasBitMap;
    
    metric.captureCostTime = data.captureCostTime;
    metric.analysisCostTime = data.analysisCostTime;
    metric.isCaptured = data.isCaptured;
    metric.isFinished = data.isFinished;
    metric.interruptType = data.interruptType;
    metric.isWhiteScreen = data.isWhiteScreen;
    metric.timeoutDuration = data.timeoutDuration;
    metric.captureRatio = data.captureRatio;
    metric.whitepixelRatio = data.whitepixelRatio;
    metric.moduleInfo = data.moduleInfo;
    metric.attrs = data.attrs;
    metric.bitmapDtectResult = data.bitmapDtectResult;
    [self reportMetrics:metric];
}


// MARK: - property

- (MBAPMWhiteScreenDetector *)whiteScreenDetector {
    if (_whiteScreenDetector) {
        return _whiteScreenDetector;
    }
    _whiteScreenDetector = [[MBAPMWhiteScreenDetector alloc] init];
    return _whiteScreenDetector;
}

@end
