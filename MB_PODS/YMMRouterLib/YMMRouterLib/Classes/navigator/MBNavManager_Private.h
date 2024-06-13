//
//  MBNavManager_Private.h
//  Pods
//
//  Created by xp on 2023/7/26.
//

#import "MBNavTransition.h"
#import "MBNavManager.h"
#import "UIViewController+MBRouter.h"


@interface MBNavManager()


/// 当前正在运行的transition
@property(nonatomic, strong) MBNavBaseTransition *currentTransition;


/// 当前是否有transition正在运行
@property(nonatomic, assign) BOOL isTransitioning;


///  transition队列
@property(nonatomic, strong) NSMutableArray<MBNavTransitionBuilder *> *transitionQueue;

/// 页面导航配置对象
@property (nonatomic, strong) MBNavManagerConfig *navConfig;

@end
