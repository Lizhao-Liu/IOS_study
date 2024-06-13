//
//  MBAPMMemoryImageMonitor.m
//
//
//  Created by seal on 2022/5/30.
//

@import Foundation;
#import "MBMemoryLogDetector.h"
#import "MBAPMMemoryUtil.h"
#import "MBAPMLogDef.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMSystemDataGather.h"

static MBMemoryLogModel *mb_lastMemoryLog = nil;
static CGFloat mb_lastLaunchAppMemoryUsagePercent = 0;
static CGFloat mb_lastLaunchAppFreeMemoryPercent = 0;
static dispatch_queue_t mb_log_queue = nil;
static NSString * const kMBAPMMemoryLogLastLaunchKey = @"kMBAPMMemoryLogLastLaunchKey";
static NSString * const kMBAPMMemoryLogLastLaunchFreeKey = @"kMBAPMMemoryLogLastLaunchFreeKey";

#ifdef DEBUG
static NSString *vc_lifecycle_log = @"";
#endif

@implementation MBMemoryLogModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _runTime = 0;
        _deviceTotalMemory = 0;
        _appMemoryUsage = 0;
        _appMemoryUsagePercent = 0;
        _availableMemory = 0;
        _availableMemoryPercent = 0;
    }
    return self;
}
- (NSDictionary *)jsonMessage {
    if (_peakMemory > 0) {
        return @{@"page_event": self.pageEvent ?: @"",
                 @"app_memory_usage": @(_appMemoryUsage),
                 @"page_peak_memory": @(_peakMemory),
                 @"available_memory": @(_availableMemory)
        };
    }
    return @{@"page_event": self.pageEvent ?: @"",
             @"app_memory_usage": @(_appMemoryUsage),
             @"available_memory": @(_availableMemory)
    };
}

@end

@interface MBMemoryLogListModel ()
//first
@property (nonatomic, strong) MBMemoryLogModel *load;
@property (nonatomic, strong) MBMemoryLogModel *firstDisappear;
//avg
@property (nonatomic, assign) NSUInteger historyCount;
@property (nonatomic, strong) MBMemoryLogModel *currentAppear;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *incrementList;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *peakMemoryList;
@property (nonatomic, strong) NSMutableArray<MBMemoryLogModel *> *history;
//avg
@property (nonatomic, assign) BOOL isClear;


@end

@implementation MBMemoryLogListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        // not init firstDisappear
        _historyCount = 20;
        _currentAppear = [[MBMemoryLogModel alloc] init];
        _incrementList = [[NSMutableArray alloc] init];
        _peakMemoryList = [[NSMutableArray alloc] init];
        _history = [[NSMutableArray alloc] init];
        _isClear = NO;
    }
    return self;
}

// set

- (void)setAvgMemoryTimes:(NSUInteger)times {
    //历史个数
    _historyCount = times * 2 + 2;
}

- (void)appendMemoryLogViewDidLoad:(MBMemoryLogModel *)memory {
    if (_isClear) { return; }
    _load = memory;
}

- (void)appendMemoryLogViewAppear:(MBMemoryLogModel *)memory {
    if (_isClear) { return; }
    _currentAppear = memory;
    [_history addObject:memory];
}

- (void)appendMemoryLogViewDisappear:(MBMemoryLogModel *)memory {
    if (_isClear) { return; }
    [_history addObject:memory];
    if (!_firstDisappear) {
        _firstDisappear = memory;
        
        if (self.firstDisappearMemoryIncrementBlock && _load) {
            self.firstDisappearMemoryIncrementBlock(_firstDisappear.appMemoryUsage - _load.appMemoryUsage, memory.peakMemory - _load.appMemoryUsage, _load, memory);
            _load = nil;
        }
        
    } else {
        [_incrementList addObject:@(memory.appMemoryUsage - _currentAppear.appMemoryUsage)];
        [_peakMemoryList addObject:@(memory.peakMemory - _currentAppear.appMemoryUsage)];
        
        if ([_history count] >= _historyCount && self.avgMemoryIncrementBlock) {
            self.avgMemoryIncrementBlock([self avgDisappearIncrement], [self disappearpeakMemory], [self disappearAvgpeakMemory], [self historyJsonMessage], memory);
            [self clear];
        }
    }
}

- (void)appendMemoryLogViewDealloc:(MBMemoryLogModel *)memory {
    if (_isClear) { return; }
    [_history addObject:memory];
    if (self.avgMemoryIncrementBlock && _incrementList.count > 0) {
        self.avgMemoryIncrementBlock([self avgDisappearIncrement], [self disappearpeakMemory], [self disappearAvgpeakMemory], [self historyJsonMessage], memory);
    }
    [self clear];
}

// 平均值会去掉firstDisappear
- (CGFloat)avgDisappearIncrement {
    __block CGFloat total = 0;
    [_incrementList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        total = total + obj.floatValue;
    }];
    NSUInteger count = [_incrementList count];
    return count == 0 ? 0 : total / count;
}

// 会去掉firstDisappear
- (CGFloat)disappearpeakMemory {
    __block CGFloat max = 0;
    [_peakMemoryList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        max = MAX(max, obj.floatValue);
    }];
    return max;
}

// 平均值会去掉firstDisappear
- (CGFloat)disappearAvgpeakMemory {
    __block CGFloat total = 0;
    [_peakMemoryList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        total = total + obj.floatValue;
    }];
    NSUInteger count = [_incrementList count];
    return count == 0 ? 0 : total / count;
}

//
- (NSArray *)historyJsonMessage {
    NSMutableArray *allHistory = [[NSMutableArray alloc] init];
    [_history enumerateObjectsUsingBlock:^(MBMemoryLogModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [allHistory addObject:obj.jsonMessage];
    }];
    return allHistory;
}

// private
- (void)clear {
    _history = nil;
    _load = nil;
    _firstDisappear = nil;
    _currentAppear = nil;
    _incrementList = nil;
    _isClear = YES;
    _firstDisappearMemoryIncrementBlock = nil;
    _avgMemoryIncrementBlock = nil;
}

@end

@interface MBMemoryLogDetector ()

// callback
@property (nonatomic, copy) MemoryLogCallback runTimeCallBack;
@property (nonatomic, copy) MemonryIncrement firstDisappearCallBack;
@property (nonatomic, copy) MemonryAvgIncrement avgCallBack;
@property (nonatomic, copy) MemoryLogCallback percentCallBack;

@property (nonatomic, assign) NSInteger currentRunTime;
@property (nonatomic, strong) NSMutableArray<NSString *> *allNeedReportTimeIntervals;
@property (nonatomic, strong) NSSet<NSNumber *> *reportTimeNumberIntervals;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *pageMemoryCache;
@property (nonatomic, strong) NSMutableSet<NSString *> *logedPageAvgViewMemorys;
@property (nonatomic, strong) NSMutableSet<NSString *> *loadedPages;
@property (nonatomic, assign) NSInteger logTimeIntervals;
@property (nonatomic, assign) CGFloat memoryPercent;
@end

@implementation MBMemoryLogDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeInterval = 60;
        _currentRunTime = 0;
        _avgTotalTimes = 10;
        _pageMemoryCache = [[NSMutableDictionary alloc] init];
        _logedPageAvgViewMemorys = [[NSMutableSet alloc] init];
        _loadedPages = [[NSMutableSet alloc] init];
        mb_log_queue = dispatch_queue_create("com.mb.memory.log", DISPATCH_QUEUE_SERIAL);
        _logTimeIntervals = 30;
        _memoryPercent = 0;
    }
    return self;
}

#pragma mark - Public Method
- (void)startMemoryLogDetectorWithCallBack:(MemoryLogCallback)callback {
    [self loopForLogMemory];
    self.runTimeCallBack = callback;
}
- (void)startFirstDisappearMemoryLogDetectorWithCallBack:(MemonryIncrement)callback {
    self.firstDisappearCallBack = callback;
}
- (void)startMemonryAvgIncrementDetectorWithCallBack:(MemonryAvgIncrement)callback {
    self.avgCallBack = callback;
}

- (void)begainRefreshMemoryLogWithCallBack:(MemoryLogCallback)callback {
    self.percentCallBack = callback;
    [self begainRefreshMemoryLog];
}

- (void)stopMemoryLogDetector {
    [_allNeedReportTimeIntervals removeAllObjects];
    _timeIntervals = nil;
}

- (void)setTimeIntervals:(NSString *)timeIntervals {
    if (_timeIntervals) {
        return;
    }
    _timeIntervals = timeIntervals;
    NSArray<NSString *> *arr = [timeIntervals componentsSeparatedByString:@","];
    _allNeedReportTimeIntervals = [[NSMutableArray alloc] initWithArray:arr];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (NSString *str in arr) {
        [set addObject:@([str integerValue])];
    }
    _reportTimeNumberIntervals = set;
}

+ (MBMemoryLogModel *)lastMemoryLog {
    __block MBMemoryLogModel *model = nil;
    dispatch_sync(mb_log_queue, ^{
        model = mb_lastMemoryLog;
    });
    return model;
}

- (void)didPageLoad:(MBAPMViewPageContext *)pageContext {
    dispatch_async(mb_log_queue, ^{
        [self cachePageAndBindCallBack:pageContext];
    });
}

- (void)cachePageAndBindCallBack:(MBAPMViewPageContext *)pageContext {
    if (!pageContext.objcetPointer) { return; }
    if ([_loadedPages containsObject:pageContext.objcetPointer]) {
        return;
    }
    [_loadedPages addObject:pageContext.objcetPointer];
    
    if ([[_pageMemoryCache allKeys] containsObject:pageContext.objcetPointer]) {
        return;
    }
    // 没有上报过
    MBMemoryLogListModel * listModel = [[MBMemoryLogListModel alloc] init];
    [listModel setAvgMemoryTimes:_avgTotalTimes];;
   
    MBMemoryLogModel * model = [self newMemoryModelWithCurrentMemory];
    model.objcetPointer = pageContext.objcetPointer;
    model.pageEvent = @"page_load";
    [self setStaticMBLastMemoryLog:model];
    [self setStaticMBLastFreeMemoryLog:model];
#ifdef DEBUG
    static NSString *vc_lifecycle_log = @"";
    vc_lifecycle_log = [NSString stringWithFormat:@"%@\n page_load:%@(%@)(%@)(%@)", vc_lifecycle_log, pageContext.objcetPointer, pageContext.className, pageContext.pageName, [NSDate date]];
    NSAssert(_pageMemoryCache.count < 50, @"有超过50个页面缓存数据，请检查", vc_lifecycle_log);
#endif
    
    [listModel appendMemoryLogViewDidLoad:model];
    _pageMemoryCache[pageContext.objcetPointer] = listModel;
    
    // 处理block
    __weak typeof(self) weakSelf = self;
    [listModel setFirstDisappearMemoryIncrementBlock:^(CGFloat increment, CGFloat peakMemory, MBMemoryLogModel * _Nonnull loadMemory, MBMemoryLogModel * _Nonnull current) {
        if (weakSelf.firstDisappearCallBack) {
            weakSelf.firstDisappearCallBack(increment, peakMemory, loadMemory, current);
        }
    }];
    
    [listModel setAvgMemoryIncrementBlock:^(CGFloat increment, CGFloat peakMemory, CGFloat avgpeakMemory, NSArray * _Nonnull memorys, MBMemoryLogModel * _Nonnull current) {
        if (weakSelf.avgCallBack) {
            weakSelf.avgCallBack(increment, peakMemory, avgpeakMemory, memorys, current);
            [weakSelf.logedPageAvgViewMemorys addObject:current.objcetPointer];
            weakSelf.pageMemoryCache[current.objcetPointer] = nil;
        }
    }];
}

- (void)didPageIn:(MBAPMViewPageContext *)pageContext {
    dispatch_async(mb_log_queue, ^{
        [self cachePageIn:pageContext];
    });
}

- (void)cachePageIn:(MBAPMViewPageContext *)pageContext {
    if (!pageContext.objcetPointer) { return; }
    if ([self.logedPageAvgViewMemorys containsObject:pageContext.objcetPointer]) {
        return;
    }
    if (![[_pageMemoryCache allKeys] containsObject:pageContext.objcetPointer]) {
        return;
    }
    MBMemoryLogListModel * listModel = _pageMemoryCache[pageContext.objcetPointer];
    
    MBMemoryLogModel * model = [self newMemoryModelWithCurrentMemory];
    model.objcetPointer = pageContext.objcetPointer;
    model.pageEvent = @"page_in";
    [self setStaticMBLastMemoryLog:model];
#ifdef DEBUG
static NSString *vc_lifecycle_log = @"";
    vc_lifecycle_log = [NSString stringWithFormat:@"%@\n page_in:%@(%@)(%@)", vc_lifecycle_log, pageContext.objcetPointer, pageContext.className, pageContext.pageName];
#endif
    
    [listModel appendMemoryLogViewAppear:model];
}

- (void)didPageOut:(MBAPMViewPageContext *)pageContext {
    dispatch_async(mb_log_queue, ^{
        [self cachePageOut:pageContext];
    });
}

- (void)cachePageOut:(MBAPMViewPageContext *)pageContext {
    if (!pageContext.objcetPointer) { return; }
    if ([self.logedPageAvgViewMemorys containsObject:pageContext.objcetPointer]) {
        return;
    }
    if (![[_pageMemoryCache allKeys] containsObject:pageContext.objcetPointer]) {
        return;
    }
    MBMemoryLogListModel * listModel = _pageMemoryCache[pageContext.objcetPointer];
    listModel.pageName = pageContext.pageName;
    // 存入 listModel.pageName;
    
    MBMemoryLogModel * model = [self newMemoryModelWithCurrentMemory];
    model.objcetPointer = pageContext.objcetPointer;
    model.pageName = pageContext.pageName;
    model.pageEvent = @"page_out";
    model.peakMemory = [[MBAPMSystemDataGather sharedIntance] popLastPeakMemoryUse];
    [self setStaticMBLastMemoryLog:model];
#ifdef DEBUG
static NSString *vc_lifecycle_log = @"";
    vc_lifecycle_log = [NSString stringWithFormat:@"%@\n page_out:%@(%@)(%@)", vc_lifecycle_log, pageContext.objcetPointer, pageContext.className, pageContext.pageName];
#endif
    
    [listModel appendMemoryLogViewDisappear:model];
}

- (void)didPageDealloc:(MBAPMViewPageContext *)pageContext {
    dispatch_async(mb_log_queue, ^{
        [self cachePageDealloc:pageContext];
    });
}

- (void)cachePageDealloc:(MBAPMViewPageContext *)pageContext {
    if (!pageContext.objcetPointer) { return; }
    if ([self.logedPageAvgViewMemorys containsObject:pageContext.objcetPointer]) {
        return;
    }
    if (![[_pageMemoryCache allKeys] containsObject:pageContext.objcetPointer]) {
        return;
    }
    // 取出 listModel.pageName;
    MBMemoryLogListModel * listModel = _pageMemoryCache[pageContext.objcetPointer];
    
    MBMemoryLogModel * model = [self newMemoryModelWithCurrentMemory];
    model.pageName = listModel.pageName;
    model.objcetPointer = pageContext.objcetPointer;
    model.pageEvent = @"page_deinit";
    [self setStaticMBLastMemoryLog:model];
#ifdef DEBUG
static NSString *vc_lifecycle_log = @"";
    vc_lifecycle_log = [NSString stringWithFormat:@"%@\n page_dealloc:%@(%@)(%@)", vc_lifecycle_log, pageContext.objcetPointer, pageContext.className, pageContext.pageName];
#endif
    
    [listModel appendMemoryLogViewDealloc:model];
    _pageMemoryCache[pageContext.objcetPointer] = nil;
}


#pragma mark - Private Method

- (void)loopForLogMemory {
    if ([_allNeedReportTimeIntervals count] > 0) {
        NSInteger newV = [[_allNeedReportTimeIntervals firstObject] integerValue];
        NSInteger gap = newV - _currentRunTime;
        _currentRunTime = newV;
        if (gap <= 0) {
            gap = 1;
        }
        [_allNeedReportTimeIntervals removeObjectAtIndex:0];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(gap * _timeInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf logMemory:newV];
            [weakSelf loopForLogMemory];
            [weakSelf updateAppRunTime];
        });
    } else {
        _timeIntervals = nil;
    }
}

- (void)logMemory:(NSInteger)runTime {
    MBMemoryLogModel * model = [self newMemoryModelWithCurrentMemory];
    model.runTime = runTime;
    dispatch_async(mb_log_queue, ^{
        [self setStaticMBLastMemoryLog:model];
    });
    if (self.runTimeCallBack) {
        self.runTimeCallBack(model);
    }
}

// 循环记录log的发起
- (void)begainRefreshMemoryLog {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self updateAppRunTime];
            [self loopRefreshMemoryLog];
        });
    });
}

- (MBMemoryLogModel *)newMemoryModelWithCurrentMemory {
    MBMemoryLogModel *model = [[MBMemoryLogModel alloc] init];
    model.deviceTotalMemory = [MBAPMMemoryUtil totalMemoryForDevice];
    model.appMemoryUsage = [MBAPMMemoryUtil appMemoryUsage];
    model.appMemoryUsagePercent = model.appMemoryUsage / model.deviceTotalMemory;
    model.availableMemory = [MBAPMMemoryUtil availableMemory];
    model.availableMemoryPercent = model.availableMemory / model.deviceTotalMemory;
    return model;
}

- (void)loopRefreshMemoryLog {
    MBMemoryLogModel * model = [self newMemoryModelWithCurrentMemory];
    NSInteger minV = [[MBAPMAppStateUtil shared] appRunTime] / 60 / 1000;
    if (!_reportTimeNumberIntervals) {
        return;
    }
    if ([_reportTimeNumberIntervals containsObject:@(minV+1)]) {
        model.runTime = minV+1;
    }
    dispatch_async(mb_log_queue, ^{
        [self setStaticMBLastMemoryLog:model];
    });
    NSDictionary *memoryInfo = @{@"device_total_memory": @(model.deviceTotalMemory),
                     @"available_memory": @(model.availableMemory),
                     @"available_memory_percent": @(model.availableMemoryPercent * 100),
                     @"app_memory_usage": @(model.appMemoryUsage),
                     @"app_memory_usage_percent": @(model.appMemoryUsagePercent * 100)
    };
    MBAPMLogInfo(@"memory log: %@", memoryInfo);
    
    // 实际测试发现oom发生时候占用内存基本很小，修改为每1%打一次行为日志log；修改为初始每8秒检测一次，线性递增，使用到40%后每1秒检测一次。
    if (model.appMemoryUsagePercent - _memoryPercent > 0.01) {
        _memoryPercent = model.appMemoryUsagePercent;
        // 假设内存使用 40% oom，那么此时和以后每秒记录一次log
        NSInteger logtime1 = MAX((0.4-_memoryPercent) * 20, 1);
        _logTimeIntervals = logtime1;
        if (self.percentCallBack) { self.percentCallBack(model); }
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_logTimeIntervals * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf updateAppRunTime];
        [weakSelf loopRefreshMemoryLog];
    });
}

- (void)updateAppRunTime {
    // 更新app运行时间
    [[MBAPMAppStateUtil shared] updateAppAliveInfo];
}

- (void)setStaticMBLastMemoryLog:(MBMemoryLogModel *)model {
    mb_lastMemoryLog = model;
    if (mb_lastLaunchAppMemoryUsagePercent == 0) {
        CGFloat vaule = [[MMKV defaultMMKV] getFloatForKey:kMBAPMMemoryLogLastLaunchKey];
        mb_lastLaunchAppMemoryUsagePercent = vaule;
    }
    [[MMKV defaultMMKV] setFloat:model.appMemoryUsagePercent forKey:kMBAPMMemoryLogLastLaunchKey];
}

+ (CGFloat)appLaunchMBLastMemoryPercent {
    return mb_lastLaunchAppMemoryUsagePercent;
}

- (void)setStaticMBLastFreeMemoryLog:(MBMemoryLogModel *)model {
    mb_lastMemoryLog = model;
    if (mb_lastLaunchAppFreeMemoryPercent == 0) {
        CGFloat vaule = [[MMKV defaultMMKV] getFloatForKey:kMBAPMMemoryLogLastLaunchFreeKey];
        mb_lastLaunchAppFreeMemoryPercent = vaule;
    }
    [[MMKV defaultMMKV] setFloat:model.availableMemoryPercent forKey:kMBAPMMemoryLogLastLaunchFreeKey];
}

+ (CGFloat)appLaunchMBLastFreeMemoryPercent {
    return mb_lastLaunchAppFreeMemoryPercent;
}

@end
