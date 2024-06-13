//
//  MBDebugEntryManager.h
//  Pods
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import MBFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugEntryManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(MBDebugEntryManager)

@property (nonatomic, assign, readonly) BOOL debugWindowIsClosed;

/// 初始化debug悬浮窗口
- (void)initDebugWindow;

/// 显示debug悬浮窗口
- (void)showDebugWindow;

/// 隐藏debug悬浮窗口
- (void)hideDebugWindow;

/// 关闭debug悬浮窗口
- (void)removeDebugWindow;

/// 所有debug入口视图集合
- (NSArray *)debugEntryTools;

@end

NS_ASSUME_NONNULL_END
