//
//  YMMRouter.h
//  YMMModuleLib
//
//  Created by Xiaohui on 2018/6/11.
//

#import <Foundation/Foundation.h>
#import "YMMRouterTable.h"

NS_ASSUME_NONNULL_BEGIN
@protocol YMMRouterFilterProtocol;
@class YMMRouterResponse;
@class YMMRouterHandler;

typedef NS_ENUM(NSUInteger, YMMRouterStatus) {
    YMMRouterStatusSuccess = 200,
    YMMRouterStatusRedirect = 302,
    YMMRouterStatusLowVersion = 520,
    YMMRouterStatusLowVersionRN = 522,
    YMMRouterStatusForbidden = 403,
    YMMRouterStatusNotFound = 404
    
};

typedef void(^HandleBlock)(NSError * _Nullable error, id _Nullable data);

typedef void(^MBNavHandleBlock)(NSError * _Nullable error, id _Nullable data, NSString * _Nullable requestId);


@protocol YMMRouterRoutable <NSObject>

@property (nonatomic, copy, readonly) NSString *urlString;
@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *host;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, assign) long long startTimestamp; // 路由开始时间，在request开始分发后才能取到
@property (nonatomic, copy, readonly) NSString *originUrlString; //原始路由url

//@optional， Swift对OC协议中的@optional支持有问题
@property (nonatomic, copy, readonly, nullable) NSDictionary *params;
@property (nonatomic, copy, readonly, nullable) NSString *fragment;
@property (nonatomic, copy, readonly, nullable) HandleBlock handleBlock;
@property (nonatomic, copy, readonly, nullable) MBNavHandleBlock navHandleBlock;

@property (nonatomic, copy) NSString *requestId; // 路由请求唯一标记ID，若外部传入，则使用外部传入的取值，外部未传入，则内部自动生成

- (BOOL)matchToRouter:(id<YMMRouterRoutable>)routable;

@end

@interface YMMRouter: NSObject

@property (nonatomic, copy, readonly) NSString *hostPattern;

+ (BOOL)match:(NSString *)pattern content:(NSString *)content;

- (instancetype)initWithSchemePattern:(NSString * _Nullable)schemePattern
                          hostPattern:(NSString * _Nonnull)hostPattern;
- (instancetype)initWithScheme:(NSString * _Nullable)scheme
                   hostPattern:(NSString * _Nonnull)hostPattern;
- (instancetype)initWithSchemes:(NSArray * _Nullable)schemes
                    hostPattern:(NSString * _Nonnull)hostPattern;

/// 使用host初始化router，schemes使用Router默认配置
/// @param hostPattern host
- (instancetype)initWithHostPattern:(NSString *)hostPattern;

- (void)addFilter:(id<YMMRouterFilterProtocol>)filter;

- (void)addRouterTable:(YMMRouterTable *)table;
- (void)removeRouterTable:(YMMRouterTable *)table;

- (void)registerHandler:(id<YMMRouterBaseHandlerProtocol>)handler
         forPathPattern:(NSString *)pathPattern;
- (void)registerBlock:(HandlerBlock)handlerBlock
       forPathPattern:(NSString *)pathPattern;
- (void)registerAction:(SEL)action
                target:(id)target
        forPathPattern:(NSString *)pathPattern;
- (void)unregisterHandlerForPathPattern:(NSString *)pathPattern;
- (BOOL)isSupport:(id<YMMRouterRoutable>)request;
- (YMMRouterResponse *)matches:(id<YMMRouterRoutable>)routable;
- (YMMRouterResponse *)redirect:(id<YMMRouterRoutable>)routable;

@end


NS_ASSUME_NONNULL_END
