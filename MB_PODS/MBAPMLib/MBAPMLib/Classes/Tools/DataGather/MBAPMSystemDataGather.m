//
//  MBAPMSystemDataGather.m
//  MBAPMLib
//
//  Created by xp on 2020/8/12.
//

#import "MBAPMSystemDataGather.h"
#import "MBAPMCPUUtil.h"
#import "MBAPMMemoryUtil.h"
#import "MBAPMFPSUtil.h"
#import "MBAPMStorageUtil.h"
#import "MBAPMSystemDataGatherConfig.h"
#import "MBAPMSystemDataCache.h"
#import "MBAPMLogDef.h"

@interface MBAPMSystemDataGather()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) MBAPMFPSUtil *fpsUtil;
@property (nonatomic, strong) MBAPMSystemDataCache *dataCache;
@property (nonatomic, strong) MBAPMSystemDataCache *pageDataCache;
@property (nonatomic, assign) BOOL shouldStartPageDataCache;
@property (nonatomic, assign) CGFloat lastPeakMemory;

@end

@implementation MBAPMSystemDataGather

+ (instancetype)sharedIntance {
    static MBAPMSystemDataGather *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MBAPMSystemDataGather new];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        _dataGatherfrequency = kMBAPMDataGatherDefaultFrequency;
        _dataGatherCacheItemCount = kMBAPMDataGatherCacheDefaultItemCount;
        _shouldStartPageDataCache = NO;
    }
    return self;
}

- (void)startDataGather:(UInt64)dataGatherfrequency {
    if (dataGatherfrequency > 0) {
        _dataGatherfrequency = dataGatherfrequency;
    }
    [self startDataGather];
}

- (void)startDataGather {
    [self.dataCache clearCache];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), self.dataGatherfrequency * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        CGFloat totalCpuUsage = [MBAPMCPUUtil totalCpuUsage];
        CGFloat appCpuUsage = [MBAPMCPUUtil appCpuUsage];
        CGFloat memoryUsage = [MBAPMMemoryUtil appMemoryUsage];
        CGFloat totalMemoryUsage = [MBAPMMemoryUtil totalMemoryUsage];
        CGFloat availableMemory = [MBAPMMemoryUtil availableMemory];
//        MBAPMDebug(@"MBAPM total cpu usage : %f app cpu usage : %f, memoryUsage : %f, totalMemoryUsage:%f, available memory:%f", totalCpuUsage, appCpuUsage, memoryUsage, totalMemoryUsage, availableMemory);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.lastPeakMemory = MAX(memoryUsage, weakSelf.lastPeakMemory);
            [weakSelf.dataCache addCPUUsageRecord:appCpuUsage totalCPUUsage:totalCpuUsage];
            [weakSelf.dataCache addMemoryUsageRecord:memoryUsage totalMemoeryUsage:totalMemoryUsage availableMemory:availableMemory];
            if (weakSelf.shouldStartPageDataCache) {
                [weakSelf.pageDataCache addCPUUsageRecord:appCpuUsage totalCPUUsage:totalCpuUsage];
            }
        });
    });
    dispatch_resume(self.timer);
    self.fpsUtil = [MBAPMFPSUtil sharedInstance];
    [self.fpsUtil startFPSMonitor:^(CGFloat fps) {
        [weakSelf.dataCache addFPSRecod:fps];
    }];
}

- (void)stopDataGather {
    if(self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    if(self.fpsUtil) {
        [self.fpsUtil stopFPSMonitor];
        self.fpsUtil = nil;
    }
}

- (void)startPageDataGather:(NSString *)pageName {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pageDataCache clearCache];
        self.shouldStartPageDataCache = YES;
    });
}

- (void)stopPageDataGather:(NSString *)pageName {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.shouldStartPageDataCache = NO;
        [self.pageDataCache clearCache];
    });
}

- (MBAPMSystemDataCache *)getCacheClient {
    return self.dataCache;
}

- (CGFloat)popLastPeakMemoryUse {
    CGFloat memory = self.lastPeakMemory;
    self.lastPeakMemory = 0;
    return memory;
}

- (void)dealloc {
    [self stopDataGather];
}


- (NSArray *)getLatestAppMemoryUsageForDuration:(NSInteger)duration {
    NSInteger count = duration / self.dataGatherfrequency;
    return [self.dataCache getLatestAppMemoryUsageForCount:count];
}
- (NSArray *)getLatestTotalMemoryUsageForDuration:(NSInteger)duration {
    NSInteger count = duration / self.dataGatherfrequency;
    return [self.dataCache getLatestTotalMemoryUsageForCount:count];
}
- (NSArray *)getLatestAvailableMemoryUsageForDuration:(NSInteger)duration {
    NSInteger count = duration / self.dataGatherfrequency;
    return [self.dataCache getLatestAvailableMemoryUsageForCount:count];
}

- (NSArray *)getLatestAppCPUUsageForDuration:(NSInteger)duration {
    NSInteger count = duration / self.dataGatherfrequency;
    return [self.dataCache getLatestAppCPUUsageForCount:count];
}
- (NSArray *)getLatestTotalCPUUsageForDuration:(NSInteger)duration {
    NSInteger count = duration / self.dataGatherfrequency;
    return [self.dataCache getLatestTotalCPUUsageForCount:count];
}


#pragma mark - Property Method

- (MBAPMSystemDataCache *)dataCache {
    if(!_dataCache) {
        _dataCache = [MBAPMSystemDataCache new];
        [_dataCache setCacheItemCount:self.dataGatherCacheItemCount];
    }
    return _dataCache;
}

- (MBAPMSystemDataCache *)pageDataCache {
    if(!_pageDataCache) {
        _pageDataCache = [MBAPMSystemDataCache new];
        [_pageDataCache setCacheItemCount:self.dataGatherCacheItemCount];
    }
    return _pageDataCache;
}

@end

