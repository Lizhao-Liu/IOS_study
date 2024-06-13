//
//  MBNavManager.m
//  YMMRouterLib
//
//  Created by xp on 2023/7/24.
//

#import "MBNavManager.h"
#import "MBNavTransitionBuilder_Private.h"
#import "MBNavManager_Private.h"
#import "MBNavStackManager.h"
#import "YMMRouterCenter.h"
#import "MBNavRouterInterceptor.h"
#import "YMMRouter+SetResult.h"
#import "MBRouterLogger.h"
@import MBUIKit;

@implementation MBNavManagerConfig

- (instancetype)init {
    if (self = [super init]) {
        _enableRouterInterceptor = NO;
        _navTransitionTimeoutInterval = 5;
    }
    return self;
}


@end

@interface MBNavManager() <MBNavTransitionBuilderDelegate, MBNavTransitionDelegate>

@end

static BOOL _isInitialized = NO;

@implementation MBNavManager

+ (void)setup:(MBNavManagerConfig *)config {
    if (config.enableRouterInterceptor) {
        [[YMMRouterCenter shared]addInterceptor:[MBNavRouterInterceptor new]];
    }
    [[YMMRouterCenter shared]addInterceptor:[MBRouterResultInterceptor new]];
    [MBNavManager shared].navConfig = config;
    MBUIKitHookControllerAddObserver([MBNavStackManager shared]);
    _isInitialized = YES;
}


+ (instancetype)shared {
    static MBNavManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MBNavManager new];
    });
    return instance;
}

- (MBNavTransitionBuilder *)transition {
    NSAssert(_isInitialized, @"setup function should be called firstly");
    MBNavTransitionBuilder *builder = [MBNavTransitionBuilder new];
    [builder build];
    builder.delegate = self;
    return builder;
}

- (NSArray<MBNavPageInfo *> *)getAppPageStacks {
    NSAssert(_isInitialized, @"setup function should be called firstly");
    return [[MBNavStackManager shared]getAppPageStacks];
}

- (NSArray<NSString *> *)getStackHistory {
    return [[MBNavStackManager shared]getStackHistory];
}

#pragma mark - MBNavTransitionDelegate

- (void)transitionWillStart:(MBNavBaseTransition *)transition {
    MBRouterInfo(@"MBNav transitionWillStart %p", &transition);
}

- (void)transitionDidComplete:(MBNavBaseTransition *)transition {
    MBRouterInfo(@"MBNav transitionDidComplete %p", &transition);
    self.currentTransition = nil;
    [self dequeueTransition];
}


#pragma mark - MBNavTransitionBuilderDelegate

- (void)enqueueTransitionForBuilder:(MBNavTransitionBuilder *)transitionBuilder {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (transitionBuilder) {
            MBRouterInfo(@"MBNav enqueue transitionBuild");
            [self.transitionQueue insertObject:transitionBuilder atIndex:0];
        }
        [self dequeueTransition];
    });
}


#pragma mark - Private Method
- (void)dequeueTransition {
    if (self.transitionQueue.count <= 0 || self.isTransitioning) {
        MBRouterWarning(@"MBNav executeTransition queue count = %ld, state = %d", self.transitionQueue.count, self.isTransitioning);
        return;
    }
    MBNavTransitionBuilder *builder = self.transitionQueue.lastObject;
    [self.transitionQueue removeLastObject];
    self.currentTransition = builder.transition;
    self.currentTransition.delegate = self;
    MBRouterInfo(@"MBNav transition start %p", self.currentTransition);
    [self.currentTransition start];
}


#pragma mark - Property Method

- (NSMutableArray<MBNavTransitionBuilder *> *)transitionQueue {
    if (!_transitionQueue) {
        _transitionQueue = [NSMutableArray new];
    }
    return _transitionQueue;
}

- (BOOL)isTransitioning {
    return self.currentTransition != nil;
}

@end
