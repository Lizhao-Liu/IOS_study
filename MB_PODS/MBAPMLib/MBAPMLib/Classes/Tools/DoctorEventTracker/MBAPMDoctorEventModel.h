//
//  MBAPMDoctorEventModel.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBAPMDoctorEventType) {
    MBAPMDoctorEventTypeUnknown,
    MBAPMDoctorEventTypePageView,
    MBAPMDoctorEventTypeClick,
    MBAPMDoctorEventTypeEnterForeground,
    MBAPMDoctorEventTypeMessage,
};

@interface MBAPMDoctorEventModel : NSObject

// 事件埋点时间
@property (nonatomic, assign) unsigned long long timestamp;

// 事件类型
@property (nonatomic, assign) MBAPMDoctorEventType eventType;

// 事件信息
/// 未知事件：固定 "unknown"
/// pv事件：页面名称
/// 点击事件：页面名称.元素名称
/// 进入前台：固定"enter_foreground"
/// 长链接：消息类型.业务类型
@property (nonatomic, copy) NSString *eventFeature;

@end

NS_ASSUME_NONNULL_END
