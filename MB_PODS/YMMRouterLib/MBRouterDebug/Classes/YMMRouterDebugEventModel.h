//
//  YMMRouterDebugEventModel.h
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import <Foundation/Foundation.h>
@import MBDebug;

NS_ASSUME_NONNULL_BEGIN
@class YMMRouterResponse;
@protocol YMMRouterRoutable;

@interface YMMRouterDebugEventModel : NSObject <MBDebugMonitorLogCellObject>

+ (YMMRouterDebugEventModel *)configWithRequest: (id<YMMRouterRoutable>)request
                                       response: (YMMRouterResponse *)response
                                           time: (NSTimeInterval)time
                                       pageName:(NSString *)pageName;

@end

NS_ASSUME_NONNULL_END
