//
//  MBLaunchTaskDebugView.m
//  MBDebug
//
//  Created by xp on 2021/9/14.
//

#import "MBLaunchTaskDebugView.h"
#import "MBDebugEntryManager.h"
@import MBLauncherLib;

@MBLaunchTaskEX(MBLaunchTaskDebugView)

@interface MBLaunchTaskDebugView() <MBLaunchTask>

@end

@implementation MBLaunchTaskDebugView


- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneHome;
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        [[MBDebugEntryManager sharedMBDebugEntryManager] initDebugWindow];
        
    });
    return YES;
}

- (nonnull NSString *)taskName {
    return @"debug_view";
}

- (MBLaunchMode)executeInMode {
    return MBLaunchModeNormal;
}

@end
