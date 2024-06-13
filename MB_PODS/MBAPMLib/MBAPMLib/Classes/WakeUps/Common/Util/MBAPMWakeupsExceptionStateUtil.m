//
//  MBAPMWakeupsExceptionCacheUtil.m
//  MBAPMLib
//
//  Created by zhaozhao on 2024/3/13.
//

#import "MBAPMWakeupsExceptionStateUtil.h"
#import "MBAPMWakeupsDefine.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMCurrentPageInfo.h"
@import YYModel;
@import MMKV;

@interface MBAPMWakeupsExceptionStateUtil ()

@property (nonatomic, strong, readwrite) dispatch_queue_t cacheQueue;

@end


@implementation MBAPMWakeupsExceptionStateUtil

+ (instancetype)sharedInstance {
    static MBAPMWakeupsExceptionStateUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMWakeupsExceptionStateUtil alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self){
        // 在 app 接收到 UIApplicationWillTerminateNotification 时机清除 wakeups异常次数标记，排除 App 是被手动 kill 来减少误报
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillTerminate)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appWillTerminate{
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.cacheQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (NSString *key in [strongSelf allWakeupsCacheKeys]){
            [strongSelf _cleanCacheForKey:key];
        }
    });
}

#pragma mark - public methods

- (void)updateExceptionState:(nonnull MBAPMWakeupsExceptionStateModel *)state
                     forType:(MBAPMWakeupsExceptionType)type {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.cacheQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _setCache:state forKey:[strongSelf cacheKey:type]];
    });
}

- (void)fireCleanTimerForType:(MBAPMWakeupsExceptionType)type {
    __weak typeof(self) weakSelf = self;
    // 定时 5 秒后清除缓存
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), self.cacheQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf _cleanCacheForKey:[strongSelf cacheKey:type]];
    });
}


- (void)checkLastStateAndReportExceptionCrash {
    // 确保当前app生命周期期间只上报一次，避免被多次调用
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __weak typeof(self) weakSelf = self;
        dispatch_async(self.cacheQueue, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            for(NSString *key in [strongSelf allWakeupsCacheKeys]){
                MBAPMWakeupsExceptionStateModel *cache = [strongSelf _getCache:key];
                if(cache){
                    [strongSelf reportWakeupsCrashMetrics:cache];
                    [strongSelf _cleanCacheForKey:key];
                }
            }
        });
    });
}

#pragma mark - report crash metrics
- (void)reportWakeupsCrashMetrics:(MBAPMWakeupsExceptionStateModel *)cache {
    MBDoctorEventPerformance *event = [[MBDoctorEventPerformance alloc] initWithPlatform:MBDoctorPlatformHubble priority:(MBDoctorPriorityNormal)];
    event.metricName = @"app.error";
    event.metricType = MBDoctorMetricTypeCounter;
    event.metricValue = 0;

    NSString *errorTag = [self errorTag:cache.type];
    BOOL isForeground = [[MBAPMAppStateUtil shared] lastLaunchApplicationState] != UIApplicationStateBackground;

    NSMutableDictionary *tags = @{
        @"error_feature": errorTag,
        @"error_tag": errorTag,
        @"app_foreground": @(isForeground),
    }.mutableCopy;
    
    if(cache.pageId && cache.pageId.length > 0){
        [tags addEntriesFromDictionary:@{@"page_id": cache.pageId}];
    }
    
    if(cache.actionModel){
        [tags addEntriesFromDictionary:@{
            @"action_feature": cache.actionModel.eventFeature,
            @"action_type": @(cache.actionModel.eventType) //0-未知 1-pv 2-点击 3-进入前台 4-长链接/push
        }];
    }
    
    event.tags = tags;
    
    event.metricSections = @{
        @"continuous_count":@(cache.exceptionValue)
    };

    /**
     字段说明：
     continuousExceptions：连续发生异常时的异常取值数组
     */
    if(cache.continuousExceptionValues.count > 0){
        event.attrs = @{
            @"continuous_values": [cache.continuousExceptionValues yy_modelToJSONString]
        };
    }
    
    event.ext = @{
        @"launch_id": [[MBAPMAppStateUtil shared] lastLaunchId] ?: @"",
        @"app_start_time": @([MBAPMAppStateUtil shared].lastLaunchStartTime),
        @"app_crash_time": @([MBAPMAppStateUtil shared].lastLaunchEndTime)
    };

    MBModuleInfo *moduleInfo = [MBModuleInfo new];
    moduleInfo.moduleName = @"app";
    moduleInfo.subModuleName = @"apm";
    MBDoctorContext *context = [[MBDoctorContext alloc] initWithModuleInfo:moduleInfo];
    id<MBDoctorServiceProtocol> service = BIND_SERVICE(context, MBDoctorServiceProtocol);
    service.fromContext = context;
    [service doctor:event];
}

// error tag 有空格可以吗
- (NSString *)errorTag:(MBAPMWakeupsExceptionType) type {
    switch (type) {
        case MBAPMWakeupsExceptionTypeContinuousHigh:
            return @"wakeups continuous high";
        case MBAPMWakeupsExceptionTypeSuddenIncrease:
            return @"wakeups sudden increase";
        case MBAPMWakeupsExceptionTypeAvgLimitExceeded:
            return @"wakeups limit exceeded";
    }
}

#pragma mark - local cache storage

- (void)_setCache:(MBAPMWakeupsExceptionStateModel *)cache forKey:(NSString *)key {
    NSString *cacheStr = [cache yy_modelToJSONString];
    [[MMKV defaultMMKV] setString:cacheStr forKey:key];
}

- (void)_cleanCacheForKey:(NSString *)key {
    [[MMKV defaultMMKV] setObject:nil forKey:key];
}

- (MBAPMWakeupsExceptionStateModel *)_getCache:(NSString *)key {
    NSString *cacheStr = [[MMKV defaultMMKV] getStringForKey:key];
    if(cacheStr){
        return [MBAPMWakeupsExceptionStateModel yy_modelWithJSON:cacheStr];
    }
    return nil;
}

- (NSString *)cacheKey:(MBAPMWakeupsExceptionType) type {
    switch (type) {
        case MBAPMWakeupsExceptionTypeContinuousHigh:
            return MBAPMWakeupsContinuousHighExceptionCacheKey;
        case MBAPMWakeupsExceptionTypeSuddenIncrease:
            return MBAPMWakeupsSuddenIncreaseCacheKey;
        case MBAPMWakeupsExceptionTypeAvgLimitExceeded:
            return MBAPMWakeupsExceedLimitCacheKey;
    }
}

- (NSArray<NSString *> *)allWakeupsCacheKeys {
    return @[MBAPMWakeupsContinuousHighExceptionCacheKey, MBAPMWakeupsSuddenIncreaseCacheKey, MBAPMWakeupsExceedLimitCacheKey];
}


- (dispatch_queue_t)cacheQueue {
    if (!_cacheQueue) {
        _cacheQueue = dispatch_queue_create("com.mb.wakeups.cache.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _cacheQueue;
}

@end
