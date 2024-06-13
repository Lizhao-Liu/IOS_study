//
//  MBAPMLagMonitor.h
//  MBAPMLib
//
//  Created by xp on 2020/8/15.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMLagMonitor : MBAPMPlugin

/// 卡顿上报渠道
@property (nonatomic, assign) MBAPMReportChannel channel;

@end

NS_ASSUME_NONNULL_END
