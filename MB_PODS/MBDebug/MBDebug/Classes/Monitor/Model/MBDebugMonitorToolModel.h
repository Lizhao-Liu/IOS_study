//
//  MBDebugMonitorToolModel.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import MBDebugService;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBDebugMonitorToolPriority) {
    MBDebugMonitorToolPriorityLow = 0,
    MBDebugMonitorToolPriorityNormal = 1,
    MBDebugMonitorToolPriorityImportant = 2,
    MBDebugMonitorToolPriorityCritical = 3,
};

typedef BOOL (^MBDebugMonitorMonitorStatusBlock)(void);

@interface MBDebugMonitorToolModel : NSObject

@property (nonatomic, copy) NSString *title; // 监听模块名称
@property (nonatomic, copy) MBDebugMonitorPanelBlock monitorVCBlock; // 返回值为需要集成的监听面板vc
@property (nonatomic, copy) MBDebugMonitorStatusChangedBlock monitorStatusChangedBlock; // 开启关闭监听功能回调block
@property (nonatomic, copy) MBDebugMonitorPageInfoBlock pageInfoBlock; // 当前页面数据获取block

@property (nonatomic, copy) MBDebugMonitorMonitorStatusBlock monitorStatusBlock; // 当前模块监听状态获取block， 读取协议实现类的isMonitoring属性

@property (nonatomic, assign) MBDebugMonitorToolPriority priority; // tab展示优先级
@property (nonatomic, assign) BOOL needShowErrorIndicator; //小红点展示

@end

NS_ASSUME_NONNULL_END
