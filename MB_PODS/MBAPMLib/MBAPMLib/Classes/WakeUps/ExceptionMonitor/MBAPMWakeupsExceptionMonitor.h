//
//  MBAPMWakeupsExceptionMonitor.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/10.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
#import "MBAPMWakeupsMonitorConfig.h"
@import MBDoctorService;

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBAPMWakeupsReportBlock)(MBAPMMetric *metric);

@interface MBAPMWakeupsExceptionMonitor : NSObject

@property (nonatomic, strong) dispatch_queue_t monitorQueue;

- (instancetype)initWithReportBlock:(MBAPMWakeupsReportBlock)reportBlock 
                      monitorConfig:(MBAPMWakeupsMonitorConfig *)config;

- (void)startMonitor;

- (void)stopMonitor;

- (void)didRecordWakeups:(NSInteger)wakeups;

@end

NS_ASSUME_NONNULL_END
