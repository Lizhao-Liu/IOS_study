//
//  MBAPMCrashHandlerHook.m
//  MBAPMLib
//
//  Created by xp on 2022/6/8.
//

#import "MBAPMCrashHandlerHook.h"
#import "MBAPMLogDef.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation MBAPMCrashHandlerHook

+ (void)hookBCECrashChecker {
    MBAPMLogInfo(@"hookBCECrashChecker");
    Class handlerClass = NSClassFromString(@"BCECheckerCrash");
    if (!handlerClass) {
        return;
    }
    RSSwizzleInstanceMethod(handlerClass, @selector(installExceptionHandler), RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
        MBAPMWarning(@"BCECrashChecker installExceptionHandler");
//        RSSWCallOriginal();
    }), RSSwizzleModeOncePerClassAndSuperclasses, @"MBAPM_BCECheckerCrash_installExceptionHandler");
}

+ (void)hookBCECheckerFrida {
    MBAPMLogInfo(@"hookBCECheckerFrida");
    Class handlerClass = NSClassFromString(@"BCECheckerFrida");
    if (!handlerClass) {
        return;
    }
    RSSwizzleInstanceMethod(handlerClass, @selector(check), RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
        MBAPMWarning(@"BCECheckerFrida check");
//        RSSWCallOriginal();
    }), RSSwizzleModeOncePerClassAndSuperclasses, @"MBAPM_BCECheckerFrida_check");
}
@end
