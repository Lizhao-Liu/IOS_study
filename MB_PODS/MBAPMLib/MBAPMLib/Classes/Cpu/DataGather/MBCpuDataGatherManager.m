//
//  MBCpuDataGatherManager.m
//  MBAPMLib
//
//  Created by FDW on 2022/5/24.
//

#import "MBCpuDataGatherManager.h"


@interface MBCpuDataGatherManager ()
@property (nonatomic, strong) dispatch_queue_t  cpuCacheQueue;
@property (nonatomic, strong, readwrite) NSMutableArray *cpuUserageArray;
@property (nonatomic, strong, readwrite) NSMutableArray *cpuRateArray;
@property (nonatomic, strong, readwrite) NSMutableArray *exceptionStackArray;
@property (nonatomic, strong, readwrite) NSMutableArray *cpuExceptionUsageArray;

@end
@implementation MBCpuDataGatherManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MBCpuDataGatherManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cpuCacheQueue = dispatch_queue_create("com.cpu.cache.queue", NULL);

    }
    return self;
}

#pragma mark - normal
- (void)addCpuUsageRecord:(CGFloat )usage {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.cpuUsageArray addObject:@(usage)];
    });
}
- (void)addCpuRateRecord:(CGFloat )rate {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.cpuRateArray addObject:@(rate)];
    });
}
- (CGFloat )getAverageCPUUsage {
    __block CGFloat aveValue;
    dispatch_sync(_cpuCacheQueue, ^{
        aveValue = [[self.cpuUsageArray.copy valueForKeyPath:@"@avg.floatValue"] floatValue];
    });
    return aveValue;
}
- (CGFloat )getAverageRate {
    __block CGFloat aveValue;
    dispatch_sync(_cpuCacheQueue, ^{
        aveValue = [[self.cpuRateArray.copy valueForKeyPath:@"@avg.floatValue"] floatValue];
    });
    return aveValue;
}
- (void)clearCpuUsageRecord {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.cpuUsageArray removeAllObjects];
    });
}
- (void)clearCpuRateRecord {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.cpuRateArray removeAllObjects];
    });
}

#pragma mark - exception
- (void)addExceptionModel:(MBThreadStackModel *)model {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.exceptionStackArray addObject:model];
    });
}
- (void)addCpuExceptionUsageRecord:(CGFloat )usage {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.cpuExceptionUsageArray addObject:@(usage)];
    });
}

- (NSArray *)getExceptionModels {
    __block NSArray <__kindof MBThreadStackModel *> *models = @[];
    dispatch_sync(_cpuCacheQueue, ^{
        models = [self->_exceptionStackArray copy];
    });
    return models;
}
- (CGFloat )getAverageCPUExceptionUsage {
    __block CGFloat aveValue;
    dispatch_sync(_cpuCacheQueue, ^{
        aveValue = [[self.cpuExceptionUsageArray.copy valueForKeyPath:@"@avg.floatValue"] floatValue];
    });
    return aveValue;
}
- (CGFloat )getSumCPUExceptionUsage {
    __block CGFloat aveValue;
    dispatch_sync(_cpuCacheQueue, ^{
        aveValue = [[self.cpuExceptionUsageArray.copy valueForKeyPath:@"@sum.floatValue"] floatValue];
    });
    return aveValue;
}
- (void)clearExceptionModelsRecord {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.exceptionStackArray removeAllObjects];
    });
}
- (void)clearCpuExceptionUsageRecord {
    dispatch_sync(_cpuCacheQueue, ^{
        [self.cpuExceptionUsageArray removeAllObjects];
    });
}

#pragma mark - setters and getters

- (NSMutableArray *)cpuUsageArray {
    if (!_cpuUserageArray) {
        _cpuUserageArray = @[].mutableCopy;
    }
    return _cpuUserageArray;
}
- (NSMutableArray *)cpuRateArray {
    if (!_cpuRateArray) {
        _cpuRateArray = @[].mutableCopy;
    }
    return _cpuRateArray;
}
- (NSMutableArray *)exceptionStackArray {
    if (!_exceptionStackArray) {
        _exceptionStackArray = @[].mutableCopy;
    }
    return _exceptionStackArray;
}
- (NSMutableArray *)cpuExceptionUsageArray {
    if (!_cpuExceptionUsageArray) {
        _cpuExceptionUsageArray = @[].mutableCopy;
    }
    return _cpuExceptionUsageArray;
}
@end
