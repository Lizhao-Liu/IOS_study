//
//  UIApplication+MBAPMHook.m
//  MBAPMLib
//
//  Created by xp on 2020/7/27.
//

#import "UIApplication+MBAPMHook.h"
#import <RSSwizzle/RSSwizzle.h>
#import "MBAPMAppLaunchMonitor.h"
#import "MBAPMCrashMonitor.h"
#import "MBAPMLogDef.h"
#import "MBAPMTimeUtil.h"
#import "MBAPMAppStateUtil.h"

static long long sMBAPMLoadStartTime = 0;

@implementation UIApplication(MBAPMHook)

+ (void)load {
    sMBAPMLoadStartTime = [MBAPMTimeUtil currentTimestamp];
    static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          RSSwizzleInstanceMethod(self, @selector(setDelegate:), RSSWReturnType(void), RSSWArguments(id<UIApplicationDelegate> delegate), RSSWReplacement({
              RSSWCallOriginal(delegate);
              [self mb_applicationSetDelegate:delegate];
          }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBAPMHook_setDelegate:");
      });
}

- (void)mb_applicationSetDelegate:(id<UIApplicationDelegate>)delegate {
    //  swizzle system methods
    NSAssert([delegate respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)], @"app 没有实现application:willFinishLaunchingWithOptions:方法");
    RSSwizzleInstanceMethod([delegate class], @selector(application:willFinishLaunchingWithOptions:), RSSWReturnType(BOOL), RSSWArguments(UIApplication *application,NSDictionary *launchOptions), RSSWReplacement({
        [application mbapm_application:application willFinishLaunchingWithOptions:launchOptions];
        BOOL result = RSSWCallOriginal(application,launchOptions);
        return result;
    }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBAPMHook_application:willFinishLaunchingWithOptions:");
    NSAssert([delegate respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)], @"app 没有实现application:didFinishLaunchingWithOptions:方法");
    RSSwizzleInstanceMethod([delegate class], @selector(application:didFinishLaunchingWithOptions:), RSSWReturnType(BOOL), RSSWArguments(UIApplication *application,NSDictionary *launchOptions), RSSWReplacement({
        BOOL result = RSSWCallOriginal(application,launchOptions);
        [application mbapm_application:application didFinishLaunchingWithOptions:launchOptions];
        return result;
    }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBAPMHook_application:didFinishLaunchingWithOptions:");
    
    RSSwizzleInstanceMethod([delegate class], @selector(applicationWillEnterForeground:), RSSWReturnType(void), RSSWArguments(UIApplication *application), RSSWReplacement({
        [application mbapm_applicationWillEnterForeground:application];
        RSSWCallOriginal(application);
    }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBAPMHook_applicationWillEnterForeground:");
    
    RSSwizzleInstanceMethod([delegate class], @selector(applicationDidEnterBackground:), RSSWReturnType(void), RSSWArguments(UIApplication *application), RSSWReplacement({
        [application mbapm_applicationDidEnterBackground:application];
        RSSWCallOriginal(application);
    }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBAPMHook_applicationWillEnterBackground:");
    
    RSSwizzleInstanceMethod([delegate class], @selector(applicationDidBecomeActive:), RSSWReturnType(void), RSSWArguments(UIApplication *application), RSSWReplacement({
        RSSWCallOriginal(application);
        [application mbapm_applicationDidBecomeActive:application];
    }), RSSwizzleModeOncePerClassAndSuperclasses,@"MBAPMHook_applicationDidBecomeActive:");
}

- (void)mbapm_application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[MBAPMAppLaunchMonitor shareInstance]applicationWillFinishLaunch];
}

- (void)mbapm_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[MBAPMAppLaunchMonitor shareInstance]applicationDidFinishLaunch];
}

- (void)mbapm_applicationWillEnterForeground:(UIApplication *)application {
    [[MBAPMAppLaunchMonitor shareInstance]applicationWillEnterForeground];
    [[MBAPMAppStateUtil shared]updateApplicationState];
}

- (void)mbapm_applicationDidEnterBackground:(UIApplication *)application {
    [[MBAPMAppLaunchMonitor shareInstance]applicationDidEnterBackground];
    [[MBAPMAppStateUtil shared]updateApplicationState];
}

- (void)mbapm_applicationDidBecomeActive:(UIApplication *)application {
    [[MBAPMAppLaunchMonitor shareInstance]applicationDidBecomeActive];
    [[MBAPMAppStateUtil shared]updateApplicationState];
}






@end
