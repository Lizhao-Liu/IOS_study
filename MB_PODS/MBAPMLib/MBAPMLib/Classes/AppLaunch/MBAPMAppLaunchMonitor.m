//
//  MBAPMAppLaunchMonitor.m
//  MBAPMLib
//
//  Created by xp on 2020/7/15.
//

#import "MBAPMAppLaunchMonitor.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import <sys/sysctl.h>
#import "NSMutableDictionary+MBAPMSort.h"
#import "MBAPMEventTimeTrackMgr.h"
#import "MBAPMAppLaunchMetric.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMLogDef.h"
#import "MBAPMContext.h"
#import "MBMatrixWechatManager.h"
@import UIKit;
@import RSSwizzle;
@import MBAPMServiceLib;
@import MBFoundation;
@import MBLauncherLib;

#define kMBAPMLaunchOverTime 15.f //启动超时时间

static long long sPremainElapsedTime = 0; //premain耗时
static long long sPostmainStartTime = -1; //postmain开始时间
static NSString * const kEventId_AppLaunch = @"MBAPMTimeTrack_EventId_AppLaunch";
static NSString * const kEventId_AppHotLaunch = @"MBAPMTimeTrack_EventId_AppHotLaunch";
static NSString * const kAppLaunch_SectionName_PreMain = @"t1";
static NSString * const kAppLaunch_SectionName_DidFinish = @"t2";
static NSString * const kAppLaunch_SectionName_LaunchScreen = @"t3";
static NSString * const kAppLaunch_SectionName_End = @"t4";
static NSString * const kAppLaunch_EndPoint_Default = @"default";


static BOOL sCustomLaunchEndingIsEnable = NO; //是否开启自定义启动终点

@interface MBAPMAppLaunchMonitor() {
    BOOL _enterBackgroundAfterLaunch; //启动后直接进入后台标志位
    BOOL _endLaunchSuccessed; //启动流程执行成功标志位
    MBAPMAppLaunchTimeModel *_appLaunchTimeModel; //启动耗时模型
    MBAPMLaunchTimeCallback _launchTimeCallback;
    MBLaunchMode _launchMode; // 当次启动模式
    long long _launchIntervalTime; // 在首次安装的场景下启动会存在两次启动，两次启动中间间隔时间为用户同意隐私协议时间
    long long _lastLaunchEndTime; // 两次启动前一次启动结束时间
    MBLaunchMode _lastLaunchMode; // 两次启动前一次启动模式
    NSDictionary *_launchTags; // 启动携带的自定义维度参数
}

@property (nonatomic, strong) id<MBAPMEventTimeTrack> coldLaunchTimeTrack;

@property (nonatomic, strong) id<MBAPMEventTimeTrack> hotLaunchTimeTrack;

@end

@implementation MBAPMAppLaunchMonitor

#pragma mark - public super method

+ (BOOL)isSingleton {
    return YES;
}

- (BOOL)isSelfStart {
    return YES;
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagAppLaunch;
}

+ (id)shareInstance {
    static MBAPMAppLaunchMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMAppLaunchMonitor alloc]init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _enterBackgroundAfterLaunch = NO;
        _launchMode = MBLaunchModeNone;
        _launchIntervalTime = 0;
        _lastLaunchEndTime = 0;
        _lastLaunchMode = MBLaunchModeNone;
    }
    return self;
}

#pragma mark - public method

+ (void)enableCustomLaunchEnding {
    sCustomLaunchEndingIsEnable = YES;
}

- (void)startAppLaunch:(MBLaunchMode)launchMode launchTags:(NSDictionary *)tags {
    MBAPMLogInfo(@"MBAPM app cold launch start, currentLaunchMode = %lu, lastLaunchMode = %lu", launchMode, _lastLaunchMode);
    _lastLaunchMode = _launchMode;
    _launchTags = tags;
    if (_lastLaunchEndTime > 0) {
        _launchIntervalTime = [MBAPMTimeUtil currentTimestamp] - _lastLaunchEndTime;
    }
    _launchMode = launchMode;
    if (sPostmainStartTime < 0) {
        long long processStartTime = [MBAPMAppLaunchMonitor processStartTime];
        sPostmainStartTime = [MBAPMTimeUtil currentTimestamp];
        sPremainElapsedTime = sPostmainStartTime  - processStartTime;
        if (sPremainElapsedTime > 1000 * 60) {
            //处理app退到后台被杀后进程重启，但是生命周期没有立刻执行导致premain端耗时异常问题
            sPremainElapsedTime = 0;
        }
    }
    if (_launchMode != MBLaunchModePrivacyProtocol) {
        [self startLaunchWatchDog];
    }
    if (!self.coldLaunchTimeTrack) {
        self.coldLaunchTimeTrack = [MBAPMEventTimeTrackMgr createTrack];
        __weak typeof(self) weakSelf = self;
        [self.coldLaunchTimeTrack setCompleteBlock:^(BOOL result, NSString * _Nullable msg, id<MBAPMEventTimeTrackRecordProtocol> _Nonnull timeTrackResult) {
            if (!result) {
                return;
            }
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSDictionary *associatedData = nil;
            if ([strongSelf.coldLaunchTimeTrack respondsToSelector:@selector(associatedData)]) {
                associatedData = strongSelf.coldLaunchTimeTrack.associatedData;
            }
            [strongSelf reportTimeData:timeTrackResult associatedData:associatedData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBAPMEventTimeTrackMgr removeTrack:timeTrackResult.trackID];
                strongSelf.coldLaunchTimeTrack = nil;
            });
        }];
        [self.coldLaunchTimeTrack begin:nil];
    }
   
}

- (void)endAppLaunch:(NSString *)endPointName {
    _lastLaunchEndTime = [MBAPMTimeUtil currentTimestamp];
    if (_launchMode == MBLaunchModePrivacyProtocol) {
        MBAPMLogInfo(@"MBAPM app cold launch shoudn't be ended after privacy protocol page has shown");
        return;
    }
    if (_enterBackgroundAfterLaunch) {
        MBAPMWarning(@"MBAPM app cold launch end background");
        return;
    }
    if (!sCustomLaunchEndingIsEnable) {
        if (!endPointName || endPointName.length <= 0) {
            endPointName = kAppLaunch_EndPoint_Default;
        }
        if (![self hasLaunchSuccessed]) {
            [self.coldLaunchTimeTrack end:kAppLaunch_SectionName_End withExtra:@{@"endPoint":endPointName}];
            [self markLaunchSuccess];
        }
    }
}

- (void)customEndAppLaunch {
    _lastLaunchEndTime = [MBAPMTimeUtil currentTimestamp];
    if (_launchMode == MBLaunchModePrivacyProtocol) {
        MBAPMLogInfo(@"MBAPM app cold launch shoudn't be ended after privacy protocol page has shown");
        return;
    }
    if (_enterBackgroundAfterLaunch) {
        MBAPMWarning(@"MBAPM app cold launch end background");
        return;
    }
    if(sCustomLaunchEndingIsEnable) {
        if (![self hasLaunchSuccessed]) {
            [self.coldLaunchTimeTrack end:kAppLaunch_SectionName_End withExtra:nil];
            [self markLaunchSuccess];
        }
    }
}

- (void)applicationDidFinishLaunch {
    [self.coldLaunchTimeTrack section:kAppLaunch_SectionName_DidFinish withExtra:nil];
    [self.coldLaunchTimeTrack section:kAppLaunch_SectionName_LaunchScreen withExtra:nil];
}

- (void)applicationWillFinishLaunch {
}


- (void)applicationWillEnterForeground {
    __weak typeof(self) weakSelf = self;
    self.hotLaunchTimeTrack = [MBAPMEventTimeTrackMgr createTrack];
    [self.hotLaunchTimeTrack setCompleteBlock:^(BOOL result, NSString * _Nullable msg, id<MBAPMEventTimeTrackRecordProtocol> _Nonnull timeTrackResult) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reportHotLaunchMetric:[timeTrackResult getTotalElapsedTime]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBAPMEventTimeTrackMgr removeTrack:timeTrackResult.trackID];
        });
    }];
    [self.hotLaunchTimeTrack begin:nil];
}

- (void)applicationDidEnterBackground {
    self.coldLaunchTimeTrack = nil;
    self.hotLaunchTimeTrack = nil;
    _enterBackgroundAfterLaunch = YES;
}

- (void)applicationDidBecomeActive {
    [self.hotLaunchTimeTrack end:nil];
}

- (id)getAppLaunchTrack {
    return self.coldLaunchTimeTrack;
}

- (MBAPMAppLaunchTimeModel *)getAppLaunchTime {
    return _appLaunchTimeModel;
}

- (void)asyncGetAppLaunchTime:(MBAPMLaunchTimeCallback)callback {
    _launchTimeCallback = callback;
    if (_appLaunchTimeModel) {
        _launchTimeCallback(_appLaunchTimeModel);
    }
}

- (UInt64)getAppLaunchStartTime {
    return sPostmainStartTime;
}

- (BOOL)hasLaunchSuccessed {
    return _endLaunchSuccessed;
}

#pragma mark - private method

- (void)markLaunchSuccess {
    _endLaunchSuccessed = YES;
    self.context.hasLaunchSuccess = YES;
}

- (void)startLaunchWatchDog {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kMBAPMLaunchOverTime * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (!self->_endLaunchSuccessed && !self->_enterBackgroundAfterLaunch) {
            [self reportLaunchTimeout];
        }
    });
}

- (void)reportLaunchTimeout {
    MBAPMWarning(@"MBAPM app cold launch timeout");
    MBAPMAppLaunchMetric *appLaunchMetric = [[MBAPMAppLaunchMetric alloc]init];
    appLaunchMetric.performanceType = MBAPMPerformanceTypeAppLaunch;
    appLaunchMetric.metricType = MBAPMMetricTypeCounter;
    appLaunchMetric.metricName = @"performance.applaunch";
    appLaunchMetric.launchType = MBAPMAppLaunchTypeCold;
    appLaunchMetric.isLaunchTimeOut = YES;
    NSMutableDictionary *extraData = [NSMutableDictionary new];
    [extraData setObject:@([MBAPMAppLaunchMonitor processStartTime]) forKey:@"processStartTime"];
    [extraData setObject:@(sPostmainStartTime) forKey:@"postmainStartTime"];
    [extraData addEntriesFromDictionary:[self getSystemSettingProperty]];
    appLaunchMetric.extraData = extraData;
    appLaunchMetric.metricValue = 1;
    [[MBAPMAppLaunchMonitor shareInstance]reportMetrics:appLaunchMetric];
}

- (void)reportTimeData:(id<MBAPMEventTimeTrackRecordProtocol>)trackResult associatedData:(NSDictionary *)associatedData {
    UInt64 launchElapsedTime = [trackResult getTotalElapsedTime] + sPremainElapsedTime - _launchIntervalTime; //启动总时长=开始启动到结束启动的时间间隔+premain阶段未统计时长-两次启动间的间隔时长
    UInt64 launchEndTimestamp = [trackResult getBeginTimestamp];
    NSString *endPointName = [[trackResult getWholeExt] objectForKey:@"endPoint"];
    NSMutableDictionary<NSString *, NSNumber *> *wholeTimeDic = [[NSMutableDictionary alloc]initWithDictionary:[trackResult getSectionsDict] copyItems:YES];
    [wholeTimeDic setValue:@(sPremainElapsedTime) forKey:kAppLaunch_SectionName_PreMain];
//    MBAPMDebug(@"MBAPM app cold launch elapsedTime = %@", wholeTimeDic);
    MBAPMAppLaunchMetric *appLaunchMetric = [[MBAPMAppLaunchMetric alloc]init];
    appLaunchMetric.performanceType = MBAPMPerformanceTypeAppLaunch;
    appLaunchMetric.metricType = MBAPMMetricTypeGauge;
    appLaunchMetric.lastShutOffType = [[MBMatrixWechatManager sharedInstance] getAppBootType];
    appLaunchMetric.time_interval = [MBAPMAppLaunchMonitor divideLaunchTimeInterval:launchElapsedTime];
    appLaunchMetric.metricName = @"performance.applaunch";
    appLaunchMetric.launchType = MBAPMAppLaunchTypeCold;
    appLaunchMetric.timeSections = wholeTimeDic;
    appLaunchMetric.isLaunchTimeOut = NO;
    appLaunchMetric.launchMode = _launchMode;
    appLaunchMetric.lastLaunchMode = _lastLaunchMode;
    appLaunchMetric.tags = _launchTags;
    NSMutableDictionary *extraData = [NSMutableDictionary new];
    NSDictionary *wholeExt = [trackResult getWholeExt];
    if (wholeExt) {
        [extraData addEntriesFromDictionary:wholeExt];
    }
    NSDictionary *sectionExt = [trackResult getSectionsExt];
    if (sectionExt) {
        [extraData setObject:sectionExt forKey:@"sections_ext"];
    }
    if (associatedData) {
        [extraData addEntriesFromDictionary:associatedData];
    }
    [extraData setObject:@([MBAPMAppLaunchMonitor processStartTime]) forKey:@"processStartTime"];
    [extraData setObject:@(sPostmainStartTime) forKey:@"postmainStartTime"];
    [extraData addEntriesFromDictionary:[self getSystemSettingProperty]];
    appLaunchMetric.extraData = extraData;
    appLaunchMetric.metricValue = launchElapsedTime;
    [[MBAPMAppLaunchMonitor shareInstance]reportMetrics:appLaunchMetric];
    // 构造暴露给外部的启动耗时模型
    _appLaunchTimeModel = [MBAPMAppLaunchTimeModel new];
    _appLaunchTimeModel.elapsedTime = launchElapsedTime;
    _appLaunchTimeModel.endTimestamp = launchEndTimestamp;
    if ([@"YMMTabBarController" isEqualToString:endPointName] || [@"MBCustomTabBarController" isEqualToString:endPointName]) {
        _appLaunchTimeModel.isMainPage = YES;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf->_launchTimeCallback) {
            strongSelf->_launchTimeCallback(strongSelf->_appLaunchTimeModel);
        }
    });
}

- (NSDictionary *)getSystemSettingProperty {
    NSMutableDictionary *settingDict = [NSMutableDictionary new];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    if (localTimeZone) {
        NSString *timeZoneStr = [localTimeZone name];
        if (![NSString mb_isNilOrEmpty:timeZoneStr]) {
            [settingDict setObject:timeZoneStr?:@"" forKey:@"timeZone"];
        }
    }
    NSString *localeCountryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if (![NSString mb_isNilOrEmpty:localeCountryCode]) {
        [settingDict setObject:localeCountryCode?:localeCountryCode forKey:@"localeCountryCode"];
    }
    return settingDict.copy;
}

- (void)reportHotLaunchMetric:(UInt64) totalTime {
    MBAPMDebug(@"MBAPM app hot launch elapsedTime = %lld", totalTime);
    MBAPMAppLaunchMetric *appLaunchMetric = [[MBAPMAppLaunchMetric alloc]init];
    appLaunchMetric.performanceType = MBAPMPerformanceTypeAppLaunch;
    appLaunchMetric.metricType = MBAPMMetricTypeGauge;
    appLaunchMetric.metricName = @"performance.applaunch";
    appLaunchMetric.launchType = MBAPMAppLaunchTypeHot;
    appLaunchMetric.metricValue = totalTime;
    appLaunchMetric.isLaunchTimeOut = NO;
    [self reportMetrics:appLaunchMetric];
}

+ (long long)processStartTime
{
    struct kinfo_proc kProcInfo;
    if ([self processInfoForPID:[[NSProcessInfo processInfo] processIdentifier] procInfo:&kProcInfo]) {
        return kProcInfo.kp_proc.p_un.__p_starttime.tv_sec * 1000 + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000;
    } else {
        NSAssert(NO, @"无法取得进程的信息");
        return 0;
    }
}

+ (BOOL)processInfoForPID:(int)pid procInfo:(struct kinfo_proc*)procInfo
{
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(*procInfo);
    return sysctl(cmd, sizeof(cmd)/sizeof(*cmd), procInfo, &size, NULL, 0) == 0;
}

+ (NSInteger)divideLaunchTimeInterval:(UInt64)launchTime {
    if (launchTime < 0) {
        return 0;
    } else if (launchTime >= 0 && launchTime <= 1000) {
        return 1;
    } else if (launchTime > 1000 && launchTime <= 1500) {
        return 2;
    } else if (launchTime > 1500 && launchTime <= 2000) {
        return 3;
    } else if (launchTime > 2000 && launchTime <= 3000) {
        return 4;
    } else if (launchTime > 3000 && launchTime <= 5000) {
        return 5;
    } else if (launchTime > 5000 && launchTime <= 10000) {
        return 6;
    } else {
        return 7;
    }
}

@end
