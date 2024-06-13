//
//  YMMRouterDebugEventMonitorManager.h
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMMRouterDebugEventModel;

@interface YMMRouterDebugEventMonitorManager : NSObject

+ (YMMRouterDebugEventMonitorManager *)sharedInstance;
- (void)startMonitorRouterEvent;
- (void)stopMonitorRouterEvent;
@property (nonatomic, assign) BOOL isMonitoring;

@end

NS_ASSUME_NONNULL_END
