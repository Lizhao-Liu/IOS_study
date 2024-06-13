//
//  MBNavManager.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/24.
//

#import <Foundation/Foundation.h>
#import "MBNavTransitionBuilder.h"
#import "MBNavPageInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// 页面容器执行页面栈管理协议，MBNavStackManager在处理过程中发现页面导航操作需要派发给容器时会调用此协议相关方法
@protocol MBNavPageContainerStackManagerDelegate <NSObject>

- (void)mbnav_executeAction:(MBNavBaseAction *)action inPageContainer:(UIViewController *)container complete:(void(^)(BOOL))completion;

@end

@interface MBNavManagerConfig : NSObject


/// 是否开启对路由寻址进行拦截，将路由地址与页面VC进行绑定，只有开启了此开关，getAppPageStacks和popUtil等方法才能正常运行
@property (nonatomic, assign) BOOL enableRouterInterceptor;

// 页面切换超时时间
@property (nonatomic, assign) NSTimeInterval navTransitionTimeoutInterval;

// 设置容器的内部页面的堆栈操作
@property (nonatomic, weak) id<MBNavPageContainerStackManagerDelegate> containerStackManagerDelegate;


/// 在pop操作时若delta参数
@property (nonatomic, assign) NSInteger skipPageCountBottomOfStack;

@end

@interface MBNavManager : NSObject


/// 初始化方法，在调其他方法之前要先进行初始化
+ (void)setup:(MBNavManagerConfig *)config;

/// 单例方法
+ (instancetype)shared;


- (instancetype)init NS_UNAVAILABLE;


/// 生成MBNavTransitionBuilder构造器，用于构造MBNavTransition对象
- (MBNavTransitionBuilder *)transition;


/// 获取当前页面栈信息，容器栈内页面没有打平，需要通过MBNavPageInfo对下的innerPages属性获取
- (NSArray<MBNavPageInfo *> *)getAppPageStacks;

/// 获取页面栈历史，容器栈内页面打平，返回页面路由url列表，其中没有路由url的VC，返回“UNKNOWN”
- (NSArray<NSString *> *)getStackHistory;

@end

NS_ASSUME_NONNULL_END
