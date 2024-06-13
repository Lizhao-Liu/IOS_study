//
//  MBAPMDataCache+DataExportChannel.m
//  MBAPMLib
//
//  Created by xp on 2021/7/5.
//

#import "MBAPMDataCache+DataExportChannel.h"

@implementation MBAPMDataCache(DataExportChannel)

- (void)exportMetricData:(MBAPMMetric *)metric {
    if(!self.cacheEnable) {
        return;
    }
    if(metric) {
        NSMutableArray *metricArray = [self.metricCache objectForKey:@(metric.performanceType)];
        if(metricArray) {
            [metricArray addObject:metric];
        } else {
            metricArray = [[NSMutableArray alloc]init];
            [metricArray addObject:metric];
            [self.metricCache setObject:metricArray forKey:@(metric.performanceType)];
        }
    }
}

@end
