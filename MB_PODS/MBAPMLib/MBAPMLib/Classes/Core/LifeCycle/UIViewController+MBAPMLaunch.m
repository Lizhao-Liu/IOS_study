//
//  UIViewController+MBAPMLaunch.m
//  MBAPMLib
//
//  Created by xp on 2021/7/6.
//

#import "UIViewController+MBAPMLaunch.h"
#import "MBAPMAppLaunchMonitor.h"
#import <objc/runtime.h>
@import RSSwizzle;


@interface UIViewController(MBAPMLaunch)

@property (nonatomic, assign) BOOL hasLaunched;

@end

@implementation UIViewController(MBAPMLaunch)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RSSwizzleInstanceMethod([UIViewController class], @selector(viewDidAppear:), RSSWReturnType(void), RSSWArguments(BOOL animated), RSSWReplacement({
            RSSWCallOriginal(animated);
            [self mbapm_viewDidAppear];
        }), RSSwizzleModeOncePerClassAndSuperclasses, @"MBAPM_appLaunch_viewDidAppear");
    });
}


- (void)mbapm_viewDidAppear {
    if (self.hasLaunched) {
        return;
    }
    UIViewController *windowRootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (windowRootVC && [windowRootVC isKindOfClass:[UINavigationController class]]) {
        NSArray * viewControllers = ((UINavigationController *)windowRootVC).viewControllers;
        if (viewControllers.count >= 1 && [viewControllers objectAtIndex:viewControllers.count-1] == self) {
            [[MBAPMAppLaunchMonitor shareInstance]endAppLaunch:NSStringFromClass([self class])];
            self.hasLaunched = YES;
            return;
        }
    }
}

#pragma mark Property Methods

- (void)setHasLaunched:(BOOL)hasLaunched {
    objc_setAssociatedObject(self, @selector(hasLaunched), @(hasLaunched), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hasLaunched {
    return [objc_getAssociatedObject(self, @selector(hasLaunched)) boolValue];
}

@end
