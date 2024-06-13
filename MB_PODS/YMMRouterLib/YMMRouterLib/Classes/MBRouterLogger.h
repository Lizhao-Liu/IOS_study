//
//  MBRouterLogger.h
//  YMMRouterLib
//
//  Created by xp on 2022/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define MBRouterLog(alevel, FORMAT, ...) \
[MBRouterLogger appendLog:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__, nil] level:alevel function:__FUNCTION__ line:__LINE__];\

#define MBRouterDebug(...)                  MBRouterLog(MBRouterLogLevelDebug, __VA_ARGS__)
#define MBRouterInfo(...)                   MBRouterLog(MBRouterLogLevelInfo,  __VA_ARGS__)
#define MBRouterWarning(...)                MBRouterLog(MBRouterLogLevelWarning,  __VA_ARGS__)
#define MBRouterError(...)                  MBRouterLog(MBRouterLogLevelError,  __VA_ARGS__)
#define MBRouterFatal(...)                  MBRouterLog(MBRouterLogLevelFatal,  __VA_ARGS__)

typedef NS_ENUM(NSUInteger, MBRouterLogLevel) {
    MBRouterLogLevelDebug = 0,
    MBRouterLogLevelInfo = 1,
    MBRouterLogLevelWarning = 2,
    MBRouterLogLevelError = 3,
    MBRouterLogLevelFatal = 4
};

@interface MBRouterLogger : NSObject


+ (void)appendLog:(NSString *)log level:(MBRouterLogLevel)level function:(const char *)func line:(int)line;

@end

NS_ASSUME_NONNULL_END
