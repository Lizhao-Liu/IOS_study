//
//  YMMRouterConfigManager.m
//  YMMRouterLib
//
//  Created by xp on 2021/3/22.
//

#import "YMMRouterConfigManager.h"

@implementation YMMRouterConfig

- (instancetype)init {
    if (self = [super init]) {
        _useNewURLEncodeFunction = YES;
        _encodeParamInUrlString = YES;
        _encodeParamInOriginUrlString = YES;
    }
    return self;
}



@end



@implementation YMMRouterConfigManager

static YMMRouterConfig *configInstance;
+ (void)setConfig:(YMMRouterConfig *)config {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configInstance = config;
    });
}

+ (YMMRouterConfig *)getConfig {
    return configInstance;
}

+ (BOOL)useOldRequestUrlstringFunction {
    return configInstance?configInstance.useOldRequestUrlstringFunction:NO;
}

+ (MBRouterLogHandler)getLogHandler {
    return configInstance?configInstance.logHandler:nil;
}

+ (BOOL)useNewURLEncodeFunction {
    return configInstance?configInstance.useNewURLEncodeFunction:YES;
}

@end
