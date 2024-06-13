//
//  MBAPMDataCache.m
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import "MBAPMDataCache.h"
#import "MBAPMPageRenderMetric.h"
#import "MBAPMPageRenderMetricStatistic.h"
#import "MBAPMServiceContext.h"
#import "MBAPMDataExportManager.h"

@import YMMModuleLib;
@import MBStorageLibService;

static NSString * const kMBAPMDataCacheStorageKey_EnableCache = @"kMBAPMDataCacheStorageKey_EnableCache";

@interface MBAPMDataCache()

@end

@implementation MBAPMDataCache

#pragma mark - public method

+ (instancetype)sharedInstance {
    static MBAPMDataCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMDataCache alloc]init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
    id<MBStorageProtocol> storage = BIND_SERVICE(serviceContext , MBStorageProtocol);
    _cacheEnable = [storage getBool:kMBAPMDataCacheStorageKey_EnableCache];
}

- (void)setCacheEnable:(BOOL)cacheEnable {
    _cacheEnable = cacheEnable;
    MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
    id<MBStorageProtocol> storage = BIND_SERVICE(serviceContext , MBStorageProtocol);
    [storage set:@(cacheEnable) forKey:kMBAPMDataCacheStorageKey_EnableCache];
    if(!_cacheEnable) {
        [self.metricCache removeAllObjects];
    }
}

- (NSArray<MBAPMMetric *> *)getCachedMetrics:(MBAPMPerformanceType)type {
    return [self.metricCache objectForKey:@(type)].copy;
}

- (NSArray<MBAPMPageRenderMetric *> *)getCachedPageMetics:(NSString *)pageName {
    if(pageName) {
        NSDictionary<NSString *, NSArray<MBAPMPageRenderMetric *> *> *pageMetricDic = [self getPageMetricDic];
        return [pageMetricDic objectForKey:pageName];
    }
    return nil;
}

- (NSArray<MBAPMPageRenderMetricStatistic *> *)getPageRenderStatistic {
    NSMutableArray<MBAPMPageRenderMetricStatistic *> *pageRenderStatisticArray = [[NSMutableArray alloc]init];
    NSDictionary<NSString *, NSArray<MBAPMPageRenderMetric *> *> *pageMetricDic = [self getPageMetricDic];
    [pageMetricDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<MBAPMPageRenderMetric *> * _Nonnull array, BOOL * _Nonnull stop) {
        MBAPMPageRenderMetricStatistic *statistic = [[MBAPMPageRenderMetricStatistic alloc]init];
        int successCount = 0;
        long long totalTime = 0;
        for(MBAPMPageRenderMetric *pageRenderMetric in array) {
            if(pageRenderMetric.renderResult) {
                successCount++;
            }
            totalTime += pageRenderMetric.metricValue;
        }
        statistic.pageName = key;
        statistic.successRate = array.count != 0 ? successCount / (array.count + 0.0):0;
        statistic.avgTime = array.count != 0 ? totalTime/array.count : 0;
        [pageRenderStatisticArray addObject:statistic];
    }];
    return pageRenderStatisticArray.copy;
}


#pragma mark - private method
- (NSDictionary<NSString *, NSArray<MBAPMPageRenderMetric *> *> *)getPageMetricDic {
    NSArray<MBAPMMetric *> *pageRenderArray = [self.metricCache objectForKey:@(MBAPMPerformanceTypePageRender)];
    NSMutableDictionary<NSString *, NSMutableArray<MBAPMPageRenderMetric *> *> *pageMetricDic = [[NSMutableDictionary alloc]init];
    for(MBAPMMetric *metric in pageRenderArray) {
        MBAPMPageRenderMetric *pageRenderMetric = (MBAPMPageRenderMetric *)metric;
        NSMutableArray *metricArray = [pageMetricDic objectForKey:pageRenderMetric.pageName];
        if(metricArray) {
            [metricArray addObject:metric];
        } else {
            metricArray = [[NSMutableArray alloc]init];
            [metricArray addObject:metric];
            [pageMetricDic setObject:metricArray forKey:pageRenderMetric.pageName];
        }
    }
    return pageMetricDic;
}


#pragma mark - property method

- (NSMutableDictionary *)metricCache {
    if(!_metricCache) {
        _metricCache = [[NSMutableDictionary alloc]init];
    }
    return _metricCache;
}

@end
