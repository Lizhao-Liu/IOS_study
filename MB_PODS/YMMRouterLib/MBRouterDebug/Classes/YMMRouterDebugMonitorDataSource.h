//
//  YMMRouterDebugMonitorDataSource.h
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/11/28.
//

#import <Foundation/Foundation.h>


@class MBDebugMonitorLogDataSource;
NS_ASSUME_NONNULL_BEGIN

@interface YMMRouterDebugMonitorDataSource : NSObject

+ (MBDebugMonitorLogDataSource *)sharedDataSource;

@end

NS_ASSUME_NONNULL_END
