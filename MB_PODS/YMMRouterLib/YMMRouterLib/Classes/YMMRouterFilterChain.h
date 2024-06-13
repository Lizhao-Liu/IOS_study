//
//  YMMRouterFilterChain.h
//  Pods-YMMRouterLib_Tests
//
//  Created by Xiaohui on 2019/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMMRouterResponse;
@protocol YMMRouterRoutable;
@protocol YMMRouterFilterProtocol;

@protocol YMMRouterFilterChainProtocol <NSObject>

- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response;

@end

@interface YMMRouterFilterChain : NSObject<YMMRouterFilterChainProtocol>

- (void)addFilter:(id<YMMRouterFilterProtocol>)filter;

@end

@protocol YMMRouterFilterProtocol <NSObject>

- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response
           chain:(id<YMMRouterFilterChainProtocol>)chain;

@end

NS_ASSUME_NONNULL_END
