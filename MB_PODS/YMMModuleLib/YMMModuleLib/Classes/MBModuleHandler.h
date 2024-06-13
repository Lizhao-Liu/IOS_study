//
//  MBModuleHandler.h
//  YMMModuleLib
//
//  Created by xp on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBModuleLogLevel) {
    MBModuleLogLevelDebug,
    MBModuleLogLevelInfo,
    MBModuleLogLevelWarn,
    MBModuleLogLevelError
};

@protocol MBModuleHandler <NSObject>

@required
- (void)onModuleLogWithLevel:(MBModuleLogLevel)level message:(NSString * _Nonnull)message extra:(NSDictionary * _Nullable)extraInfo;

@end

NS_ASSUME_NONNULL_END
