//
//  YMMRouterResponse.h
//  Pods-YMMRouterLib_Tests
//
//  Created by Xiaohui on 2019/2/17.
//

#import <Foundation/Foundation.h>
#import "YMMRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMRouterResponse : NSObject

@property (nonatomic) YMMRouterStatus status;
@property (nonatomic, strong) id<YMMRouterBaseHandlerProtocol> handler;
@property (nonatomic, readonly, strong) id<YMMRouterRoutable> request;
@property (nonatomic, strong) id result;

- (instancetype)initWithStatus:(YMMRouterStatus)status;
- (instancetype)initWithStatus:(YMMRouterStatus)status
                       request:(nullable id<YMMRouterRoutable>)routable;

@end

NS_ASSUME_NONNULL_END
