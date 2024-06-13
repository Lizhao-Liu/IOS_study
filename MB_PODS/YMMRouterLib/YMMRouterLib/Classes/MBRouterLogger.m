//
//  MBRouterLogger.m
//  YMMRouterLib
//
//  Created by xp on 2022/8/15.
//

#import "MBRouterLogger.h"
#import "YMMRouterConfigManager.h"

@implementation MBRouterLogger

+ (void)appendLog:(NSString *)log level:(MBRouterLogLevel)level function:(const char *)func line:(int)line {
    NSString *formatedString = [NSString stringWithFormat:@"[%@ %d] %@", [NSString stringWithCString:func != NULL?func:"" encoding:NSUTF8StringEncoding], line, log];
    MBRouterLogHandler logHandler = [YMMRouterConfigManager getLogHandler];
    if (logHandler) {
        logHandler(level, formatedString);
    }
}


@end
