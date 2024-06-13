//
//  MBAPMWakeupsPageMonitor.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import <Foundation/Foundation.h>
#import "MBAPMViewPageContext.h"
#import "MBAPMPlugin.h"
#import "MBAPMWakeupsMonitorConfig.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^MBAPMWakeupsReportBlock)(MBAPMMetric *metric);

@interface MBAPMWakeupsPageMonitor : NSObject

@property (nonatomic, strong) dispatch_queue_t monitorQueue;

- (instancetype)initWithReportBlock:(MBAPMWakeupsReportBlock)reportBlock monitorConfig:(MBAPMWakeupsMonitorConfig *)config;

- (void)didPageLoad:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)didPageIn:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)didPageOut:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)didPageDealloc:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)startMonitor;

- (void)stopMonitor;

- (void)didRecordWakeups:(NSInteger)wakeups;

@end

NS_ASSUME_NONNULL_END
