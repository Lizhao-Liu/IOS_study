//
//  MBAPMWakeupsContinuousHightExceptionMonitor.h
//  MBAPMLib
//
//  Created by zhaozhao on 2024/3/13.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
#import "MBAPMWakeupsMonitorConfig.h"
#import "MBAPMWakeupsDefine.h"
@import MBDoctorService;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsContinuousHighExceptionMonitor : NSObject

- (instancetype)initWithReportBlock:(MBAPMWakeupsExceptionReportBlock)reportBlock 
                      monitorConfig:(MBAPMWakeupsMonitorConfig *)config;

- (void)didRecordWakeups:(NSInteger)wakeups;

@end

NS_ASSUME_NONNULL_END
