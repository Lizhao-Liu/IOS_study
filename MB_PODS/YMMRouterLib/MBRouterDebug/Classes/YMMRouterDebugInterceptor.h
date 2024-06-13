//
//  YMMRouterDebugInterceptor.h
//  MBRouterDebug
//
//  Created by Lizhao on 2022/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMMRouterResponse;
@protocol YMMRouterRoutable;

@protocol YMMRouterDebugInterceptorDelegate <NSObject>

- (void)routerInterceptorDidReceiveRequest: (id<YMMRouterRoutable>)request
                                  response: (YMMRouterResponse *)response
                                    atTime: (NSTimeInterval)time
                                  pageName:(NSString *)pageName;
@end

@interface YMMRouterDebugInterceptor : NSObject

@property (nonatomic, weak) id<YMMRouterDebugInterceptorDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
