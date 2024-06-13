//
//  UIViewController+MBRouter.m
//  YMMRouterLib
//
//  Created by xp on 2022/11/9.
//

#import "UIViewController+MBRouter.h"
#import <objc/runtime.h>


@implementation MBRouterIntent


@end

@interface UIViewController(MBRouter)

@property (nonatomic, strong) MBRouterIntent *mbRouterIntent;


@end

@implementation UIViewController(MBRouter)

- (void)mbrouter_setIntent:(MBRouterIntent *)intent {
    self.mbRouterIntent = intent;
}

- (void)mbrouter_setNewIntent:(MBRouterIntent *)intent {
    self.mbRouterIntent = intent;
    if ([self conformsToProtocol:@protocol(MBRouterNavPageProtocol)]) {
        if ([self respondsToSelector:@selector(mbrouter_onNewIntent:)]) {
            [self performSelector:@selector(mbrouter_onNewIntent:) withObject:intent.params];
        }
    }
}

- (MBRouterIntent *)mbrouter_getIntent {
    if (!self.mbRouterIntent) {
        if ([self.parentViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *parentVC = (UINavigationController *)self.parentViewController;
            if (parentVC.viewControllers.count >= 1 && self == parentVC.viewControllers[0]) {
                return parentVC.mbRouterIntent;
            }
        }
    }
    return self.mbRouterIntent;
}

- (void)mbrouter_setResult:(id)resultData withError:(NSError * _Nullable)error {
    MBRouterIntent *intent = [self mbrouter_getIntent];
    if (intent) {
        intent.resultData = resultData;
    }
}

- (void)mbrouter_onExit {
    MBRouterIntent *intent = [self mbrouter_getIntent];
    if (intent && !intent.hasCallbackResult) {
        if (intent.resultData != nil) {
            if (intent.mbRouterResultBlock) {
                intent.mbRouterResultBlock(nil, intent.resultData);
            }
        }
        if (intent.mbNavResultBlock) {
            intent.mbNavResultBlock(nil, intent.resultData, intent.requestId);
        }
        intent.hasCallbackResult = YES;
        intent.resultData = nil;
    }
}

- (void)mbrouter_onShow {
    if (self.mbRouterIntent) {
        self.mbRouterIntent.hasCallbackResult = NO;
    }
}

#pragma mark - Property Method
- (MBRouterIntent *)mbRouterIntent {
    return objc_getAssociatedObject(self, @selector(mbRouterIntent));
}

- (void)setMbRouterIntent:(MBRouterIntent *)mbRouterIntent {
    objc_setAssociatedObject(self, @selector(mbRouterIntent), mbRouterIntent, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)needCallbackOnResult {
    return objc_getAssociatedObject(self, @selector(needCallbackOnResult));
}

- (void)setNeedCallbackOnResult:(BOOL)needCallbackOnResult {
    objc_setAssociatedObject(self, @selector(needCallbackOnResult), @(needCallbackOnResult), OBJC_ASSOCIATION_ASSIGN);
}


@end
