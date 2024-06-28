//
//  MBBridgeDebugMonitorLogModel.h
//  MBBridgeLibDebug
//
//  Created by Lizhao on 2022/9/21.
//

#import <Foundation/Foundation.h>
@import MBDebug;

NS_ASSUME_NONNULL_BEGIN

@class YMMPluginRequest;
@class YMMPluginResponse;

@interface MBBridgeDebugMonitorLogModel : NSObject <MBDebugMonitorLogCellObject>

+ (MBBridgeDebugMonitorLogModel *)configWithRequest: (YMMPluginRequest *)request
                                           response: (YMMPluginResponse *)response
                                               time: (NSTimeInterval)time
                                           pageName:(NSString *)pageName;
@end

NS_ASSUME_NONNULL_END
