//
//  MBModuleLogger.m
//  YMMModuleLib
//
//  Created by xp on 2022/1/10.
//

#import "MBModuleLogger.h"
@import MBFoundation;

@interface MBModuleLogModel : NSObject {
    
}

@property (nonatomic, assign) MBModuleLogLevel level;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDictionary *extraInfo;

@end

@implementation MBModuleLogModel


@end

@interface MBModuleLogger() {
    dispatch_semaphore_t _cacheLogSemaphore;
}

@property (nonatomic, strong) NSMutableArray<MBModuleLogModel *> *cachedLogs;
@property (nonatomic, weak, nullable) id<MBModuleHandler> logHandler;

@end

@implementation MBModuleLogger

+ (instancetype)shared {
    static MBModuleLogger *logger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [MBModuleLogger new];
    });
    return logger;
}

- (instancetype)init {
    if (self = [super init]) {
        _cacheLogSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)startLogHandler:(id<MBModuleHandler>)logHandler {
    _logHandler = logHandler;
    if (_logHandler && [_logHandler respondsToSelector:@selector(onModuleLogWithLevel:message:extra:)]) {
        [self dispatchCachedLogs];
    }
}

+ (void)debugLog:(NSString *)message extra:(NSDictionary *)extraInfo {
    [[MBModuleLogger shared]logByHandler:MBModuleLogLevelDebug message:message extra:extraInfo];
}

+ (void)infoLog:(NSString *)message extra:(NSDictionary *)extraInfo {
    [[MBModuleLogger shared]logByHandler:MBModuleLogLevelInfo message:message extra:extraInfo];
}

+ (void)warnLog:(NSString *)message extra:(NSDictionary *)extraInfo {
    [[MBModuleLogger shared]logByHandler:MBModuleLogLevelWarn message:message extra:extraInfo];
}

+ (void)errorLog:(NSString *)message extra:(NSDictionary *)extraInfo {
    [[MBModuleLogger shared]logByHandler:MBModuleLogLevelError message:message extra:extraInfo];
}

# pragma mark - property method
- (NSMutableArray<MBModuleLogModel *> *)cachedLogs {
    if (!_cachedLogs) {
        _cachedLogs = [NSMutableArray new];
    }
    return _cachedLogs;
}

#pragma mark - private method

- (void)logByHandler:(MBModuleLogLevel)level message:(NSString *)message extra:(NSDictionary *)extraInfo {
    if (![MBModuleLogger shared].logHandler) {
        NSString *messageWithTimeStamp = [NSString stringWithFormat:@"[%@] %@", [NSDateFormatter mb_stringWithDateWithDate:[NSDate date] format:[NSDate mb_dateFormatSecondSSS]], message];
        [[MBModuleLogger shared]cacheLog:level message:messageWithTimeStamp extra:extraInfo];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[MBModuleLogger shared].logHandler respondsToSelector:@selector(onModuleLogWithLevel:message:extra:)]) {
                [[MBModuleLogger shared].logHandler onModuleLogWithLevel:level message:message extra:extraInfo];
            }
        });
    }
}

- (void)cacheLog:(MBModuleLogLevel)level message:(NSString *)message extra:(NSDictionary *)extraInfo {
    MBModuleLogModel *logModel = [MBModuleLogModel new];
    logModel.level = level;
    logModel.message = message;
    logModel.extraInfo = extraInfo;
    dispatch_semaphore_wait(_cacheLogSemaphore, DISPATCH_TIME_FOREVER);
    [self.cachedLogs addObject:logModel];
    dispatch_semaphore_signal(_cacheLogSemaphore);
}

- (void)dispatchCachedLogs {
    dispatch_semaphore_wait(_cacheLogSemaphore, DISPATCH_TIME_FOREVER);
    for(MBModuleLogModel *model in self.cachedLogs) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MBModuleLogger shared].logHandler onModuleLogWithLevel:model.level message:model.message extra:model.extraInfo];
        });
    }
    [self.cachedLogs removeAllObjects];
    dispatch_semaphore_signal(_cacheLogSemaphore);
}

@end
