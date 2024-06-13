//
//  YMMRouterTable.h
//  Pods-YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMMRouterResponse;
@protocol YMMRouterRoutable;

typedef void (^HandlerCallback)(id _Nullable);
typedef void (^HandlerBlock)(id<YMMRouterRoutable>, HandlerCallback _Nullable);

@protocol YMMRouterBaseHandlerProtocol <NSObject>


@end

@protocol YMMRouterHandlerProtocol <NSObject, YMMRouterBaseHandlerProtocol>

- (nullable id)handle:(id<YMMRouterRoutable>)routable;

@end

@protocol YMMRouterAsyncHandlerProtocol <NSObject, YMMRouterBaseHandlerProtocol>

- (void)handle:(id<YMMRouterRoutable>)routable
      callback:(nullable HandlerCallback)callback;

@end


@interface YMMRouterTable : NSObject

- (void)registerHandler:(id<YMMRouterBaseHandlerProtocol>)handler
         forPathPattern:(NSString *)pathPattern;
- (void)registerBlock:(HandlerBlock)handlerBlock
       forPathPattern:(NSString *)pathPattern;
- (void)registerAction:(SEL)action
                target:(id)target
        forPathPattern:(NSString *)pathPattern;
- (void)unregisterHandlerForPathPattern:(NSString *)pathPattern;
- (id<YMMRouterBaseHandlerProtocol>)matches:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
