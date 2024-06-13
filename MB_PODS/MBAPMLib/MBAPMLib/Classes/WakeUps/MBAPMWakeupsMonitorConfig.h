//
//  MBAPMWakeupsMonitorConfig.h
//  AAChartKit
//
//  Created by Lizhao on 2024/1/8.
//

#import <Foundation/Foundation.h>
#import "MBAPMPluginConfig.h"
@import MBAPMServiceLib;

#define MBAPM_TASK_WAKEUPS_DEFAULT_MONITOR_LIMIT_PER_SECOND        150 /* wakeups per second */
#define MBAPM_TASK_WAKEUPS_DEFAULT_MINITOR_INTERVAL    300 /* in seconds. */
#define MBAPM_TASK_WAKEUPS_DEFAULT_DATA_COLLECTION_INTERVAL    1 /* 采集数据间隔 */
#define MBAPM_TASK_WAKEUPS_DEFAULT_REPORT_THRESHOLD    600 /* 连续高位异常分段阈值 */
#define MBAPM_TASK_WAKEUPS_SUDDEN_INCREASE_DEFAULT_THRESHOLD    450  /* 突增阈值 */
NS_ASSUME_NONNULL_BEGIN

@interface MBAPMWakeupsMonitorConfig : MBAPMPluginConfig

@property (nonatomic, assign) NSInteger dataCollectionInterval;

@property (nonatomic, assign) NSInteger monitorDurationLimit;

@property (nonatomic, assign) NSInteger wakeupsLimitPerSec;

@property (nonatomic, assign) NSInteger heavySectionReportThreshold;

@property (nonatomic, assign) NSInteger suddenIncreaseThreshold;

@end

@interface MBAPMConfiguration(WakeupsMonitor)

@property (nonatomic, strong) MBAPMWakeupsMonitorConfig *wakeupsMonitorConfig;

@end

NS_ASSUME_NONNULL_END
