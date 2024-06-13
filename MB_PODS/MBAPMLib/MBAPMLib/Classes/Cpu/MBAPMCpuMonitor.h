//
//  MBAPMCpuMonitor.h
//  MBAPMLib
//
//  Created by FDW on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"
#import "MBAPMCpuMonitorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMCpuMonitor : MBAPMPlugin
@property (nonatomic, strong, nullable) MBAPMCpuMonitorConfig *cpuConfig;
@property (nonatomic, assign, readonly) BOOL isExceptionGather;

- (BOOL)getIsExceptionGather;
- (void)setIsExceptionGatherWith:(BOOL )isGather;

// 开启正常采集
- (void)startMonitor;
// 停止 & 重置数据
- (void)resetData;

// 开启异常采集
- (void)startExceptionMonitor;
// 停止 & 重置数据
- (void)resetExceptionData;

// 异常队列名字
- (NSString *)getCpuExceptionOperationQueueName;
@end

NS_ASSUME_NONNULL_END
