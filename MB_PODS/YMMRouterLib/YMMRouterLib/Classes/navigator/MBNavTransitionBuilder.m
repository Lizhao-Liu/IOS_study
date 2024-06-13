//
//  MBNavTransitionBuilder.m
//  YMMRouterLib
//
//  Created by xp on 2023/7/24.
//

#import "MBNavTransitionBuilder.h"
#import "MBNavTransitionBuilder_Private.h"
#import "UIViewController+MBRouter.h"

@interface MBNavTransitionBuilder ()

@end

@implementation MBNavTransitionBuilder

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)start {
    if(self.delegate) {
        [self.delegate enqueueTransitionForBuilder:self];
    } else {
        [self.transition start];
    }
}

- (void)start:(MBNavTransitionCompletion)completion {
    self.transition.externalCompletionCallback = completion;
    [self start];
}

- (MBNavBaseTransition *)build {
    if(!self.transition) {
        MBNavBaseTransition *transition = [MBNavTransition new];
        self.transition = transition;
    }
    return self.transition;
}

- (void)root:(UINavigationController *)rootVC {
    self.transition.rootVC = rootVC;
}

- (void)current:(UIViewController *)currentVC {
    self.transition.currentVC = currentVC;
}

- (void)push:(NSString *)url options:(MBNavParameterOptions)options flags:(MBNavParameterFlags)flags params:(NSDictionary *)params {
    MBNavPushAction *action = [MBNavPushAction new];
    action.url = url;
    if (!(options & MBNavParameterOptionsUnAnimated)) {
        options = options | MBNavParameterOptionsAnimated;
    }
    action.options = options;
    action.params = params;
    action.flags = flags;
    [self.transition.actions addObject:action];
}

- (void)pop:(NSUInteger)delta options:(MBNavParameterOptions)options {
    MBNavPopAction *action = [MBNavPopAction new];
    action.delta = delta;
    if (!(options & MBNavParameterOptionsUnAnimated)) {
        options = options | MBNavParameterOptionsAnimated;
    }
    action.options = options;
    MBNavBaseAction *lastAction = self.transition.actions.lastObject;
    NSAssert(self.transition.currentVC, @"if push action exists before pop action, currentVC should be set firstly");
    if ([lastAction isKindOfClass:MBNavPushAction.class]) {
        action.currentVC = self.transition.currentVC;
        ((MBNavPushAction *)lastAction).deltaOfNextPop = delta;
    }
    [self.transition.actions addObject:action];
}

- (void)popUtil:(NSString *)url options:(MBNavParameterOptions)options params:(NSDictionary * __nullable)params{
    MBNavPopUtilAction *action = [MBNavPopUtilAction new];
    action.url = url;
    if (!(options & MBNavParameterOptionsUnAnimated)) {
        options = options | MBNavParameterOptionsAnimated;
    }
    action.options = options;
    action.params = params;
    [self.transition.actions addObject:action];
}

- (void)popKeepN:(NSUInteger)delta options:(MBNavParameterOptions)options {
    
}

- (void)childPages:(NSArray<MBNavContainerInnerPageInfo *> *)childPages {
    MBNavUpdateChildPagesAction *action = [MBNavUpdateChildPagesAction new];
    action.childPages = childPages;
    [self.transition.actions addObject:action];
}

- (void)delay:(int64_t)delta {
    if (self.transition.actions.count > 0 && delta > 0) {
        self.transition.actions.lastObject.delayTime = delta;
    }
}

- (void)popBackResultCallback:(MBNavTransitionOnResultCallback)callback {
    self.transition.onResultCallback = callback;
}

- (void)setResult:(id)data withError:(NSError *)error {
    MBNavSetResultAction *action = [MBNavSetResultAction new];
    action.data = data;
    action.error = error;
    [self.transition.actions addObject:action];
}

- (void)setResult:(id)data withError:(NSError *)error withRequestId:(NSString *)requestId {
    MBNavSetResultAction *action = [MBNavSetResultAction new];
    action.data = data;
    action.error = error;
    action.requestId = requestId;
    [self.transition.actions addObject:action];
}

- (NSString *)transitionRequestId {
    return self.transition.requestId;
}

@end
