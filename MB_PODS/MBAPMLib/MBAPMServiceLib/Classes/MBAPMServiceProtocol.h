//
//  MBAPMServiceProtocol.h
//  MBAPMServiceLib
//
//  Created by xp on 2020/7/27.
//

#ifndef MBAPMServiceProtocol_h
#define MBAPMServiceProtocol_h

@import YMMModuleLib;
#import "MBAPMViewPageProtocol.h"
#import "MBAPMMemoryLeakProtocol.h"
#import "MBAPMConfiguration.h"
#import "MBAPMEventTrack.h"
#import "MBAPMEventTimeTrack.h"

@protocol MBAPMServiceProtocol <YMMServiceProtocol>

/// 初始化方法，需要在监控指标之前调用
- (void)startMonitor:(MBAPMConfiguration *)configuration;

/// 是否开启页面耗时分析
- (void)enableRenderMonitor:(BOOL)enable;


///开启自定义app启动结束点，此方法必须在applicationDidFinishLaunching方法中或之前调用
- (void)enableCustomLaunchEnding;


/// 启动结束，在自定义启动结束点需要调用此方法，否则无法统计启动时间
- (void)endAppLaunch;


/// 手动页面渲染耗时埋点，支持插入自定义中间分段节点
/// @param viewPage MBAPM页面协议
- (id<MBAPMEventTrack>)startTrack:(id<MBAPMViewPageProtocol>)viewPage;


/// 手动页面渲染耗时埋点，支持插入自定义中间分段节点
/// @param viewPage MBAPM页面协议
- (id<MBAPMEventTimeTrack>)startPageRenderTrack:(id<MBAPMViewPageProtocol>)viewPage;


/// 增加页面加载耗时检测页面黑名单
/// @param pageClassNameList 页面className列表
- (void)addRenderDetectBlockList:(NSArray<NSString *> *)pageClassNameList;

/// 获取App启动时间
- (UInt64)getAppLaunchStartTime;


// MARK: - 内存相关设置
/// 内存泄漏的忽略类
/// @param classNames 白名单String
- (void)addClassNamesToLeaksWhitelist:(NSArray *)classNames;

// 打开leaks finder
- (void)setEnableLeaksFinder:(BOOL)enable;
- (BOOL)isEnableLeaksFinder;

// 是否弹窗
- (void)setEnableLeaksAlert:(BOOL)enable;
- (BOOL)isEnableLeaksAlert;

// 注意，当导入FBRetainCycle才会生效。用于设置是否启用FBRetainCycle
- (void)setEnableCheckRetainCycle:(BOOL)enable;
- (BOOL)isEnableCheckRetainCycle;

// MARK: - 页面相关
- (NSString * _Nullable)currentPageName;
- (NSString * _Nullable)currentPageClassName;
- (NSString * _Nullable)currentPagePath;
// 若未命中apm内部灰度，返回NO；若在页面加载判断过程中，返回YES，直至判断结束。
- (BOOL)currentPageIsLoading;


@end


#endif /* MBAPMServiceProtocol_h */
