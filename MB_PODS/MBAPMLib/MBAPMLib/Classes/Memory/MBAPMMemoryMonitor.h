//
//  MBMemoryMonitor.h
//  YMMPerformanceModule
//
//  Created by seal on 2020/5/27.
//

#import <Foundation/Foundation.h>
@import MBAPMServiceLib;
#import "MBAPMPlugin.h"
#import "MBAPMViewPageContext.h"
@class MBMemoryLogDetector;

NS_ASSUME_NONNULL_BEGIN

// 记录所有内存事件，内存使用量log，oom，泄漏，大图，warnig，等
@interface MBAPMMemoryMonitor : MBAPMPlugin

/// 内存使用量log专属;
- (MBMemoryLogDetector *)memoryLogDetector;

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

// MARK: - 非配置项
/// 内存泄漏埋点， cong MLeakFinder调用
/// @param leakMessage MBAPM页面协议
- (void)logMemoryLeak:(id<MBAPMMemoryLeakProtocol>)leakMessage;


@end

NS_ASSUME_NONNULL_END
