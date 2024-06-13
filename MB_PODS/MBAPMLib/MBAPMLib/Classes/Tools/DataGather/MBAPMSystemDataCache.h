//
//  MBAPMSystemDataCache.h
//  MBAPMLib
//
//  Created by xp on 2020/8/12.
//

#import <Foundation/Foundation.h>
#import "MBAPMDataCacheQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMSystemDataCache : NSObject

@property (nonatomic, strong) MBAPMDataCacheQueue *appCPUUsageArray;
@property (nonatomic, strong) MBAPMDataCacheQueue *totalCPUUsageArray;
@property (nonatomic, strong) MBAPMDataCacheQueue *appMemoryUsageArray;
@property (nonatomic, strong) MBAPMDataCacheQueue *totalMemoryUsageArray;
@property (nonatomic, strong) MBAPMDataCacheQueue *availableMemoryUsageArray;
@property (nonatomic, strong) MBAPMDataCacheQueue *fpsArray;

- (void)setCacheItemCount:(uint64_t)itemCount;

- (void)addCPUUsageRecord:(CGFloat)appCPUUsage totalCPUUsage:(CGFloat)totalCPUUsage;

- (void)addMemoryUsageRecord:(CGFloat)appMemoryUsage totalMemoeryUsage:(CGFloat)totalMemoryUsage availableMemory:(CGFloat)availableMemory;

- (void)addFPSRecod:(CGFloat)fps;

- (NSDictionary *)getCPUInfo;

- (CGFloat)getAverageCPUUsage;

- (NSDictionary *)getMemoryInfo;

- (void)clearCache;

- (NSArray *)getLatestAppMemoryUsageForCount:(NSInteger)count;
- (NSArray *)getLatestTotalMemoryUsageForCount:(NSInteger)count;
- (NSArray *)getLatestAvailableMemoryUsageForCount:(NSInteger)count;

- (NSArray *)getLatestAppCPUUsageForCount:(NSInteger)count;
- (NSArray *)getLatestTotalCPUUsageForCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
