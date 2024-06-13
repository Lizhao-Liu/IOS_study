//
//  MBAPMSystemDataCache.m
//  MBAPMLib
//
//  Created by xp on 2020/8/12.
//

#import "MBAPMSystemDataCache.h"

static NSString * const kDataKeyAppCpuUsage = @"appCpuUsage";
static NSString * const kDataKeyTotalCpuUsage = @"totalCpuUsage";
static NSString * const kDataKeyAppMemoryUsage = @"appMemoryUsage";
static NSString * const kDataKeyTotalMemoryUsage = @"totalMemoryUsage";
static NSString * const kDataKeyAvailableMemory = @"availableMemory";

@interface MBAPMSystemDataCache() {
    uint64_t _itemCount;
}



@end

@implementation MBAPMSystemDataCache

- (void)setCacheItemCount:(uint64_t)itemCount {
    _itemCount = itemCount;
}

- (void)addCPUUsageRecord:(CGFloat)appCPUUsage totalCPUUsage:(CGFloat)totalCPUUsage {
    [self.appCPUUsageArray enqueue:[self decimalNumber:appCPUUsage withDecimal:3] * 100];
    [self.totalCPUUsageArray enqueue:[self decimalNumber:totalCPUUsage withDecimal:3] * 100];
}

- (void)addMemoryUsageRecord:(CGFloat)appMemoryUsage totalMemoeryUsage:(CGFloat)totalMemoryUsage availableMemory:(CGFloat)availableMemory {
    [self.appMemoryUsageArray enqueue:[self decimalNumber:appMemoryUsage withDecimal:0]];
    [self.totalMemoryUsageArray enqueue:[self decimalNumber:totalMemoryUsage withDecimal:0]];
    [self.availableMemoryUsageArray enqueue:[self decimalNumber:availableMemory withDecimal:0]];
}

- (void)addFPSRecod:(CGFloat)fps {
    [self.fpsArray enqueue:[self decimalNumber:fps withDecimal:0]];
}

- (void)clearCache {
    [self.appCPUUsageArray clear];
    [self.totalCPUUsageArray clear];
    [self.appMemoryUsageArray clear];
    [self.totalMemoryUsageArray clear];
    [self.availableMemoryUsageArray clear];
}

- (NSDictionary *)getCPUInfo {
    NSMutableDictionary *cpuInfo = [NSMutableDictionary new];
    if(self.appCPUUsageArray) {
        [cpuInfo setObject:[self.appCPUUsageArray getAllItems] forKey:kDataKeyAppCpuUsage];
    }
    if(self.totalCPUUsageArray) {
        [cpuInfo setObject:[self.totalCPUUsageArray getAllItems] forKey:kDataKeyTotalCpuUsage];
    }
    return [cpuInfo copy];
}

- (CGFloat)getAverageCPUUsage {
    if(self.appCPUUsageArray) {
        id avgObj = [[self.appCPUUsageArray getAllItems]valueForKeyPath:@"@avg.floatValue"];
        if (avgObj && [avgObj isKindOfClass:[NSNumber class]]) {
            return [avgObj floatValue];
        }
    }
    return 0.f;
}

- (NSDictionary *)getMemoryInfo {
    NSMutableDictionary *memoryInfo = [NSMutableDictionary new];
    if(self.appMemoryUsageArray) {
        [memoryInfo setObject:[self.appMemoryUsageArray getAllItems] forKey:kDataKeyAppMemoryUsage];
    }
    if(self.totalMemoryUsageArray) {
        [memoryInfo setObject:[self.totalMemoryUsageArray getAllItems] forKey:kDataKeyTotalMemoryUsage];
    }
    if(self.availableMemoryUsageArray) {
        [memoryInfo setObject:[self.availableMemoryUsageArray getAllItems] forKey:kDataKeyAvailableMemory];
    }
    return [memoryInfo copy];
}

- (NSArray *)getLatestAppMemoryUsageForCount:(NSInteger)count {
    return [self.appMemoryUsageArray getLatestItemsForCount:count];
}

- (NSArray *)getLatestTotalMemoryUsageForCount:(NSInteger)count {
    return [self.totalMemoryUsageArray getLatestItemsForCount:count];
}

- (NSArray *)getLatestAvailableMemoryUsageForCount:(NSInteger)count {
    return [self.availableMemoryUsageArray getLatestItemsForCount:count];
}

- (NSArray *)getLatestAppCPUUsageForCount:(NSInteger)count {
    return [self.appCPUUsageArray getLatestItemsForCount:count];
}

- (NSArray *)getLatestTotalCPUUsageForCount:(NSInteger)count {
    return [self.totalCPUUsageArray getLatestItemsForCount:count];
}

#pragma mark - Private Method
- (CGFloat)decimalNumber:(CGFloat) originNumber withDecimal:(NSInteger)decimalCount{
    if(decimalCount == 0) {
        return roundf(originNumber);
    }
    CGFloat scaleNum = originNumber * pow(10, decimalCount);
    NSInteger roundNum = round(scaleNum);
    return roundNum*1.0f / pow(10, decimalCount);
}

#pragma mark - Property Method

- (MBAPMDataCacheQueue *)appCPUUsageArray {
    if(!_appCPUUsageArray) {
        _appCPUUsageArray = [MBAPMDataCacheQueue loopQueueWithCapacity:_itemCount];
    }
    return _appCPUUsageArray;
}

- (MBAPMDataCacheQueue *)totalCPUUsageArray {
    if(!_totalCPUUsageArray) {
        _totalCPUUsageArray = [MBAPMDataCacheQueue  loopQueueWithCapacity:_itemCount];
    }
    return _totalCPUUsageArray;
}

- (MBAPMDataCacheQueue *)appMemoryUsageArray {
    if(!_appMemoryUsageArray) {
        _appMemoryUsageArray = [MBAPMDataCacheQueue loopQueueWithCapacity:_itemCount];
    }
    return _appMemoryUsageArray;
}

- (MBAPMDataCacheQueue *)totalMemoryUsageArray {
    if(!_totalMemoryUsageArray) {
        _totalMemoryUsageArray = [MBAPMDataCacheQueue loopQueueWithCapacity:_itemCount];
    }
    return _totalMemoryUsageArray;
}

- (MBAPMDataCacheQueue *)availableMemoryUsageArray {
    if(!_availableMemoryUsageArray) {
        _availableMemoryUsageArray = [MBAPMDataCacheQueue loopQueueWithCapacity:_itemCount];
    }
    return _availableMemoryUsageArray;
}

- (MBAPMDataCacheQueue *)fpsArray {
    if(!_fpsArray) {
        _fpsArray = [MBAPMDataCacheQueue loopQueueWithCapacity:_itemCount];
    }
    return _fpsArray;
}


@end
