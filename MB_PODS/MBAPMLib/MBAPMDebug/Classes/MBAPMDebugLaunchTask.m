//
//  MBChaosLaunchTask.m
//  MBAPMDebug
//
//  Created by xp on 2022/5/31.
//

#import "MBChaosLaunchTask.h"
#import "MBAPMDebugLaunchTask.h"
#import "MBAPMDebugModule.h"

@import MBLauncherLib;
@import MBAPMLib;
@import MBAPMServiceLib;
@import DoraemonKit;
@import MBLauncherLib;
@import MBStorageLib;


@interface APMDebugLeakModel : NSObject <MBAPMMemoryLeakProtocol>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@end

@implementation APMDebugLeakModel

@end


@MBLaunchTaskEX(MBAPMDebugLaunchTask)
@implementation MBAPMDebugLaunchTask
@synthesize taskConfigData;


- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneBasicSDK;
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    
#if TARGET_OS_SIMULATOR
#else
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self delayStartLeakMonitor];
    });
#endif
    // 设置zombie监控是否获取dealloc堆栈
    id stateObj = [[MBStorageManager mbkv]get:@"MBAPMDebugZombieTraceDeallocState"];
    if (stateObj && [stateObj isKindOfClass:NSNumber.class]) {
        BOOL state = ((NSNumber *)stateObj).boolValue;
        [MBAPMZombieSniffer enableTraceDeallocStack:state];
    }
    return YES;
}
 
- (void)delayStartLeakMonitor {
    id<MBAPMServiceProtocol> service = BIND_SERVICE([MBAPMDebugModule getContext], MBAPMServiceProtocol);
    [service addClassNamesToLeaksWhitelist: @[@"UIImagePickerController"]];
}

- (nonnull NSString *)taskName {
    return @"apm_debug";
}



#pragma mark - private method


@end


@MBLaunchTaskEX(MBAPMDebugLaunchHookEnableTask)
@implementation MBAPMDebugLaunchHookEnableTask
@synthesize taskConfigData;


- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneBasicSDK;
}

- (MBLaunchPriority)taskPriority {
    return 996;
}

- (BOOL)runTask:(MBLaunchParams *)params {
    BOOL debugLaunched = [NSUserDefaults.standardUserDefaults  boolForKey:@"MBAPMDebugLaunchHookEnableTaskInit"];
    if (debugLaunched == NO) {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"MBAPMDebugLaunchHookEnableTaskInit"];
        [MBAPMDataCache sharedInstance].cacheEnable = YES;
    }
    
    if (![MBAPMDataCache sharedInstance].cacheEnable) {
        [self disableAllAPM];
    }
    return YES;
}

- (void)disableAllAPM {
    NSLog(@"---------APM-disable--------");
    
    Method originMethod = class_getClassMethod(NSClassFromString(@"MBDeviceInfo"), @selector(canEnableMonitor));
    Method swizzledMethod = class_getClassMethod([self class], @selector(canEnableMonitor));
    
    if (originMethod && swizzledMethod) {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}


+ (BOOL)canEnableMonitor {
    NSLog(@"---------canEnableMonitor--------");
    return NO;
}

- (nonnull NSString *)taskName {
    return @"apm_debug_hook_enable";
}
@end
