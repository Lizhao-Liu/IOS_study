//
//  MBNavStackManager.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import <Foundation/Foundation.h>
#import "YMMRouter.h"
#import "MBNavPageInfo.h"
@import MBUIKit;

#define MBNav_Page_NotFound -1

NS_ASSUME_NONNULL_BEGIN


///  页面堆栈历史记录
@interface MBNavStackHistory : NSObject

@property (nonatomic, copy) NSArray<MBNavPageInfo *> *stackHistory;

// 堆栈长度
@property (nonatomic, assign) NSUInteger stackLength;

@end

@interface MBNavStackRecord : NSObject

@property (nonatomic, strong) MBNavPageInfo *pageInfo;

/// 在native页面栈中的位置
@property (nonatomic, assign) NSUInteger index;

// 在容器内部页面的偏移
@property (nonatomic, assign) NSUInteger delta;

@end

@interface MBNavStackManager : NSObject <MBUIKitHookViewControllerObserverProrocol>

+ (instancetype)shared;

- (NSUInteger)findPageIndexWithRedirect:(id<YMMRouterRoutable>) routable;

- (MBNavStackRecord *)findPageInStackWithDelta:(NSInteger)delta stackHistory:(MBNavStackHistory *)history;

- (NSArray<MBNavPageInfo *> *)getAppPageStacks;

- (NSArray<NSString *> *)getStackHistory;

- (UIViewController *)getTabBarViewController;

- (UIViewController *)getCurrentViewController;

- (UINavigationController *)searchNaviControllerInStackHistory:(NSInteger)delta;

- (void)push:(UIViewController *)viewController currentVC:(UIViewController *)currentVC withAnimation:(BOOL)animation completion:(void(^)(BOOL))completion;

- (void)pushWithNavi:(UIViewController *)viewController navVC:(UINavigationController *)navVC withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion;

- (void)pop:(UIViewController *)currentVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion;

- (void)popN:(NSUInteger)delta withCurrentVC:(UIViewController *)currentVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion;

- (void)popN:(NSUInteger)delta fromVC: (UIViewController *)popFromVC withCurrentVC:(UIViewController *)currentVC withKeepVC:(nullable UIViewController * )keepVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion;

- (void)popKeepN:(NSUInteger)keepNum withCurrentVC:(UIViewController *)currentVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion;

- (void)popUtil:(UIViewController *)currentVC routable:(id<YMMRouterRoutable>)routable needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion;

- (void)presenter:(UIViewController *)viewController currentVC:(UIViewController *)currentVC viewHeight:(CGFloat)viewHeight withAnimation:(BOOL)animation completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
