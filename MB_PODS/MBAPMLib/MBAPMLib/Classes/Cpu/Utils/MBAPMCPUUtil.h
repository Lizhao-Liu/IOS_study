//
//  MBAPMCPUUtil.h
//  MBAPMLib
//
//  Created by xp on 2020/8/10.
//

#import <Foundation/Foundation.h>

@class MBAPMCpuMonitor;
NS_ASSUME_NONNULL_BEGIN

@interface MBAPMCPUUtil : NSObject

+ (CGFloat)appCpuUsage;

+ (CGFloat)appCpuUsageWithMonitorWithNormal:(BOOL )isNormal monitor:(MBAPMCpuMonitor *)monitor;

+ (CGFloat)totalCpuUsage;


@end

NS_ASSUME_NONNULL_END
