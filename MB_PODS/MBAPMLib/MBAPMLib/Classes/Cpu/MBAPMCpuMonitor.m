//
//  MBAPMCpuMonitor.m
//  MBAPMLib
//
//  Created by FDW on 2022/5/24.
//

#import "MBAPMCpuMonitor.h"
#import "MBAPMCPUUtil.h"
#import "MBCpuDataGatherManager.h"
#import "MBAPMMetric.h"
#import "MBAPMCPUMetric.h"
#import "MBAPMAppStateUtil.h"
#import "MBAPMUUIDUtil.h"
#import "MBDeviceInfo.h"
#import "MBAPMCurrentPageInfo.h"

@import MBLogLib;
@import YYModel;
@import MBConfigCenterService;

@interface MBAPMCpuMonitor ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *exceptionTimer;
@property (nonatomic, strong) NSTimer *delayTimer;

@property (nonatomic, strong) dispatch_queue_t cpuMonitorQueue;

@property (nonatomic, strong) NSOperationQueue *cpuExceptionOperationQueue;

@property (nonatomic, assign) BOOL isForeground;
// 正常采集计数
@property (nonatomic, assign) NSInteger cur_cpu_gather_count;
// 异常异常计数
@property (nonatomic, assign) NSInteger cur_cpu_exception_gather_count;

@property (nonatomic, assign, readwrite) BOOL isExceptionGather;

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) dispatch_semaphore_t gatherSemaphore;

@end
@implementation MBAPMCpuMonitor

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackGround)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        _gatherSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)dealloc {
    [self invalidateTimer];
    [self invalidateExceptionTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification
- (void)appBecomeActive {
    if ([MBAPMAppStateUtil shared].appRunTime <= 5 * 1000) {
        MBModuleDebug("MBAPMLib", @"cpu采样-正常-前台少于预置时间,暂不开启");
        return;
    }
    [self resetData];
    
}

- (void)appDidEnterBackGround {
    if ([MBAPMAppStateUtil shared].appRunTime <= 5 * 1000) {
        MBModuleDebug("MBAPMLib", @"cpu采样-正常-后台少于预置时间,暂不开启");
        return;
    }
    [self resetData];
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagCpu;
}

- (void)start {
    [super start];
    [self startMonitor];
}
- (void)startMonitor {
    if (![MBDeviceInfo canEnableMonitor]) {
        return;
    }
    if (!self.cpuConfig.isEnable) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"是否是前台:%d", self.isForeground];
    MBModuleDebug("MBAPMLib", msg);
    
    dispatch_async(self.cpuMonitorQueue, ^{
        [self invalidateTimer];
        self->_timer = [NSTimer scheduledTimerWithTimeInterval:self.cpuConfig.gather_interval target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self->_timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)startExceptionMonitor {
    if ([MBAPMAppStateUtil shared].appRunTime <= 10 * 1000) {
        MBModuleDebug("MBAPMLib", @"cpu采样-异常-少于预置时间,暂不开启");
        return;
    }
    // 异常收集定时器未开启
    if (![self getIsExceptionGather]) {
        MBModuleDebug("MBAPMLib", @"cpu采样-异常-已经在采样中");
        return;
    }
    [self updateIsExceptionGathervalue:YES];
    [self.cpuExceptionOperationQueue addOperationWithBlock:^{
        [self startExceptionQueueAction:nil];
    }];
}

- (void)startExceptionQueueAction:(NSInvocationOperation *)op {
    // 开始异常收集
    [self invalidateExceptionTimer];
    self->_exceptionTimer = [NSTimer scheduledTimerWithTimeInterval:self.cpuConfig.exception_gather_interval target:self selector:@selector(exceptionTimerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self->_exceptionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (void)timerAction:(NSTimer *)timer {
    _cur_cpu_gather_count++;
    if (_cur_cpu_gather_count % self.cpuConfig.gather_count == 0) {
        // 一个记录周期,需要计算出平均值,进行上报
        [self reportNormarMetric];
        // 上报完成之后清除数据
        [[MBCpuDataGatherManager sharedInstance] clearCpuUsageRecord];
        [[MBCpuDataGatherManager sharedInstance] clearCpuRateRecord];
    }
    CGFloat cpuUsage = [MBAPMCPUUtil appCpuUsageWithMonitorWithNormal:YES monitor:self];
    NSString *msg = [NSString stringWithFormat:@"cpu采样-正常:%f", cpuUsage];
    MBModuleDebug("MBAPMLib", msg);
}

- (void)exceptionTimerAction:(NSTimer *)timer {
    // 异常采样
    CGFloat cpuUsage = [MBAPMCPUUtil appCpuUsageWithMonitorWithNormal:NO monitor:self];
    [[MBCpuDataGatherManager sharedInstance] addCpuExceptionUsageRecord:cpuUsage];
    NSString *msg = [NSString stringWithFormat:@"cpu采样-异常-采样中:%f", cpuUsage];
    MBModuleDebug("MBAPMLib", msg);
    
    _cur_cpu_exception_gather_count++;
    if (_cur_cpu_exception_gather_count % self.cpuConfig.exception_gather_count == 0) {
        // 一个记录周期,需要计算出平均值,进行上报
        [self reportExceptionMetric];
        
        MBModuleDebug("MBAPMLib", @"cpu采样-异常-定时器关闭");
        // 停止异常采集定时器
        [self invalidateExceptionTimer];
        _cur_cpu_exception_gather_count = 0;
                
        // 重置数据
        [[MBCpuDataGatherManager sharedInstance] clearExceptionModelsRecord];
        [[MBCpuDataGatherManager sharedInstance] clearCpuExceptionUsageRecord];
        
        // 延迟重置异常收集标志
        [self startDelayTimer];
    }
}

- (void)delayTimerAction:(NSTimer *)timer {
    [self updateIsExceptionGathervalue:NO];
    [self invalidateDelayTimer];
    MBModuleDebug("MBAPMLib", @"cpu采样-异常-重置标志");
}

- (void)startDelayTimer {
    [self invalidateDelayTimer];
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayTimerAction:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.delayTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        
        MBModuleDebug("MBAPMLib", @"cpu采样-正常-定时器关闭");
    }
}
- (void)invalidateExceptionTimer {
    if (_exceptionTimer) {
        [_exceptionTimer invalidate];
        _exceptionTimer = nil;
    }
}
- (void)invalidateDelayTimer {
    if (_delayTimer) {
        [_delayTimer invalidate];
        _delayTimer = nil;
    }
}
#pragma mark - metric

- (void)reportNormarMetric {
    MBAPMCPUMetric *metric = [[MBAPMCPUMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeCPU;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = [[MBCpuDataGatherManager sharedInstance] getAverageCPUUsage];
    metric.metricName = @"performance.cpu_usage";
    NSString *bundleName = @"";
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    bundleName = bundleInfo[@"CFBundleName"];
    
    metric.tags = @{
        @"app_foreground": self.isForeground ? @(1) : @(0),
        @"process_name": bundleName ?: @"",
    };
    metric.sections = @{
        @"cpu_rate": @([[MBCpuDataGatherManager sharedInstance] getAverageRate])
    };
    [self reportMetrics:metric];
    MBModuleDebug("MBAPMLib", @"cpu采样-正常-上报数据");
    
}

- (void)reportExceptionMetric {
    
    // 计算数据
    NSArray *array = [[MBCpuDataGatherManager sharedInstance] getExceptionModels].copy;
    NSMutableArray *cpuUsageArray = @[].mutableCopy;
    NSMutableArray *cpuTimeArray = @[].mutableCopy;
    NSMutableDictionary *dic = @{}.mutableCopy;
    CGFloat totCpuUsage = [[MBCpuDataGatherManager sharedInstance] getSumCPUExceptionUsage];
    for (MBThreadStackModel *model in array) {
        [cpuUsageArray addObject:@(model.cpu_usage)];
        [cpuTimeArray addObject:@(model.cpu_rate)];
        
        if ([dic.allKeys containsObject:model.number]) {
            NSMutableArray *arr = dic[model.number];
            [arr addObject:model];
        } else {
            dic[model.number] = @[model].mutableCopy;
        }
        totCpuUsage += model.cpu_usage;
        
    }
    // 平均使用率
    CGFloat aveCpuUsage = [[MBCpuDataGatherManager sharedInstance] getAverageCPUExceptionUsage];
    // 大于 80 才进行数据上报
    if (aveCpuUsage <= self.cpuConfig.total_gather_threshold) {
        MBModuleDebug("MBAPMLib", @"cpu采样-异常-不满足上报条件,丢弃");
        [[MBCpuDataGatherManager sharedInstance] clearCpuExceptionUsageRecord];
        [[MBCpuDataGatherManager sharedInstance] clearExceptionModelsRecord];
        return;
    }
    // 平均使用速率
    CGFloat aveCpuTime = [[cpuTimeArray valueForKeyPath:@"@avg.floatValue"] floatValue];
    
    NSString *bundleName = @"";
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    bundleName = bundleInfo[@"CFBundleName"];
    
    // tags 中字段
    NSString *thread_name = @"";
    NSString *temp_thread_name = @""; // tags 若无，传“unknown”
    // atts 中字段
    NSString *thread = @"";
    NSString *error_feature = @"";
    NSMutableArray *cpuInfos = @[].mutableCopy;
    
    NSInteger maxPrivateStackCount = 0;
    
    for (NSString *stackNum in dic.allKeys) {
        // staks
        NSMutableArray *stacks = @[].mutableCopy;
        
        NSMutableArray *stackstemp = @[].mutableCopy;
        NSArray *stackArray = dic[stackNum];
        NSInteger maxCount = 0;
        NSMutableDictionary *cpuInfo = @{}.mutableCopy;
        NSArray *cpuUsageArray = [stackArray valueForKeyPath:@"cpu_usage"];
        NSArray *cpuTimeArray = [stackArray valueForKeyPath:@"cpu_rate"];
        CGFloat aveCpuUsage = [[cpuUsageArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        CGFloat aveCpuTime = [[cpuTimeArray valueForKeyPath:@"@avg.floatValue"] floatValue];
        CGFloat curTotCpuUsage = 0.0;
                        
        for (int i = 0; i < stackArray.count; i++) {
            MBThreadStackModel *model = stackArray[i];
            curTotCpuUsage += model.cpu_usage;
            // 把所以堆栈行放入数组
            [stackstemp addObjectsFromArray:model.stackPerModelArray];
            if (model.stackPerModelArray.count > maxCount) {
                maxCount = model.stackPerModelArray.count;
            }
            
            if (model.name.length) {
                temp_thread_name = model.name;
                thread = [NSString stringWithFormat:@"%@_%@", model.name, stackNum];
            }
            if (!temp_thread_name.length) {
                temp_thread_name = @"unknown";
                thread = [NSString stringWithFormat:@"unknown_%@", stackNum];
            }
        }
        
        /// 组装堆栈树
        MBThreadStackPerModel *togStack = nil;
        {
            NSMutableArray <MBThreadStackPerModel *> *lastArray = @[].mutableCopy;
            for (int i = 0 ; i < maxCount; i++) {
                NSMutableArray <MBThreadStackPerModel *> *lastArrayTemp = @[].mutableCopy;
                
                for (MBThreadStackPerModel *perStack in stackstemp.copy) {
                    
                    if (i == 0) {
                        if (perStack.superNode == nil && perStack.level == 1) {
                            if (togStack) {
                                togStack.weight++;
                            } else {
                                togStack = perStack;
                                togStack.weight = 1;
                            }
                        }
                        lastArrayTemp = @[togStack].mutableCopy;
                    } else {
                        for (MBThreadStackPerModel *lStack in lastArray.copy) {
                            if (perStack.superNode.getCurAddress == lStack.getCurAddress && perStack.level == i + 1) {
                                
                                BOOL isContaion = NO;
                                for (MBThreadStackPerModel *sStack in lStack.child) {
                                    if (sStack.getCurAddress == perStack.getCurAddress) {
                                        isContaion = YES;
                                        break;
                                    }
                                }
                                
                                if (isContaion) {
                                    for (MBThreadStackPerModel *sStack in lStack.child) {
                                        if (sStack.getCurAddress == perStack.getCurAddress) {
                                            sStack.weight += 1;
                                            if ([sStack.getCurFname containsString:bundleName]) {
                                                if (sStack.weight > maxPrivateStackCount) {
                                                    maxPrivateStackCount = sStack.weight;
                                                    error_feature = [NSString stringWithFormat:@"%@ + %ld", bundleName, sStack.getOffset];
                                                    thread_name = temp_thread_name;
                                                }
                                            }
                                            break;
                                        }
                                    }
                                    
                                } else {
                                    // 解决 json 化异常
                                    perStack.superNode = nil;
                                    NSMutableArray *childArray = [NSMutableArray arrayWithArray:lStack.child];
                                    perStack.weight = 1;
                                    [childArray addObject:perStack];
                                    lStack.child = childArray;
                                    lastArrayTemp = lStack.child;
                                }
                                
                            }
                        }
                        
                    }
                }
                lastArray = lastArrayTemp;
            }
        }
        
        if (togStack) {
            [stacks addObject:[togStack yy_modelToJSONObject]];
        }
    
        // 权重
        CGFloat weight = curTotCpuUsage / totCpuUsage * 100.0;

        cpuInfo[@"thread"] = thread;
        cpuInfo[@"cpu_usage"] = @(aveCpuUsage);
        cpuInfo[@"cpu_rate"] = @(aveCpuTime);
        cpuInfo[@"count"] = @(stackArray.count);
        cpuInfo[@"weight"] = @(weight);
        cpuInfo[@"stack"] = stacks;
        
        if (stacks.count) {
            [cpuInfos addObject:cpuInfo];
        }
    }
    
    NSString *stack = [self jsonStringCompactFormatForNSArray:cpuInfos];
    
    // 上报
    MBAPMCPUMetric *metric = [[MBAPMCPUMetric alloc] init];
    metric.performanceType = MBAPMPerformanceTypeCPU;
    metric.metricType = MBAPMMetricTypeGauge;
    metric.metricValue = aveCpuUsage;
    metric.metricName = @"performance.cpu_exception";
    metric.tags = @{
        @"page_id": [MBAPMCurrentPageInfo currentPageName] ?: @"",
        @"page_className": [MBAPMCurrentPageInfo currentPageClassName] ?: @"",
        @"app_foreground": self.isForeground ? @(1) : @(0),
        @"error_feature": error_feature.length ? error_feature : @"unfound",
        @"thread_name": thread_name.length ? thread_name : @"unknown",
        @"process_name": bundleName ?: @"",
    };
    metric.sections = @{
        @"cpu_rate": @(aveCpuTime)
    };
    metric.atts = @{@"stack": stack,
                    @"stack_type": @"cpu",
                    @"mapping_type": @"dsym",
                    @"bundles": [MBAPMUUIDUtil getUnsystemImageUUIDs],
                    @"use_time": @([MBAPMAppStateUtil shared].appRunTime)
    };
    [self reportMetrics:metric];
    MBModuleDebug("MBAPMLib", @"cpu采样-异常-上报数据");
}
#pragma mark - private methods
- (void)resetData {
    MBModuleDebug("MBAPMLib", @"cpu采样-正常-重置数据");
    _cur_cpu_gather_count = 0;
    
    // 重置采样数据
    [[MBCpuDataGatherManager sharedInstance] clearCpuUsageRecord];
    [[MBCpuDataGatherManager sharedInstance] clearCpuRateRecord];
    
    // 重置异常线程
    [self resetExceptionData];
}

- (void)resetExceptionData {
    MBModuleDebug("MBAPMLib", @"cpu采样-异常-重置数据");
    [self updateIsExceptionGathervalue:NO];
    _cur_cpu_exception_gather_count = 0;
    [self invalidateExceptionTimer];
    
    // 重置采样数据
    [[MBCpuDataGatherManager sharedInstance] clearExceptionModelsRecord];
    [[MBCpuDataGatherManager sharedInstance] clearCpuExceptionUsageRecord];
}

// array -> jsonstring
- (NSString *)jsonStringCompactFormatForNSArray:(NSArray *)arrJson {
    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}

- (BOOL)getIsExceptionGather {
    BOOL isGather = NO;
    dispatch_semaphore_wait(_gatherSemaphore, DISPATCH_TIME_FOREVER);
    isGather = _isExceptionGather;
    dispatch_semaphore_signal(_gatherSemaphore);
    return isGather;
}

- (void)setIsExceptionGatherWith:(BOOL )isGather {
    dispatch_semaphore_wait(_gatherSemaphore, DISPATCH_TIME_FOREVER);
    _isExceptionGather = isGather;
    dispatch_semaphore_signal(_gatherSemaphore);
}

// 回滚措施,过一个版本稳定之后,需要移除
- (void)updateIsExceptionGathervalue:(BOOL )exceptionGather {
    if ([self updateExceptionSwitch]) {
        [self setIsExceptionGatherWith:exceptionGather];
    } else {
        [self setIsExceptionGather:exceptionGather];
    }
}

- (BOOL)updateExceptionSwitch {
    id <MBConfigCenterProtocol> service = BIND_SERVICE(nil, MBConfigCenterProtocol);
    NSInteger exceptionGatherSwitch = [service getIntegerConfig:@"other" key:@"cpu_update_is_exceptionGather" defaultValue:1];
    return exceptionGatherSwitch == 1;
}

#pragma mark - getter and getters

- (BOOL)isForeground {
    return [[MBAPMAppStateUtil shared] applicationState] == UIApplicationStateActive;
}

- (dispatch_queue_t)cpuMonitorQueue {
    if (!_cpuMonitorQueue) {
        _cpuMonitorQueue = dispatch_queue_create("com.mb.cpu.monitor.process", NULL);
    }
    return _cpuMonitorQueue;
}

- (NSOperationQueue *)cpuExceptionOperationQueue {
    if (!_cpuExceptionOperationQueue) {
        _cpuExceptionOperationQueue = [[NSOperationQueue alloc] init];
        _cpuExceptionOperationQueue.maxConcurrentOperationCount = 1; // 串行队列
    }
    return _cpuExceptionOperationQueue;
}

- (NSString *)getCpuExceptionOperationQueueName {
    return self.cpuExceptionOperationQueue.name ?: @"";
}
@end
