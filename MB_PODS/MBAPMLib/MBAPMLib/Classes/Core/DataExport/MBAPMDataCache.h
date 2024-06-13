//
//  MBAPMDataCache.h
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
#import "MBAPMPageRenderMetric.h"
#import "MBAPMPageRenderMetricStatistic.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDataCache : NSObject

@property (nonatomic, assign) BOOL cacheEnable;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<MBAPMMetric *> *> *metricCache;

+ (instancetype)sharedInstance;

- (NSArray<MBAPMMetric *> *)getCachedMetrics:(MBAPMPerformanceType)type;

- (NSArray<MBAPMPageRenderMetric *> *)getCachedPageMetics:(NSString *)pageName;

- (NSArray<MBAPMPageRenderMetricStatistic *> *)getPageRenderStatistic;

@end

NS_ASSUME_NONNULL_END
