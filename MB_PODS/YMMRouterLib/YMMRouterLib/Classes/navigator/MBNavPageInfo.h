//
//  MBNavPageInfo.h
//  YMMRouterLib
//
//  Created by xp on 2023/7/24.
//

#import <Foundation/Foundation.h>
#import "UIViewController+MBRouter.h"

NS_ASSUME_NONNULL_BEGIN


@class MBNavContainerInnerPageInfo;
@class MBNavBaseAction;


/// 页面模型
@interface MBNavPageInfo : NSObject


/// 页面所属viewController
@property (nonatomic, weak) UIViewController *viewController;


@property (nonatomic, readonly, strong) MBRouterIntent *intent;


/// 页面跳转路由信息
@property (nonatomic, strong) id<YMMRouterRoutable> routable;


/// 跨端容器子页面信息
@property (nonatomic, strong) NSMutableArray<MBNavContainerInnerPageInfo *> *innerPages;

/// 若为普通nativeVC，直接返回当前routable的originUrlString，若为容器页面，返回容器内页面栈栈顶页面
@property (nonatomic, strong) NSString *topPageUrl;

- (instancetype)initWithViewController: (UIViewController *)viewController;

@end

@interface MBNavContainerInnerPageInfo : NSObject


/// 子页面路由url
@property (nonatomic, copy) NSString *pageUrl;

@end

NS_ASSUME_NONNULL_END
