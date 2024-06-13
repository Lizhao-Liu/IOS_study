//
//  MBNavStackManager.m
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import "MBNavStackManager.h"
#import "YMMRouterCenter.h"
#import "YMMRouterResponse.h"
#import "UIViewController+MBNav.h"
#import "MBRouterLogger.h"
#import "MBNavManager_Private.h"

@import MBUIKit;

@implementation MBNavStackHistory

@end

@implementation MBNavStackRecord


@end

@implementation MBNavStackManager

#pragma mark - Public Methods

+ (instancetype)shared {
    static MBNavStackManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MBNavStackManager new];
    });
    return instance;
}

- (UIViewController *)getCurrentViewController {
    return [UIViewController mb_currentViewController];
}

- (void)push:(UIViewController *)viewController currentVC:(UIViewController *)currentVC withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    if (!viewController || !currentVC) {
        MBRouterFatal(@"push vc, destination vc and current vc can't be nil");
    }
    MBRouterInfo(@"MBNav stackManager push start currentVC = %@, destinationVC = %@, animation = %d", currentVC, viewController, animation);
    // 获取距离最近的UINavigationController
    UINavigationController *navVC = [self currentNavi:currentVC];
    [self executeTransaction:^{
        [navVC pushViewController:viewController animated:animation];
    } completion:^() {
        MBRouterInfo(@"MBNav stackManager push complete destinationVC = %@", viewController);
        if (completion) {
            completion(YES);
        }
    }];
}

- (void)pushWithNavi:(UIViewController *)viewController navVC:(UINavigationController *)navVC withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    if (!viewController || !navVC) {
        MBRouterFatal(@"push vc, destination vc and navi vc can't be nil");
    }
    MBRouterInfo(@"MBNav stackManager pushWithNavi start naviVC = %@, destinationVC = %@, animation = %d", navVC, viewController, animation);
    [self executeTransaction:^{
        [navVC pushViewController:viewController animated:animation];
    } completion:^() {
        MBRouterInfo(@"MBNav stackManager push complete destinationVC = %@", viewController);
        if (completion) {
            completion(YES);
        }
    }];
}

- (void)presenter:(UIViewController *)viewController currentVC:(UIViewController *)currentVC viewHeight:(CGFloat)viewHeight withAnimation:(BOOL)animation completion:(void (^)(void))completion {
    if (!viewController || !currentVC) {
        MBRouterFatal(@"presenter vc, destination vc and current vc can't be nil");
    }
    MBRouterInfo(@"MBNav stackManager presenter start currentVC = %@, destinationVC = %@,animation=%d viewHeight = %f", currentVC, viewController, animation, viewHeight);
    [self executeTransaction:^{
        if (viewHeight > 0) {
            [currentVC ymm_bottomPresentController:viewController presentedHeight:viewHeight completeHandle:^(BOOL presented) {
                MBRouterInfo(@"MBNav stackManager presenter from bottom callback destinationVC = %@ presented = %d", viewController, presented);
            }];
        } else {
            [currentVC presentViewController:viewController animated:animation completion:^{
                MBRouterInfo(@"MBNav stackManager presenter callback destinationVC = %@", viewController);
            }];
        }
    } completion:^() {
        MBRouterInfo(@"MBNav stackManager presenter complete destinationVC = %@", viewController);
        if (completion) {
            completion();
        }
    }];
}

- (void)pop:(UIViewController *)currentVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    if (!currentVC) {
        MBRouterFatal(@"pop vc, current vc can't be nil");
    }
    MBRouterInfo(@"MBNav stackManager pop start currentVC = %@, needPopNav = %d, animation = %d", currentVC, needPopNav, animation);
    if ([currentVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *currentNavVC = (UINavigationController *)currentVC;
        void(^popNavViewController)(void) = ^(void){
            if (currentNavVC.viewControllers.count > 1) {
                [self executeTransaction:^{
                    [currentNavVC popViewControllerAnimated:animation];
                                } completion:^{
                                    MBRouterInfo(@"MBNav stackManager pop,  pop viewController of current navVc");
                                    if (completion) {
                                        completion(YES);
                                    }
                                }];
            } else {
                if (completion) {
                    completion(YES);
                }
            }
        };
        if (currentNavVC.presentedViewController && [currentNavVC.presentedViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self executeTransaction:^{
                            [currentNavVC.presentedViewController dismissViewControllerAnimated:NO completion:^{
                                MBRouterInfo(@"MBNav stackManager pop,  dismiss presented viewController of current navVc");
                                popNavViewController();
                            }];
                        } completion:^{
                            MBRouterInfo(@"MBNav stackManager pop,  dismiss presented viewController transition of current navVc");

                        }];
           
        }
        return;
    }
    // 若本身是presenter出来且没有包裹navigationController，则currentVC.navigationController为nil,反之若本身是push出来，而navigationController是presenter出来则navigationController和presentingViewController都存在
    if (currentVC.presentingViewController && !currentVC.navigationController) {
        MBRouterInfo(@"MBNav stackManager pop, dismiss start currentVC = %@", currentVC);
        [self executeTransaction:^{
            [currentVC dismissViewControllerAnimated:animation completion:^{
                //TODO  验证currentVC为childVC的情况下dismiss时是否能够pop掉parentVC
                MBRouterInfo(@"MBNav stackManager pop, dismiss complete callback currentVC = %@", currentVC);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES);
                    }
                });
            }];
        } completion:^() {
            MBRouterInfo(@"MBNav stackManager pop, dismiss transition complete currentVC = %@", currentVC);
        }];
    } else {
        UINavigationController *navVC = [self currentNavi:currentVC];
        if (navVC && navVC.viewControllers.count > 0) {
            UIViewController *resultVC = [self searchController:currentVC forViewControllers:navVC.viewControllers]; //在nav中查询是否包含当前VC或者当前VC的parentVC
            if (resultVC) {
                if (navVC.viewControllers.count == 1 && resultVC == navVC.viewControllers.firstObject && navVC.presentingViewController && needPopNav) {
                    MBRouterInfo(@"MBNav stackManager pop, dismiss nav start, resultVC  = %@, navVC = %@", resultVC, navVC);
                    [self executeTransaction:^{
                        [navVC dismissViewControllerAnimated:animation completion:^{
                            MBRouterInfo(@"MBNav stackManager pop, dismiss navi complete callback, navVC  = %@", navVC);
                        }];
                    } completion:^() {
                        if (completion) {
                            completion(YES);
                        }
                        MBRouterInfo(@"MBNav stackManager pop, dismiss navi transition complete callback, navVC  = %@", navVC);
                    }];
                    return;
                }
                MBRouterInfo(@"MBNav stackManager pop, pop childVC start, resultVC  = %@", resultVC);
                [self executeTransaction:^{
                        NSMutableArray *viewControllers =  [navVC.viewControllers mutableCopy];
                        [viewControllers removeObject:resultVC];
                        navVC.viewControllers = viewControllers;
                    } completion:^() {
                        MBRouterInfo(@"MBNav stackManager pop, pop childVC transition complete, resultVC  = %@", resultVC);
                        if (completion) {
                            completion(YES);
                        }
                    }];
            }
        } else {
            MBRouterError(@"MBNav stackManager pop complete, nearest navi can't be found");
            if (completion) {
                completion(NO);
            }
        }
    }
}

- (void)popN:(NSUInteger)delta fromVC: (UIViewController *)popFromVC withCurrentVC:(UIViewController *)currentVC withKeepVC:(UIViewController *)keepVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    NSAssert(delta >= 1, @"popN delta parameter must not less than 1");
    NSAssert(currentVC, @"popN currentVC can't be nil");
    if (delta < 1) {
        MBRouterError(@"MBNav stackManager popN delta parameter is less than 1");
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    BOOL isPopFromStackTopVC = YES;
    if (popFromVC && currentVC && popFromVC != currentVC) {
        isPopFromStackTopVC = NO;
    }
    MBRouterInfo(@"MBNav stackManager popN, delta = %lu, currentVC  = %@, popFromVC = %@, isPopFromStackTopVC = %d", delta, currentVC, popFromVC, isPopFromStackTopVC);
    if (!isPopFromStackTopVC) {
        // popFromVC和currentVC不相同，则是从非栈顶VC pop，暂时只支持从栈顶下一个VC进行pop
        delta++;
    }
    MBNavStackRecord *stackRecord = [self findPageInStackWithDeltaForPopN:delta];
    if (!stackRecord) {
        MBRouterError(@"MBNav stackManager popN, destination vc can't be found, delta = %lu", delta);
        if (completion) {
            completion(NO);
        }
        return;
    }
    [self popToViewController:popFromVC currentVC:currentVC withKeepVC: keepVC destinationPage:stackRecord.pageInfo needPopNav:needPopNav withAnimation: animation completion:^(BOOL result) {
        if (stackRecord.delta > 0 && stackRecord.pageInfo.viewController) {
            // 若需要回退到的页面为容器内页面，则需要通知容器进行回退
            UIViewController *containerVC = stackRecord.pageInfo.viewController;
            if ([containerVC conformsToProtocol:@protocol(MBNavPageContainerProtocol)]) {
                if ([containerVC respondsToSelector:@selector(mbnav_popN:complete:)]) {
                    [containerVC mbnav_popN:stackRecord.delta complete:^(BOOL result) {
                        MBRouterError(@"MBNav stackManager popN in container result = %d, remain child pages count = %lu", result, stackRecord.pageInfo.innerPages.count);
                        if (completion) {
                            completion(result);
                        }
                        return;
                    }];
                }
            }
        }
        if(completion) {
            completion(result);
        }
    }];
}

- (void)popN:(NSUInteger)delta withCurrentVC:(UIViewController *)currentVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    [self popN:delta fromVC:currentVC withCurrentVC:currentVC withKeepVC:nil needPopNav:needPopNav withAnimation:animation completion:completion];
}

- (void)popKeepN:(NSUInteger)keepNum withCurrentVC:(UIViewController *)currentVC needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    NSAssert(keepNum < 0, @"popKeepN delta parameter must not less than 0");
    NSAssert(currentVC, @"popKeepN currentVC can't be nil");
    if (keepNum < 0) {
        MBRouterError(@"MBNav stackManager popKeepN delta parameter is less than 0");
        if (completion) {
            completion(NO);
        }
        return;
    }
    if (currentVC.presentingViewController && !currentVC.navigationController) {
        MBRouterInfo(@"MBNav stackManager popKeepN, dismiss start currentVC = %@", currentVC);
        [self executeTransaction:^{
            [currentVC dismissViewControllerAnimated:animation completion:^{
                //TODO  验证currentVC为childVC的情况下dismiss时是否能够pop掉parentVC
                MBRouterInfo(@"MBNav stackManager popKeepN, dismiss complete callback currentVC = %@", currentVC);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES);
                    }
                });
            }];
        } completion:^() {
            MBRouterInfo(@"MBNav stackManager popKeepN, dismiss transition complete currentVC = %@", currentVC);
        }];
    }
    
    
}

- (void)popUtil:(UIViewController *)currentVC routable:(id<YMMRouterRoutable>)routable needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    NSAssert(currentVC, @"popUtil currentVC can't be nil");
    NSAssert(routable, @"popUtil routable can't be nil");
    if (!routable) {
        MBRouterError(@"MBNav stackManager popUtil, routable can't be nil");
        if (completion) {
            completion(NO);
        }
        return;
    }
    // 查找重定向之后的路由
    id<YMMRouterRoutable> redirectedRoutable = [[YMMRouterCenter shared]getRedictedUrl:routable];
    MBRouterInfo(@"MBNav stackManager popUtil, routable url = %@, redirectedRoutable = %@ needPopNav = %d", routable.originUrlString, redirectedRoutable.originUrlString, needPopNav);
    // 在路由栈中查找是否有路由匹配的页面
    MBNavStackRecord *stackRecord = [self findPageInStack:redirectedRoutable];
    if (!stackRecord) {
        // 若不存在，则通过路由生成新页面进行跳转
        MBRouterInfo(@"MBNav stackManager popUtil, routable doesn't exist, need push a new page");
        [[YMMRouterCenter shared]perform:redirectedRoutable completion:^(YMMRouterResponse * _Nullable response) {
            if (response.result && [response.result isKindOfClass:UIViewController.class]) {
                UIViewController *viewController = response.result;
                MBRouterInfo(@"MBNav stackManager popUtil, push a new page, destination vc = %@", viewController);
                [self push:viewController currentVC:currentVC withAnimation:YES  completion:^(BOOL result) {
                    MBRouterInfo(@"MBNav stackManager popUtil, push a new page complete");
                    if (completion) {
                        completion(result);
                    }
                }];
            } else {
                MBRouterInfo(@"MBNav stackManager popUtil, push a new page, destination vc can't be found = %@");
                if (completion) {
                    completion(NO);
                }
            }
        }];
    } else {
        // 若页面存在，则pop到该页面
        MBRouterInfo(@"MBNav stackManager popUtil, routable exist, popToViewController = %@", stackRecord.pageInfo.viewController);
        [self popToViewController:currentVC destinationPage:stackRecord.pageInfo needPopNav:needPopNav withAnimation:animation completion:^(BOOL result) {
            MBRouterInfo(@"MBNav stackManager popUtil, popToViewController complete");
            if (stackRecord.delta > 0 && stackRecord.pageInfo.viewController) {
                // 若需要回退到的页面为容器内页面，则需要通知容器进行回退
                UIViewController *containerVC = stackRecord.pageInfo.viewController;
                if ([containerVC conformsToProtocol:@protocol(MBNavPageContainerProtocol)]) {
                    if ([containerVC respondsToSelector:@selector(mbnav_popN:complete:)]) {
                        [containerVC mbnav_popN:stackRecord.delta complete:^(BOOL result) {
                            MBRouterError(@"MBNav stackManager popN in container result = %d, remain child pages count = %lu", result, stackRecord.pageInfo.innerPages.count);
                            if (completion) {
                                completion(result);
                            }
                            return;
                        }];
                    }
                }
            }
            if(completion) {
                completion(result);
            }
        }];
    }
}

- (NSArray<NSString *> *)getStackHistory {
    NSArray<MBNavPageInfo *> *pageInfoList = [self getAppPageStacks];
    NSMutableArray<NSString *> *pageHistory = [NSMutableArray new];
    for(MBNavPageInfo *pageInfo in pageInfoList) {
        if(pageInfo.innerPages && pageInfo.innerPages.count > 0) {
            for (MBNavContainerInnerPageInfo *innerPageInfo in pageInfo.innerPages) {
                [pageHistory addObject:innerPageInfo.pageUrl];
            }
        } else {
            [pageHistory addObject:pageInfo.routable.originUrlString?:@"UNKNOWN"];
        }
    }
    return pageHistory;
}

- (NSArray<MBNavPageInfo *> *)getAppPageStacks {
    return [self getAppPageStackHistory].stackHistory;
}

#pragma mark - Private Methods

/// 构建页面栈
/// 按照从栈底到栈顶的顺序进行遍历，除UINavigationController和UITabBarController以外，其他嵌套页面只会将外层页面加入到栈中，内层页面不会加入栈中，在使用中需注意。
- (MBNavStackHistory *)getAppPageStackHistory {
    NSMutableArray<MBNavPageInfo *> *pageInfoStack = [NSMutableArray new];
    NSUInteger stackLengthWithInnerPages = 0;
    UIViewController *resultVC;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    if ([window subviews].count == 0) {
        return nil;
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        resultVC = nextResponder;
    } else {
        resultVC = window.rootViewController;
    }
    BOOL isContinue = YES;
    UIViewController *tmpGlobalTopViewController = nil;
    while (isContinue) {
        if (resultVC) {
            if (!resultVC.mbNavPageInfo) {
                resultVC.mbNavPageInfo = [[MBNavPageInfo alloc]initWithViewController:resultVC];
            } else {
                resultVC.mbNavPageInfo.viewController = resultVC;
            }
            MBRouterDebug(@"MBNav stackManager getPageStack add page, vc = %@, url = %@", resultVC.mbNavPageInfo.viewController, resultVC.mbNavPageInfo.routable.originUrlString);
            [pageInfoStack addObject:resultVC.mbNavPageInfo];
            if (resultVC.mbNavPageInfo.innerPages && resultVC.mbNavPageInfo.innerPages.count > 0) {
                stackLengthWithInnerPages += resultVC.mbNavPageInfo.innerPages.count;
            } else {
                stackLengthWithInnerPages += 1;
            }
        }
        if ([resultVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)resultVC;
            // 假设前提条件：UINavigatorController的viewControllers中存在UINavigatorController则其一定是栈顶VC
            if (navController.viewControllers > 0) {
                for (int i = 0; i < navController.viewControllers.count-1; i++) {
                    UIViewController *childVC = navController.viewControllers[i];
                    if (!childVC.mbNavPageInfo) {
                        childVC.mbNavPageInfo = [[MBNavPageInfo alloc]initWithViewController:childVC];
                    } else {
                        childVC.mbNavPageInfo.viewController = childVC;
                    }
                    MBRouterDebug(@"MBNav stackManager getPageStack add page, vc = %@, url = %@", resultVC.mbNavPageInfo.viewController, childVC.mbNavPageInfo.routable.originUrlString);
                    [pageInfoStack addObject:childVC.mbNavPageInfo];
                    if (childVC.mbNavPageInfo.innerPages && childVC.mbNavPageInfo.innerPages.count > 0) {
                        stackLengthWithInnerPages += childVC.mbNavPageInfo.innerPages.count;
                    } else {
                        stackLengthWithInnerPages += 1;
                    }
                }
            }
            if (navController.topViewController) {
                resultVC = navController.topViewController;
            }
            if (navController.presentedViewController) {
                tmpGlobalTopViewController = navController.presentedViewController;
            }
        } else if ([resultVC conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]) {
            id<MBUITabBarControllerProtocol> tabBarController = (id<MBUITabBarControllerProtocol>) resultVC;
            if ([tabBarController respondsToSelector:@selector(selectedViewController)]) {
                resultVC = tabBarController.selectedViewController;
            }
            if ([tabBarController isKindOfClass:UIViewController.class]) {
                UIViewController *realTabBarController = (UIViewController *)tabBarController;
                if (realTabBarController.presentedViewController) {
                    tmpGlobalTopViewController = realTabBarController.presentedViewController;
                }
            }
        } else if ([resultVC isKindOfClass:UITabBarController.class]) {
            resultVC = ((UITabBarController *)resultVC).selectedViewController;
            if (resultVC.presentedViewController) {
                tmpGlobalTopViewController = resultVC.presentedViewController;
            }
        } else {
            if (resultVC.presentedViewController) {
                UIViewController *tempVC = resultVC;
                resultVC = resultVC.presentedViewController;
                if ([resultVC isKindOfClass:[UINavigationController class]]) {
                    if ([(UINavigationController*)resultVC visibleViewController] || [(UINavigationController*)resultVC topViewController]) {
                    } else {
                        resultVC = tempVC;
                        isContinue = NO;
                    }
                }
            }else {
                isContinue = NO;
            }
        }
    }
    MBRouterInfo(@"MBNav stackManager getPageStack, native page count = %lu, all page count = %lu", pageInfoStack.count, stackLengthWithInnerPages);
    MBNavStackHistory *history = [MBNavStackHistory new];
    history.stackHistory = pageInfoStack;
    history.stackLength = stackLengthWithInnerPages;
    return history;
}

- (void)popToViewController:(UIViewController *)popFromViewController currentVC:(UIViewController *)currentVC withKeepVC:(UIViewController *)keepVC destinationPage:(MBNavPageInfo *)pageInfo needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    BOOL isPopFromStackTopVC = YES;
    if (popFromViewController && currentVC && popFromViewController != currentVC) {
        isPopFromStackTopVC = NO;
    }
    // 若页面存在，则pop到该页面
    if (pageInfo.viewController) {
        __block UIViewController *destinationVC = pageInfo.viewController;
        void(^popToVCBlock)(void) = ^(void){
            // 若目标VC为tabBarVC或naviVC则不存在调子页面的情况，不需要修改destinationPage pageInfo中的VC信息。
            // 1.目标页面是tabBarVC，则将tabBarVC的selectedViewController作为目标页面；
            // 2.若目标页面为naviVC，naviVC是presenter出来则直接pop掉naviVC，否则naviVC popToRootViewController;
            // 3.若目标页面为非NaviVC, 找到当前页面最近的navi vc；
            // 4.在navi vc中查找是否存在目标VC或者目标VC的父VC；
            // 5.调用navi vc的popToViewController。
            if ([destinationVC isKindOfClass:UITabBarController.class] || [destinationVC conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]) {
                UIViewController *selectVC = nil;
                if ([destinationVC isKindOfClass:UITabBarController.class]) {
                    UITabBarController *tabBarController = (UITabBarController *)destinationVC;
                    selectVC = tabBarController.selectedViewController;
                } else if ([destinationVC conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]) {
                    id<MBUITabBarControllerProtocol> customTabBarVC = (id<MBUITabBarControllerProtocol>)destinationVC;
                    selectVC = [customTabBarVC selectedViewController];
                }
                destinationVC = selectVC;
            }
            if ([destinationVC isKindOfClass:UINavigationController.class]) {
                if(destinationVC.presentingViewController) {
                    [self executeTransaction:^{
                        [destinationVC dismissViewControllerAnimated:animation completion:^{
                            MBRouterInfo(@"MBNav stackManager popToViewController callback complete, dismiss destination navVC directly");
                            if (completion) {
                                completion(YES);
                            }
                        }];
                    } completion:^{
                        MBRouterInfo(@"MBNav stackManager popToViewController transition callback complete, dismiss destination navVC directly");
                    }];
                    return;
                } else {
                    [self executeTransaction:^{
                        [((UINavigationController *)destinationVC)popToRootViewControllerAnimated:animation];
                    } completion:^{
                        MBRouterInfo(@"MBNav stackManager popToViewController callback complete, destination navVC popToRootViewController directly");
                        if (completion) {
                            completion(YES);
                        }
                    }];
                    return;
                }
            }
            UINavigationController *navVC = [self currentNavi:destinationVC];
            if (navVC) {
                UIViewController *realDestinationVC = [self searchController:destinationVC forViewControllers:navVC.viewControllers];
                if (!realDestinationVC) {
                    MBRouterDebug(@"MBNav stackManager popToViewController, destinationVC isn't a child vc of navi");
                    if (completion) {
                        completion(YES);
                    }
                    return;
                } else {
                    if (realDestinationVC == destinationVC) {
                        MBRouterDebug(@"MBNav stackManager popToViewController, destinationVC is a child vc of navi");
                    } else {
                        MBRouterDebug(@"MBNav stackManager popToViewController, the parant vc of destinationVC is a child vc of navi");
                    }
                    MBRouterInfo(@"MBNav stackManager popToViewController transition start, navVC popToViewController");
                    
                    [self executeTransaction:^{
                        if (isPopFromStackTopVC && !keepVC) {
                            [navVC popToViewController:realDestinationVC animated:animation];
                        } else {
                            UIViewController *realPopFromViewController = [self searchController:popFromViewController forViewControllers:navVC.viewControllers];
                            NSMutableArray *viewControllers =  [navVC.viewControllers mutableCopy];
                            NSArray *originViewControllers =  [navVC.viewControllers copy];
                            BOOL beginRemove = NO;
                            for (NSUInteger vcIndex = originViewControllers.count - 1; vcIndex >= 0; vcIndex --) {
                                UIViewController *childViewController = [originViewControllers objectAtIndex:vcIndex];
                                if (childViewController == realDestinationVC) {
                                    beginRemove = NO;
                                    break;
                                }
                                if (realPopFromViewController?(childViewController == realPopFromViewController): (vcIndex == originViewControllers.count - 1)) {
                                    beginRemove = YES;
                                }
                                if (beginRemove && keepVC != childViewController) {
                                    [viewControllers removeObject:childViewController];
                                    MBRouterInfo(@"MBNav stackManager popToViewController remove viewController = %@, pageUrl = %@", childViewController, childViewController.mbNavPageInfo.topPageUrl);
                                }
                            }
                            navVC.viewControllers = viewControllers;
                        }
                    } completion:^{
                        MBRouterInfo(@"MBNav stackManager popToViewController transition complete, navVC popToViewController");
                        if (completion) {
                            completion(YES);
                        }
                    }];
                }
            } else {
                MBRouterInfo(@"MBNav stackManager popToViewController transition complete, currentNavi can't be found");
                if (completion) {
                    completion(YES);
                }
            }
        };
        if (destinationVC.presentedViewController) {
            // 第一步先dismiss presenter页面
            if (keepVC != destinationVC.presentedViewController && keepVC.parentViewController != destinationVC.presentedViewController) {
                MBRouterInfo(@"MBNav stackManager popToViewController transition, dismiss start, presentedViewController = %@", destinationVC.presentedViewController);
                [destinationVC.presentedViewController dismissViewControllerAnimated:animation completion:^{
                    MBRouterInfo(@"MBNav stackManager popToViewController dismiss presentedViewController complete callback");
                    popToVCBlock();
                }];
            } else {
                popToVCBlock();
            }
        } else {
            popToVCBlock();
        }
    }else {
        MBRouterError(@"MBNav stackManager popToViewController, viewController of matched page is nil");
        if(completion) {
            completion(NO);
        }
    }
}



- (void)popToViewController:(UIViewController *)currentVC destinationPage:(MBNavPageInfo *)pageInfo needPopNav:(BOOL)needPopNav withAnimation:(BOOL)animation completion:(void (^)(BOOL))completion {
    [self popToViewController:nil currentVC:currentVC withKeepVC:nil destinationPage:pageInfo needPopNav:needPopNav withAnimation:animation completion:completion];
}

- (MBNavStackRecord *)findPageInStackWithDelta:(NSInteger)delta stackHistory:(MBNavStackHistory *)history {
    if (delta < 1) {
        return nil;
    }
    MBNavStackHistory *pageStackHistory = history;
    if (pageStackHistory.stackLength <= delta) {
        return nil;
    }
    NSArray<MBNavPageInfo *> *pageStack = pageStackHistory.stackHistory;
    // 从栈顶开始查找pop delta页面应该回退到哪个native页面
    MBNavStackRecord *resultRecord = [MBNavStackRecord new];
    NSUInteger backPageCount = 0;
    for (NSUInteger i = pageStack.count - 1; i >= 0; i--) {
        MBNavPageInfo *pageInfo = pageStack[i];
        NSUInteger pageCountInVC = pageInfo.innerPages.count > 0?pageInfo.innerPages.count:1;
        if (delta - backPageCount < pageCountInVC) {
            resultRecord.pageInfo = pageStack[i];
            resultRecord.index = i;
            resultRecord.delta = delta - backPageCount;
            break;
        }
        backPageCount += pageCountInVC;
    }
    return resultRecord;
}


#pragma mark - Find page in stack

- (NSUInteger)findPageIndexWithRedirect:(id<YMMRouterRoutable>)routable {
    id<YMMRouterRoutable> redirectedRoutable = [[YMMRouterCenter shared]getRedictedUrl:routable];
    return [self findPageIndex:redirectedRoutable];
}

- (NSUInteger)findPageIndex:(id<YMMRouterRoutable>)redirectedRoutable {
    NSArray<MBNavPageInfo *> *pageStack = [self getAppPageStacks];
    for(NSUInteger i = pageStack.count - 1; i >= 0; i--) {
        if ([redirectedRoutable matchToRouter:pageStack[i].routable]) {
            return pageStack.count-1-i ;
        }
    }
    
    return MBNav_Page_NotFound;
}

- (MBNavStackRecord *)findPageInStackWithDeltaForPopN:(NSInteger)delta  {
    MBNavStackHistory *pageStackHistory = [self getAppPageStackHistory];
    // 页面栈底存在类似UITabBarController和UINavigationController容器页面，在pop时需要跳过
    NSUInteger skipPageCount = [MBNavManager shared].navConfig.skipPageCountBottomOfStack;
    if (skipPageCount > 0) {
        if (delta > (pageStackHistory.stackLength - skipPageCount)) {
            delta = pageStackHistory.stackLength - skipPageCount;
        }
    }
    if (pageStackHistory.stackLength <= delta) {
        delta = pageStackHistory.stackLength - 1;
    }
    return [self findPageInStackWithDelta:delta stackHistory:pageStackHistory];
}

- (UINavigationController *)searchNaviControllerInStackHistory:(NSInteger)delta {
    MBNavStackRecord *record = [self findPageInStackWithDeltaForPopN:delta];
    if (record.pageInfo.viewController.navigationController) {
        return record.pageInfo.viewController.navigationController;
    }
    return nil;
}

- (MBNavStackRecord *)findPageInStack:(id<YMMRouterRoutable>)redirectedRoutable {
    MBNavStackRecord *stackRecord = nil;
    NSArray<MBNavPageInfo *> *pageStack = [self getAppPageStacks];
    for(NSInteger i = pageStack.count - 1; i >= 0; i--) {
        stackRecord = [self matchRouterWithPageInfo:redirectedRoutable pageInfo:pageStack[i] index:i];
        if (!stackRecord) {
            // 若需要查找的页面为嵌套页面，页面栈中只有外层页面，在匹配时应拿内层页面的路由信息进行比较
            UIViewController *vc = pageStack[i].viewController;
            if ([vc respondsToSelector:NSSelectorFromString(@"mb_isContainerVC")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"
                BOOL isContainerVC =   [vc performSelector:NSSelectorFromString(@"mb_isContainerVC")];
                if (isContainerVC) {
                    if ([vc respondsToSelector:NSSelectorFromString(@"mb_currentChildVC")]) {
                        UIViewController *childVC = [vc performSelector:NSSelectorFromString(@"mb_currentChildVC")];
                        if (childVC && childVC.mbNavPageInfo) {
                            stackRecord = [self matchRouterWithPageInfo:redirectedRoutable pageInfo:childVC.mbNavPageInfo index:i];
                            stackRecord.pageInfo = pageStack[i];
                        }
                    }
                }
#pragma clang diagnostic pop
            }
        }
        if (stackRecord) {
            break;
        }
    }
    return stackRecord;
}

- (MBNavStackRecord *)matchRouterWithPageInfo:(id<YMMRouterRoutable>)redirectedRoutable pageInfo:(MBNavPageInfo *)pageInfo index:(NSUInteger)index {
    MBNavStackRecord *stackRecord;
    if (pageInfo.innerPages.count <= 0) {
        if ([redirectedRoutable matchToRouter:pageInfo.routable]) {
            MBRouterInfo(@"MBNav stackManager findPageInStack, index = %lu", (unsigned long)index);
            stackRecord = [MBNavStackRecord new];
            stackRecord.pageInfo = pageInfo;
            stackRecord.delta = 0;
        }
    } else {
        for (NSInteger j = pageInfo.innerPages.count - 1; j >= 0; j--) {
            NSString *innerPageUrl = pageInfo.innerPages[j].pageUrl;
            if ([redirectedRoutable.originUrlString isEqualToString:innerPageUrl]) {
                MBRouterInfo(@"MBNav stackManager findPageInStack, index = %lu, delta = %lu", (unsigned long)index, (unsigned long)j);
                stackRecord = [MBNavStackRecord new];
                stackRecord.pageInfo = pageInfo;
                stackRecord.index = index;
                stackRecord.delta = pageInfo.innerPages.count - j - 1;
                break;
            }
        }
    }
    return stackRecord;
}

#pragma mark - Search viewController

- (UIViewController *)getTabBarViewController {
    UIViewController *resultVC;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    if ([window subviews].count == 0) {
        return nil;
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        resultVC = nextResponder;
    } else {
        resultVC = window.rootViewController;
    }
    BOOL isContinue = YES;
    while (isContinue) {
        if ([resultVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)resultVC;
            if (navController.topViewController) {
                resultVC = navController.topViewController;
            }
        } else if ([resultVC conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]) {
            isContinue = NO;
        } else if ([resultVC isKindOfClass:UITabBarController.class]) {
            isContinue = NO;
        } else {
            if (resultVC.presentedViewController) {
                UIViewController *tempVC = resultVC;
                resultVC = resultVC.presentedViewController;
                if ([resultVC isKindOfClass:[UINavigationController class]]) {
                    if ([(UINavigationController*)resultVC visibleViewController] || [(UINavigationController*)resultVC topViewController]) {
                    } else {
                        resultVC = tempVC;
                        isContinue = NO;
                    }
                }
            }else {
                isContinue = NO;
            }
        }
    }
    
    return resultVC;
}

- (UINavigationController *)currentNavi:(UIViewController *)current {
    UINavigationController *result = [self nearestNavi:current];
    if (result && [result isKindOfClass:[UINavigationController class]]) {
        return result;
    }
    UIViewController *tabBarController = [self getTabBarViewController];
    if (tabBarController) {
        UIViewController *navigationController = nil;
        if ([tabBarController isKindOfClass:UITabBarController.class]) {
            navigationController = ((UITabBarController *)tabBarController).selectedViewController;
        } else {
            if ([tabBarController conformsToProtocol:@protocol(MBUITabBarControllerProtocol)]) {
                navigationController = ((id<MBUITabBarControllerProtocol>)tabBarController).selectedViewController;
            }
        }
        if (navigationController && [navigationController isKindOfClass:UINavigationController.class]) {
            return (UINavigationController *)navigationController;
        }
    }
    return nil;
}

// 寻找最近的导航控制器
- (UINavigationController *)nearestNavi:(UIViewController *)current {
    if (current.navigationController) {
        return current.navigationController;
    }
    UIViewController *result = current;
    while (result.presentingViewController) {
        result = result.presentingViewController;
        if (![result isKindOfClass:UINavigationController.class]) {
            if (result.navigationController) {
                result = result.navigationController;
                break;
            }
        } else {
            break;
        }
    }
    if ([result isKindOfClass:UINavigationController.class]) {
        return (UINavigationController *)result;
    } else {
        return nil;
    }
}


- (UIViewController *)searchController:(UIViewController *)viewController forViewControllers:(NSArray<UIViewController *> *)viewControllers {
    if ([viewControllers containsObject:viewController]) {
        return viewController;
    } else {
        UIViewController *resultVC = [self searchParent:viewController viewControllers:viewControllers];
        if (resultVC && [viewControllers containsObject:resultVC]) {
            return resultVC;
        }
    }
    
    return nil;
}

/// 检索父vc
- (UIViewController *)searchParent:(UIViewController *)viewController viewControllers:(NSArray *) viewControllers {
    BOOL isContinue = YES;
    UIViewController *resultVC = viewController;
    while (isContinue) {
        resultVC = resultVC.parentViewController;
        
        if ([viewControllers containsObject:resultVC]) {
            isContinue = NO;
        } else if (resultVC == nil) {
            isContinue = NO;
        } else if (resultVC == viewController || ![resultVC isKindOfClass:[UIViewController class]]) {
            isContinue = NO;
        }
    }
    return resultVC;
}

#pragma mark - Transaction execute

- (void)executeTransaction:(void (^)(void))actionBlock completion:(void(^)(void))completion {
    [CATransaction setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
    [CATransaction begin];
    if (actionBlock) {
        actionBlock();
    }
    [CATransaction commit];
}


#pragma mark - MBUIKitHookViewControllerObserverProrocol

- (void)mb_uiViewController:(UIViewController *)controller viewDidDisappear:(BOOL)animated {
    if ([self isRemove:controller]) {
        [controller mbrouter_onExit];
    }
}

- (void)mb_uiViewController:(UIViewController *)controller viewDidAppear:(BOOL)animated {
    [controller mbrouter_onShow];
}

- (BOOL)isRemove:(UIViewController *)vc {
    if (!vc.parentViewController) {return YES;}
    if ([vc.parentViewController isKindOfClass:[UINavigationController class]]
        && !vc.parentViewController.parentViewController) {
        if (vc.parentViewController == [self getKeyWindow].rootViewController || vc.presentingViewController != nil) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (UIWindow *)getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    } else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

@end
