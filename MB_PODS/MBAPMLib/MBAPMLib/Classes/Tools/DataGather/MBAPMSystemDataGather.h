//
//  MBAPMSystemDataGather.h
//  MBAPMLib
//
//  Created by xp on 2020/8/12.
//

#import <Foundation/Foundation.h>
#import "MBAPMSystemDataCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMSystemDataGather : NSObject

@property (nonatomic, assign) uint64_t dataGatherfrequency;

@property (nonatomic, assign) uint64_t dataGatherCacheItemCount;

+ (instancetype)sharedIntance;

- (void)startDataGather;

- (void)startDataGather:(UInt64)dataGatherfrequency;

- (void)stopDataGather;

- (void)startPageDataGather:(NSString *)pageName;

- (void)stopPageDataGather:(NSString *)pageName;

- (NSArray *)getLatestAppMemoryUsageForDuration:(NSInteger)duration;
- (NSArray *)getLatestTotalMemoryUsageForDuration:(NSInteger)duration;
- (NSArray *)getLatestAvailableMemoryUsageForDuration:(NSInteger)duration;

- (NSArray *)getLatestAppCPUUsageForDuration:(NSInteger)duration;
- (NSArray *)getLatestTotalCPUUsageForDuration:(NSInteger)duration;

- (MBAPMSystemDataCache *)getCacheClient;

/// 最近的峰值，取完之后会清空
- (CGFloat)popLastPeakMemoryUse;
@end

NS_ASSUME_NONNULL_END
