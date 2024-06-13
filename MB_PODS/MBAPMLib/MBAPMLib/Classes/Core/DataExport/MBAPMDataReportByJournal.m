//
//  MBAPMDataReportByJournal.m
//  MBAPMLib
//
//  Created by xp on 2020/10/21.
//

#import "MBAPMDataReportByJournal.h"
#import "MBAPMPageRenderMetric.h"
#import "MBAPMAppLaunchMetric.h"
#import "MBAPMLogDef.h"
@import MBFoundation;
@import YMMModuleLib;
@import MBDoctorService;

@implementation MBAPMDataReportByJournal

- (void)exportMetricData:(MBAPMMetric *)metric {
    if(metric.performanceType == MBAPMPerformanceTypePageRender) {
        [self exportPageRenderMetricData:(MBAPMPageRenderMetric *)metric];
    } else if (metric.performanceType == MBAPMPerformanceTypeAppLaunch) {
        [self transferAppLaunchMetric:(MBAPMAppLaunchMetric *)metric];
    }
}

- (void)exportPageRenderMetricData:(MBAPMPageRenderMetric *)metric {
    if(metric.detectType == MBAPMViewPageRenderDetectTypeManaul) {
        NSMutableDictionary *extraData = [NSMutableDictionary dictionaryWithDictionary:metric.extraData];
        [extraData addEntriesFromDictionary:metric.timeSections];
        [extraData setObject:@(metric.metricValue) forKey:@"cost_times"];
         [MBDoctorUtil techWithModel:@"page_render_time" scenario:metric.pageName extraDic:extraData];
    }
}

- (void)transferAppLaunchMetric:(MBAPMAppLaunchMetric *)metric {
    NSAssert(![NSString mb_isNilOrEmpty:metric.metricName],@"metricName can't be nil or empty");
    if([NSString mb_isNilOrEmpty:metric.metricName]) {
        return;
    }
    if (metric.launchType == MBAPMAppLaunchTypeCold) {
        if (!metric.isLaunchTimeOut) {
            if (metric.timeSections) {
                NSNumber *t1 = [metric.timeSections objectForKey:@"t1"];
                NSNumber *t2 = [metric.timeSections objectForKey:@"t2"];
                NSNumber *t3 = [metric.timeSections objectForKey:@"t3"];
                NSNumber *t4 = [metric.timeSections objectForKey:@"t4"];
                [MBDoctorUtil techWithModel:@"launch" scenario:@"main" extraDic:@{@"time1":t1?:@(0),
                                                                                  @"time2":t2?:@(0)
                }];
                [MBDoctorUtil techWithModel:@"launch" scenario:@"MainView" extraDic:@{@"time1":t1?:@(0),
                                                                                      @"time2":t2?:@(0),
                                                                                      @"time3":t3?:@(0),
                                                                                      @"time4":t4?:@(0)
                }];
            }
        } else {
            [MBDoctorUtil techWithModel:@"appLaunch" scenario:@"finishLaunch" extraDic:nil];
        }
    }
}





@end
