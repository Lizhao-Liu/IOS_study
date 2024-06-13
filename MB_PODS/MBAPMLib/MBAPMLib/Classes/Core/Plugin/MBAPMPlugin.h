//
//  MBAPMPlugin.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class MBAPMMetric;
@class MBAPMContext;
@class MBAPMViewPageContext;
@class MBAPMPluginConfig;
@protocol MBAPMPluginListenerDelegate;

typedef  NS_ENUM(NSUInteger, MBAPMPluginTag) {
    MBAPMPluginTagNone,
    MBAPMPluginTagAppLaunch,
    MBAPMPluginTagRenderDetect,
    MBAPMPluginTagLagDetect,
    MBAPMPluginTagCrash,
    MBAPMPluginTagMemory,
    MBAPMPluginTagMatrix,
    MBAPMPluginTagCpu,
    MBAPMPluginTagMetric,
    MBAPMPluginTagFPS,
    MBAPMPluginTagWhiteScreen,
    MBAPMPluginTagStorage,
    MBAPMPluginTagWakeUps
};


/// 插件协议
@protocol MBAPMPluginProtocol <NSObject>

//是否为单例
+ (BOOL)isSingleton;

///是否为自启动，不需要在App启动时主动调start方法
- (BOOL)isSelfStart;

/// 获取单例对象
+ (id)shareInstance;

/// 插件开始检测
- (void)start;


/// 插件停止检测
- (void)stop;


/// 插件中止检测
- (void)abort;


/// 销毁插件
- (void)destroy;


/// 设置插件事件代理
/// @param delegate 代理对象
- (void)setListenerDelegate:(id<MBAPMPluginListenerDelegate>)delegate;


@required
/// 返回插件标识
- (MBAPMPluginTag)pluginTag;

@end


///APM插件生命周期回调代理
@protocol MBAPMPluginListenerDelegate <NSObject>

@optional
- (void)onInit:(id<MBAPMPluginProtocol>)plugin;

@optional
- (void)onStart:(id<MBAPMPluginProtocol>)plugin;

@optional
- (void)onStop:(id<MBAPMPluginProtocol>)plugin;

@optional
- (void)onDestroy:(id<MBAPMPluginProtocol>)plugin;

@end


/// APM插件基类
@interface MBAPMPlugin : NSObject<MBAPMPluginProtocol>

@property (nonatomic, strong, nullable) MBAPMPluginConfig *config;
@property (nonatomic, strong) MBAPMContext *context;

/// 上报性能数据
/// @param metric 性能数据
- (void)reportMetrics:(MBAPMMetric *)metric;

@end

NS_ASSUME_NONNULL_END
