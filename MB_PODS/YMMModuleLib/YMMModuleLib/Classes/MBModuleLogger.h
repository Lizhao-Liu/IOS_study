//
//  MBModuleLogger.h
//  YMMModuleLib
//
//  Created by xp on 2022/1/10.
//

#import <Foundation/Foundation.h>
#import "MBModuleHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBModuleLogger : NSObject


+ (instancetype)shared;

- (void)startLogHandler:(id<MBModuleHandler>)logHandler;

+ (void)debugLog:(NSString *)message extra:(NSDictionary * _Nullable)extraInfo;

+ (void)infoLog:(NSString *)message extra:(NSDictionary * _Nullable)extraInfo;

+ (void)warnLog:(NSString *)message extra:(NSDictionary * _Nullable)extraInfo;

+ (void)errorLog:(NSString *)message extra:(NSDictionary * _Nullable)extraInfo;

@end

NS_ASSUME_NONNULL_END
