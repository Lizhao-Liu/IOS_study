//
//  MBAPMAppLaunchMetric.h
//  MBAPMLib
//
//  Created by xp on 2020/7/22.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMAppLaunchType) {
    MBAPMAppLaunchTypeCold, // 冷启动
    MBAPMAppLaunchTypeHot   // 热启动
};

@interface MBAPMAppLaunchMetric : MBAPMMetric


/// App启动方式
@property (nonatomic, assign) MBAPMAppLaunchType launchType;

/// 上次app关闭原因
@property (nonatomic, assign) NSUInteger lastShutOffType;

/// 启动耗时区间
/// 耗时范围[0,1]区间为1，(1, 1.5]区间为2，（1.5, 2]区间为3，(2, 3]区间为4，(3, 5]区间为5，(5, 10)区间为6，(10, ∞)区间为7
@property (nonatomic, assign) NSInteger time_interval;

/// 启动模式，具体定义见MBLauncherLib中MBLaunchMode枚举值
@property (nonatomic, assign) NSInteger launchMode;

/// 单次启动中存在两次启动流程的前一次启动流程的模式
@property (nonatomic, assign) NSInteger lastLaunchMode;

/// 启动自定义维度参数
@property (nonatomic, assign) NSDictionary *tags;

/// 启动是否超时
@property (nonatomic, assign) BOOL isLaunchTimeOut;


/// 分段时间
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *timeSections;

@end

NS_ASSUME_NONNULL_END
