//
//  MBAPMDebugMonitorService.h
//  MBAPMDebug
//
//  Created by Lizhao on 2023/8/10.
//

#import <Foundation/Foundation.h>
@import MBDebugService;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDebugMonitorService : NSObject<MBDebugMonitorServiceProtocol>

@end

@interface MBAPMDebugMonitorManager : NSObject

@property (nonatomic, assign) BOOL isMonitoring;

+ (instancetype)defaultManager;

@end


NS_ASSUME_NONNULL_END
