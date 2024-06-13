//
//  MBAPMCrashHandlerHook.h
//  MBAPMLib
//
//  Created by xp on 2022/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMCrashHandlerHook : NSObject

+ (void)hookBCECrashChecker;

+ (void)hookBCECheckerFrida;

@end

NS_ASSUME_NONNULL_END
