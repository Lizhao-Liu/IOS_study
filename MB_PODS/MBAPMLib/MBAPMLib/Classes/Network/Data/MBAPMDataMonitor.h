//
//  MBAPMDataMonitor.h
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"
#import "MBAPMDataMonitorConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDataMonitor : MBAPMPlugin
@property (nonatomic, strong, nullable) MBAPMDataMonitorConfig *trafficConfig;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
