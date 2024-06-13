//
//  MBAPMDoctorEventTracker.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/2/20.
//

/**
 埋点事件采集/绑定
 
 目标：
 辅助定位wakeups突增异常原因
 
 策略：
 1. 特殊行为事件采集：
   特殊行为事件定义： pv / click / 长链接
   拦截埋点数据并过滤，保留最近发生的五条特殊行为事件信息
 2. 特殊行为绑定：
   规则一：若最近5s内未发生以上特殊行为埋点，则不绑定任何事件
   规则二：若最近5s内存在特殊行为埋点，则根据以下优先级绑定事件：
    进入前台 > pv = click > 其他（长链接/push）
 */

#import <Foundation/Foundation.h>
#import "MBAPMDoctorEventModel.h"
@import MBDoctorService;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDoctorEventTracker : NSObject

+ (instancetype)sharedInstance;

- (void)trackEvent:(__kindof id<MBDoctorEventProtocol>)event context:(id<MBContextProtocol>)context;

- (MBAPMDoctorEventModel *)getActionEvent;

@end

NS_ASSUME_NONNULL_END
