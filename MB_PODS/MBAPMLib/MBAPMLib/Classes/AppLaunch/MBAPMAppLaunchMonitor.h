//
//  MBAPMAppLaunchMonitor.h
//  MBAPMLib
//
//  Created by xp on 2020/7/15.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"
#import "MBAPMAppLaunchTimeModel.h"
#import "MBAPMMonitor.h"
@import MBLauncherLib;
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMAppLaunchMonitor : MBAPMPlugin

///开启自定义app启动结束点，此方法必须在applicationDidFinishLaunching方法中或之前调用
+ (void)enableCustomLaunchEnding;

- (void)startAppLaunch:(MBLaunchMode)launchMode launchTags:(NSDictionary *)tags;

- (void)endAppLaunch:(NSString *)endPointName;

- (void)customEndAppLaunch;

- (void)applicationDidFinishLaunch;

- (void)applicationWillFinishLaunch;

- (void)applicationDidBecomeActive;

- (void)applicationWillEnterForeground;

- (void)applicationDidEnterBackground;

- (id<MBAPMEventTimeTrack>)getAppLaunchTrack;

- (MBAPMAppLaunchTimeModel *)getAppLaunchTime;

- (UInt64)getAppLaunchStartTime;

- (void)asyncGetAppLaunchTime:(MBAPMLaunchTimeCallback)callback;


/// 获取启动是否成功状态
- (BOOL)hasLaunchSuccessed;



@end

NS_ASSUME_NONNULL_END
