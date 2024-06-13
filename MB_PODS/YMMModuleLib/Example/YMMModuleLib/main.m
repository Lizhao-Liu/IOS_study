//
//  main.m
//  YMMModuleLib
//
//  Created by knop on 06/14/2018.
//  Copyright (c) 2018 knop. All rights reserved.
//

#import <YMMModuleLib/YMMModuleManager.h>
#import "BeforeLifecycle.h"
#import "AfterLifecycle.h"
#import "TestIntercept.h"

int MBApplicationMain(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, id<MBLifecycleDelegate> _Nullable beforeLifecycle, id<MBLifecycleDelegate> _Nullable afterLifecycle, id<MBInterceptDelegate> _Nullable intercept) {
    [[MBModule shared] setup];
    [MBModule shared].beforeLifecycle = beforeLifecycle;
    [MBModule shared].afterLifecycle = afterLifecycle;
    [MBModule shared].intercept = intercept;
    return UIApplicationMain(argc, argv, nil, NSStringFromClass(MBAppDelegate.class));
}

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return MBApplicationMain(argc, argv, nil,
                                 [[BeforeLifecycle alloc] init],
                                 [[AfterLifecycle alloc] init],
                                 [[TestIntercept alloc] init]);
    }
}

