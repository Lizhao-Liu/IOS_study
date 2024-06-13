//
//  MBAPMConfiguration.h
//  MBAPMServiceLib
//
//  Created by xp on 2020/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMEnv) {
    MBAPMEnvDebug,
    MBAPMEnvTest,
    MBAPMEnvRelease
};

typedef NS_ENUM(NSUInteger, MBAPMReportChannel) {
    MBAPMReportChannelAPMLib, //自研APM
    MBAPMReportChannelMatrix //Matrix
};

@interface MBAPMConfiguration : NSObject

@property (nonatomic, assign) MBAPMEnv env;

@property (nonatomic, assign) BOOL enableLagMonitor;

// 统计lag的渠道，默认自研APM
@property (nonatomic, assign) MBAPMReportChannel lagChannel;

@property (nonatomic, assign) BOOL enableCrashMonitor;

@property (nonatomic, assign) BOOL enableHookCrashHandler;

@property (nonatomic, assign) BOOL disableBackgroundLagCrash;

// *测试，发现个别用户持续oom，定位堆栈到了 HookBCECheckerFrida，此参数用于测试hook之后的现象
@property (nonatomic, assign) BOOL enableHookBCECheckerFrida;

@property (nonatomic, assign) BOOL enableDataGather;

@property (nonatomic, assign) BOOL enableMemoryMonitor;

@property (nonatomic, assign) BOOL enableFOOMMonitor;
@property (nonatomic, assign) int foomConfigSkipMinMallocSize;
@property (nonatomic, assign) int foomConfigSkipMaxStackDepth;
@property (nonatomic, assign) int foomConfigDumpCallStacks;
@property (nonatomic, assign) int foomConfigReportStrategy;

@property (nonatomic, copy) NSString *foomAutoStartConfig;
@property (nonatomic, copy) NSString *memoryLogAutoTagConfig;

@property (nonatomic, assign) BOOL enableLargeImageMonitor;
@property (nonatomic, assign) double largeImageThreshold;

@property (nonatomic, assign) BOOL enableLeakMonitor;
@property (nonatomic, assign) BOOL enableLeakMonitorOnOOM;
@property (nonatomic, assign) BOOL debugEnableLeakAlert;
@property (nonatomic, assign) BOOL debugEnableRetainCycleFinder;

@property (nonatomic, assign) BOOL enableMemoryLog;
@property (nonatomic, assign) BOOL enableMemoryWarningLog;
@property (nonatomic, assign) double memoryLogTimeInterval; // 暂时未用到
@property (nonatomic, copy) NSString *memoryLogIntervals;
// 页面 dealloc 或者达到 此个数 后会上报内存使用平均差值
@property (nonatomic, assign) int memoryLogAvgMaxCount;

@property (nonatomic, assign) uint64_t dataGatherFrequency;

@property (nonatomic, copy) NSArray<NSString *> *pageDataGatherWhiteList;

@property (nonatomic, copy) NSArray<NSString *> *renderDetectBlockList;

@property (nonatomic, strong) NSDictionary *cpuConfigDictionary;
// metric 数据收集开关,默认为 NO
@property (nonatomic, assign) BOOL enableMetricMonitor;
// 页面分段打点开关
@property (nonatomic, assign) BOOL enablePageDivideMonitor;
// 页面分段超时时间
@property (nonatomic, assign) NSUInteger pageDivideMonitorTimeout;
// 页面分段是否记录后台情况
@property (nonatomic, assign) BOOL pageDivideMonitorEnteredBackground;
// fps开关
@property (nonatomic, assign) BOOL enableFPSMonitor;
// 白屏开关
@property (nonatomic, assign) BOOL enableWhiteScreenMonitor;
// 白屏上传图片开关
@property (nonatomic, assign) BOOL enableWhiteScreenUploadImageMonitor;
// 白屏webview开关
@property (nonatomic, assign) BOOL enableWhiteScreenWebViewMonitor;
// 连续白屏开关
@property (nonatomic, assign) BOOL enableMultipleWhiteScreen;
// 连续白屏-页面-白屏个数
@property (nonatomic, assign) NSUInteger multipleWhiteScreenPageLimit;
// 连续白屏-技术栈-白屏个数
@property (nonatomic, assign) NSUInteger multipleWhiteScreenTechStacklimit;
// 连续白屏-技术栈-页面白屏最低个数
@property (nonatomic, assign) NSUInteger multipleWhiteScreenTechStackMiniPageCount;
// 连续白屏-检测时长
@property (nonatomic, assign) NSUInteger multipleWhiteScreenDetectDuration;
// 流量监控开关, 默认关
@property (nonatomic, assign) BOOL enableNetTraffic;
@end

NS_ASSUME_NONNULL_END
