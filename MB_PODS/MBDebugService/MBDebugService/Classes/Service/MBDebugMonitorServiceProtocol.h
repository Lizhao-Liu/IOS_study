//
//  MBDebugMonitorServiceProtocol.h
//  MBDebugService
//
//  Created by Lizhao on 2022/8/29.
//

#import <Foundation/Foundation.h>
#import "MBDebugMonitorPageInfoModel.h"
@import YMMModuleLib;

@protocol MBDebugActivityMonitorVCProtocol <NSObject>

- (void)didSwitchToCurrentPageOnlyMode:(NSString *)pageName;

- (void)didSwitchToGlobalMode;

@end


typedef UIViewController<MBDebugActivityMonitorVCProtocol>* _Nonnull(^MBDebugMonitorPanelBlock)(void); //返回值为需要集成的监听面板vc
typedef void (^MBDebugMonitorStatusChangedBlock)(BOOL isOn); //参数为是否开启监听
typedef NSArray<MBDebugMonitorPageInfoModel *> * _Nullable(^MBDebugMonitorPageInfoBlock)(UIViewController *pageVC); //获取vc的基本信息block



@protocol MBDebugMonitorServiceProtocol <NSObject, YMMServiceProtocol>

@property (nonatomic, copy, readonly) NSString *title; // 显示在nav bar上的名称, 用于标识monitor tool (需确保唯一性)

@property (nonatomic, copy, readonly) MBDebugMonitorPanelBlock monitorVCBlock; //返回需要显示的view controller

@property (nonatomic, assign) BOOL isMonitoring; //返回值表示是否已开启监听状态

- (void)monitorToolDidLoad;//已加载时机需要执行的方法

@optional

@property (nonatomic, copy, readonly) MBDebugMonitorPageInfoBlock pageInfoBlock; //page only 模式下当前页面信息回调block

@property (nonatomic, copy, readonly) MBDebugMonitorStatusChangedBlock monitorStatusChangedBlock; //开启关闭监听功能执行block，如果未设置则无法使用监听功能开关

@end




/**
 @"MBDebugMonitorShowRedDotNotification" // 展示小红点通知名称
 @"MBDebugMonitorHideRedDotNotification" // 隐藏小红点通知名称
 // 发送通知需携带userinfo参数，传入显示在nav bar上的名称作为key为@"monitorTitle"的对应value，用于小红点提示逻辑处理
  

 //发送显示小红点通知
 [[NSNotificationCenter defaultCenter] postNotificationName:@"MBDebugMonitorShowRedDotNotification" object:nil userInfo:@{@"monitorTitle": 显示在nav bar上的名称}];

 //发送隐藏小红点通知
 [[NSNotificationCenter defaultCenter] postNotificationName:@"MBDebugMonitorHideRedDotNotification" object:nil userInfo:@{@"monitorTitle": 显示在nav bar上的名称}];
 */
