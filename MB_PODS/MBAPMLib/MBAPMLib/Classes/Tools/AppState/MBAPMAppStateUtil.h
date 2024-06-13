//
//  MBAPMAppStateUtil.h
//  MBAPMLib
//
//  Created by xp on 2022/6/7.
//

#import <Foundation/Foundation.h>
@import MMKV;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMAppStateUtil : NSObject
// current
@property (nonatomic, assign, readonly) UInt64 launchStartTime;
@property (nonatomic, assign, readonly) UIApplicationState applicationState;
@property (nonatomic, assign, readonly) BOOL isJail;
@property (nonatomic, assign, readonly) UInt64 appRunTime;

// last
@property (nonatomic, assign, readonly) UInt64 lastLaunchAppRunTime;
@property (nonatomic, assign, readonly) UInt64 lastLaunchStartTime;
@property (nonatomic, assign, readonly) UInt64 lastLaunchEndTime;
@property (nonatomic, strong, readonly) NSString *lastLaunchId;
@property (nonatomic, assign, readonly) UIApplicationState lastLaunchApplicationState;
// 记录上次启动的crash是否上报过，app进程周期有效，默认false
@property (nonatomic, assign) BOOL lastLaunchCrashReported;

+ (instancetype)shared;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

// 执行 config 会设置 current 信息
- (void)configAppLaunchWithId:(NSString *)currentLaunchId;
// 调用更新，用于更新 AppEndTime 等
- (void)updateAppAliveInfo;
// 调用更新，用于更新 ApplicationState
- (void)updateApplicationState;

@end

NS_ASSUME_NONNULL_END

