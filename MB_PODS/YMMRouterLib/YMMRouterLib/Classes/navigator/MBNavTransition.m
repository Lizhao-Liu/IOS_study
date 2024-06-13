//
//  MBNavTransition.m
//  YMMRouterLib
//
//  Created by xp on 2023/7/25.
//

#import "MBNavTransition.h"
#import "YMMRouterCenter.h"
#import "YMMRouterResponse.h"
#import "MBNavStackManager.h"
#import "UIViewController+MBNav.h"
#import "YMMRouterRequest.h"
#import "MBRouterLogger.h"
#import "MBNavManager_Private.h"
#import "UIViewController+MBRouter.h"
#import "YMMRouterRequest+MBNav.h"
@import MBUIKit;
@import MBFoundation;

static NSString * const kMBNavRouterParamViewHeight = @"viewHeight";

@implementation MBNavBaseAction


@end

@implementation MBNavPushAction


@end

@implementation MBNavPopAction


@end

@implementation MBNavPopUtilAction


@end

@implementation MBNavPopKeepAction


@end

@implementation MBNavUpdateChildPagesAction


@end

@implementation MBNavSetResultAction


@end



@implementation MBNavBaseTransition

- (instancetype)init {
    if (self = [super init]) {
        _nextIndex = 0;
        _hasFinished = NO;
        _actions = [NSMutableArray new];
        _requestId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (void)start {
    MBRouterInfo(@"MBNav transition start");
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionWillStart:)]) {
        [self.delegate transitionWillStart:self];
    }
    if (self.actions.count == 0 || (_nextIndex < 0 || _nextIndex >= self.actions.count)) {
        [self finish: NO];
        return;
    }
    [self startTimer];
    [self runAction];
}

- (void)runAction {
    MBRouterInfo(@"MBNav transition runAction index = %lu", _nextIndex);
    MBNavBaseAction *action = [self.actions objectAtIndex:_nextIndex];
    if (action.delayTime > 0) {
        MBRouterInfo(@"MBNav transition action delay time = %llu", action.delayTime);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, action.delayTime * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [self executeAction:action complete:^(BOOL result, BOOL updateCurrentVC) {
                [self nextAction:updateCurrentVC];
            }];
        });
    } else {
        [self executeAction:action complete:^(BOOL result, BOOL updateCurrentVC) {
            [self nextAction:updateCurrentVC];
        }];
    }
}

- (void)executeAction:(MBNavBaseAction *)action complete:(nonnull void (^)(BOOL, BOOL))completion{
    NSAssert(YES, @"executeAction should be override by child class");
}

#pragma mark - Private Methods

- (void)startTimer {
    MB_WEAKIFY(self);
    self.timeoutTimer = [NSTimer mb_scheduledTimerWithTimeInterval:[MBNavManager shared].navConfig.navTransitionTimeoutInterval repeats:NO completion:^(NSTimer * _Nonnull timer) {
        MB_STRONGIFY(self);
        [self finish:YES];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timeoutTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
}


- (void)nextAction:(BOOL)needUpdateCurrentVC {
    _nextIndex++;
    if (_nextIndex >= self.actions.count) {
        [self finish:NO];
        return;
    }
    // 在执行组合命令时，currentVC会发生变化
    if (needUpdateCurrentVC) {
        _currentVC = [[MBNavStackManager shared]getCurrentViewController];
        MBRouterInfo(@"MBNav transition nextAction currentVC = %@", _currentVC);
    }
    [self runAction];
}

- (void)finish:(BOOL)isTimeout {
    if (_hasFinished) {
        MBRouterInfo(@"MBNav transition has finished isTimeout = %d", isTimeout);
    }
    MBRouterInfo(@"MBNav transition finish isTimeout = %d", isTimeout);
    [self stopTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(transitionDidComplete:)]) {
        [self.delegate transitionDidComplete:self];
    }
    if (self.externalCompletionCallback) {
        self.externalCompletionCallback();
    }
}

- (void)dealloc {
    MBRouterDebug(@"MBNav transition dealloc");
}

@end

@implementation MBNavTransition

- (void)executeAction:(MBNavBaseAction *)action complete:(nonnull void (^)(BOOL result, BOOL updateCurrentVC))completion{
    void(^runActionBlock)(void) = ^(void){
        if ([action isKindOfClass:MBNavPushAction.class]) {
            MBNavPushAction *pushAction = (MBNavPushAction *)action;
            NSString *urlString = pushAction.url;
            __weak UIViewController *curVC = self.currentVC;
            MBNavTransitionOnResultCallback onResultCallback = ^(NSError *error, id data, NSString *requestId) {
                if (self.onResultCallback) {
                    self.onResultCallback(error, data, requestId);
                }
                if ([curVC conformsToProtocol:@protocol(MBRouterNavPageProtocol)]) {
                    id<MBRouterNavPageProtocol> navPage = (id<MBRouterNavPageProtocol>)curVC;
                    if ([navPage respondsToSelector:@selector(mbrouter_onResult:withError:withRequestId:)]) {
                        [navPage mbrouter_onResult:data withError:error withRequestId:requestId];
                    }
                }
                if ([curVC conformsToProtocol:@protocol(MBNavPageContainerProtocol)]) {
                    id<MBNavPageContainerProtocol> navContainerPage = (id<MBNavPageContainerProtocol>)curVC;
                    if ([navContainerPage respondsToSelector:@selector(mbnav_onResult:withError:withRequestId:)]) {
                        [navContainerPage mbnav_onResult:data withError:error withRequestId:requestId];
                    }
                }
            };
            YMMRouterRequest *request = [[YMMRouterRequest alloc]initWithURLString:urlString params:pushAction.params requestId:self.requestId navHandleBlock:^(NSError * _Nullable error, id  _Nullable data, NSString * _Nullable requestId) {
                MBRouterInfo(@"MBNav transition router handleBlock requestId = %@ data = %@", requestId, data);
                if (onResultCallback) {
                    onResultCallback(error, data, requestId);
                }
            }];
            if (!request) {
                if (completion) {
                    completion(NO, NO);
                }
                return;
            }
            
            MB_WEAKIFY(self);
            [[YMMRouterCenter shared]perform:request completion:^(YMMRouterResponse *response) {
                if (response.result && [response.result isKindOfClass:UIViewController.class]) {
                    UIViewController *viewController = response.result;
                    if (pushAction.options & MBNavParameterOptionsModal || [viewController isKindOfClass:UINavigationController.class]) {
                        MB_STRONGIFY(self);
                        UIViewController *destinationVC = nil;
                        if (pushAction.options & MBNavParameterOptionsPushWithNav && ![viewController isKindOfClass:UINavigationController.class]) {
                            destinationVC = [[MBNewNavigationViewController alloc]initWithRootViewController:viewController];
                        } else {
                            destinationVC = viewController;
                        }
                        if (pushAction.options & MBNavParameterOptionsTransparent) {
                            destinationVC.providesPresentationContextTransitionStyle = YES;
                            destinationVC.definesPresentationContext = YES;
                            destinationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        }
                        UIViewController *currentVC = self.currentVC?:[UIViewController mb_currentViewController];
                        MBRouterInfo(@"MBNav transition push action presenter url = %@, options = %lu, params = %@", urlString, pushAction.options, pushAction.params);
                        CGFloat viewHeight = -1;
                        id viewHeightObj = [pushAction.params objectForKey:kMBNavRouterParamViewHeight];
                        if (viewHeightObj && [viewHeightObj isKindOfClass:NSNumber.class]) {
                            viewHeight = ((NSNumber *)viewHeightObj).floatValue;
                        }
                        [[MBNavStackManager shared]presenter:destinationVC currentVC:currentVC viewHeight:viewHeight withAnimation:pushAction.options & MBNavParameterOptionsAnimated  completion:^() {
                            if (completion) {
                                if (pushAction.deltaOfNextPop != 0) {
                                    self.popKeepVC = destinationVC;
                                    completion(YES, YES);
                                } else {
                                    completion(YES, NO);
                                }
                            }
                        }];
                    } else {
                        if (pushAction.deltaOfNextPop == 0) {
                            UIViewController *currentVC = self.currentVC?:[UIViewController mb_currentViewController];
                            MBRouterInfo(@"MBNav transition push action push url = %@, options = %lu, params = %@", urlString, pushAction.options, pushAction.params);
                            [[MBNavStackManager shared]push:viewController currentVC: currentVC withAnimation:pushAction.options & MBNavParameterOptionsAnimated  completion:^(BOOL result) {
                                if (completion) {
                                    completion(YES, YES);
                                }
                            }];
                        } else {
                            // 在presenter navi出来在pushAndPop的场景下，例如：nav1->push->页面A->push->页面B->present->nav2->push->页面C->push->页面D->pop页面C和B, 因为pop之后会将present出来的VCdismiss掉，页面D也会被dismiss掉，所以改为将D直接push到nav1上面。
                            UINavigationController *pushInNavVC = [[MBNavStackManager shared]searchNaviControllerInStackHistory:pushAction.deltaOfNextPop];
                            UIViewController *navTopVC = pushInNavVC.topViewController;
                            [[MBNavStackManager shared]pushWithNavi:viewController navVC:pushInNavVC withAnimation:NO completion:^(BOOL result) {
                                self.popFromVC = navTopVC;
                                self.popKeepVC = viewController;
                                if (completion) {
                                    completion(YES, YES);
                                }
                            }];
                        }
                    }
                } else {
                    if (completion) {
                        completion(NO, NO);
                    }
                }
            }];
        } else if ([action isKindOfClass:MBNavPopAction.class]) {
            MBNavPopAction *popAction = (MBNavPopAction *)action;
            MBRouterInfo(@"MBNav transition pop action delta = %lu, options = %lu", popAction.delta, popAction.options);
//            [[MBNavStackManager shared] popN:popAction.delta withCurrentVC:self.currentVC needPopNav:popAction.options & MBNavParameterOptionsPopNav withAnimation:popAction.options & MBNavParameterOptionsAnimated completion:^(BOOL result) {
//
//            }];
            [[MBNavStackManager shared] popN:popAction.delta fromVC:self.popFromVC?:action.currentVC withCurrentVC:self.currentVC withKeepVC:self.popKeepVC needPopNav:popAction.options & MBNavParameterOptionsPopNav withAnimation:popAction.options & MBNavParameterOptionsAnimated completion:^(BOOL result) {
                if (completion) {
                    completion(YES, YES);
                }
            }];
        } else if ([action isKindOfClass:MBNavUpdateChildPagesAction.class]) {
            MBNavUpdateChildPagesAction *childPagesAction = (MBNavUpdateChildPagesAction *)action;
            NSArray<MBNavContainerInnerPageInfo *> *childPages = childPagesAction.childPages;
            if (!self.currentVC.mbNavPageInfo) {
                self.currentVC.mbNavPageInfo = [[MBNavPageInfo alloc]initWithViewController:self.currentVC];
            } else {
                self.currentVC.mbNavPageInfo.viewController = self.currentVC;
            }
            self.currentVC.mbNavPageInfo.innerPages = [NSMutableArray arrayWithArray:childPages];
            MBRouterInfo(@"MBNav transition updateChildPages action, childPages = %@", childPages);
            if (completion) {
                completion(YES, YES);
            }
        } else if ([action isKindOfClass:MBNavPopUtilAction.class]) {
            MBNavPopUtilAction *popUtilAction = (MBNavPopUtilAction *)action;
            NSString *url = popUtilAction.url;
            MBNavTransitionOnResultCallback onResultCallback = self.onResultCallback;
            MBRouterInfo(@"MBNav transition popUtil action url = %@, options = %lu, params = %@", url, popUtilAction.options, popUtilAction.params);
            YMMRouterRequest *request = [[YMMRouterRequest alloc]initWithURLString:url params:popUtilAction.params requestId:self.requestId navHandleBlock:^(NSError * _Nullable error, id  _Nullable data, NSString * _Nullable requestId) {
                if (onResultCallback) {
                    onResultCallback(error, data, requestId);
                }
            }];
            if (!request) {
                MBRouterInfo(@"MBNav transition popUtil action url is illigal");
                if (completion) {
                    completion(YES, YES);
                }
            } else {
                [[MBNavStackManager shared]popUtil:popUtilAction.currentVC?:self.currentVC routable:request needPopNav:popUtilAction.options & MBNavParameterOptionsPopNav withAnimation: popUtilAction.options & MBNavParameterOptionsAnimated completion:^(BOOL isSuccess) {
                    if (completion) {
                        completion(isSuccess, YES);
                    }
                }];
            }
        } else if ([action isKindOfClass:MBNavPopKeepAction.class]) {
//            MBNavPopKeepAction *popKeepAction = (MBNavPopKeepAction *)action;
            // TODO
            
        } else if ([action isKindOfClass:MBNavSetResultAction.class]) {
            MBNavSetResultAction *setResultAction = (MBNavSetResultAction *)action;
            [self.currentVC mbrouter_setResult:setResultAction.data withError:setResultAction.error];
            if (completion) {
                completion(YES, NO);
            }
        }
    };
    runActionBlock();
}


@end
