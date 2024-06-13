//
//  MBChaosLaunchTask.m
//  MBAPMDebug
//
//  Created by xp on 2022/5/6.
//

#import "MBChaosLaunchTask.h"
#import "MBAPMDebug-Swift.h"
#import "MBChaosCrashIssueOC.h"
#import "MBAPMDebugModule.h"

@import MBLauncherLib;
@import MBFoundation;
@import MBConfigCenterService;

@MBLaunchTaskEX(MBChaosLaunchTask)
@implementation MBChaosLaunchTask
@synthesize taskConfigData;


- (MBLaunchScene)executeAtScene {
    return MBLaunchSceneHome;
}

- (BOOL)runTask:(nonnull MBLaunchParams *)params {
    id<MBChaosIssueProtocol> chaosIssue = [MBChaosCrashIssueOC new];
    [chaosIssue triggerIssue];
    return YES;
}

- (nonnull NSString *)taskName {
    return @"chaos";
}

- (MBLaunchPriority)taskPriority {
    return [self taskPriorityFromConfig];
}

- (BOOL)taskEnable:(MBLaunchParams *)params {
    return [self taskEnableFromConfig];
}

#pragma mark - private method

- (BOOL)taskEnableFromConfig {
   BOOL taskEnable = [NSDictionary boolValueWithDictionary:self.taskConfigData forKey:@"isEnable" default:NO];
    id<MBConfigCenterProtocol> configCenter = GET_SERVICE(MBAPMDebugModule.class, MBConfigCenterProtocol);
    BOOL enableCrash  = @([configCenter getIntegerConfig:@"other" key:@"safe_mode_trigger_crash" defaultValue:0]).boolValue;
    return taskEnable | enableCrash;
}

- (NSUInteger)taskPriorityFromConfig {
    return [NSDictionary unsignedIntegerValueWithDictionary:self.taskConfigData forKey:@"priority" default:1];
}


@end
