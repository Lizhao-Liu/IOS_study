//
//  MBBridgeDebugMonitorService.h
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/9/21.
//

#import <Foundation/Foundation.h>
@import MBDebugService;

NS_ASSUME_NONNULL_BEGIN

@interface MBBridgeDebugMonitorService : NSObject<MBDebugMonitorServiceProtocol>

@end

@interface MBBridgeDebugMonitorManager : NSObject

@property (nonatomic, assign) BOOL isMonitoring;

+ (instancetype)defaultManager;

@end

NS_ASSUME_NONNULL_END

