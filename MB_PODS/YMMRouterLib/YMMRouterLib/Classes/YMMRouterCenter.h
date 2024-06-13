//
//  YMMRouterCenter.h
//  Pods-YMMRouterLib_Example
//
//  Created by Xiaohui on 2019/3/3.
//

#import <UIKit/UIKit.h>
#import "YMMRouterTable.h"
#import "YMMRouterConfigManager.h"

NS_ASSUME_NONNULL_BEGIN

@class YMMRouter;
@class YMMRouterRequest;
@class YMMRouterResponse;
@class YMMRouterConfig;
@protocol YMMRouterRoutable;
@protocol YMMRouterFilterProtocol;

typedef void(^Completion)(YMMRouterResponse * _Nullable);

@protocol YMMRouterCenterInterceptorProtocol <NSObject>

- (BOOL)routerShouldHandle:(id<YMMRouterRoutable>)routable;
- (void)routerDidHandle:(id<YMMRouterRoutable>)routable
               response:(YMMRouterResponse *)response;

@end

@interface YMMRouterCenter : NSObject<YMMRouterCenterInterceptorProtocol>

+ (instancetype)shared;

+ (void)setupConfig:(YMMRouterConfig *)config;

+ (void)setRouterErrorViewController:(MBRouterErrorViewControllerConfigBlock)block;

- (void)addFilter:(id<YMMRouterFilterProtocol>)filter;
- (void)addInterceptor:(id<YMMRouterCenterInterceptorProtocol>)interceptor;

- (void)addRouter:(YMMRouter *)router;
- (void)addRouters:(NSArray<YMMRouter *> *)routers;
- (void)removeRouter:(YMMRouter *)router;

- (YMMRouterResponse *)match:(id<YMMRouterRoutable>)routable;

- (id<YMMRouterRoutable>)getRedictedUrl:(id<YMMRouterRoutable>)routable;

- (void)perform:(id<YMMRouterRoutable>)routable
     completion:(nonnull Completion)completion;
- (void)performWithURL:(NSURL *)url
            completion:(nullable Completion)completion;
- (void)performWithURL:(NSURL *)url
                params:(nullable NSDictionary *)params
            completion:(nullable Completion)completion;


/// 请谨慎使用，同步获取路由结果，使用前需要先判断返回的对象类型，若路由实现handler为异步调用callback，此方法返回nil。
/// - Parameters:
///   - URL: 路由地址，在生成NSURL对象时注意检查url中的参数是否encode
///   - params: 路由参数
- (id)syncPerformWithURL:(NSURL *)URL params:(NSDictionary * _Nullable)params;

- (void)performWithURLString:(NSString *)urlString
                  completion:(nullable Completion)completion;
- (void)performWithURLString:(NSString *)urlString
                      params:(nullable NSDictionary *)params
                  completion:(nullable Completion)completion;
@end

@interface YMMRouterCenter (UIViewController)


/// 采用pushViewController的方式跳转页面
/// @param url 页面对应的url，注意url对应的字符串如果包含非法字符，需要做url encode
/// @param params 参数
/// @param viewController 上一级页面
+ (void)pushWithUrl:(NSURL *)url
             params:(nullable NSDictionary *)params
        fromViewController:(UIViewController *)viewController;


/// 采用pushViewController的方式跳转页面，url为字符串
/// @param urlString 页面对应的url，如果没有url encode，内部会做url encode
/// @param params 参数
/// @param viewController 上一级页面
+ (void)pushWithUrlString:(NSString *)urlString
            params:(nullable NSDictionary *)params
       fromViewController:(UIViewController *)viewController;


/// 采用presenterViewController的方式跳转页面
/// @param url 页面对应的url，注意url对应的字符串如果包含非法字符，需要做url encode
/// @param params 参数
/// @param viewController 上一级页面
+ (void)presentWithUrl:(NSURL *)url
                params:(nullable NSDictionary *)params
        fromViewController:(UIViewController *)viewController;


/// 采用presenterViewController的方式跳转页面，url为字符串
/// @param urlString 页面对应的url，如果没有url encode，内部会做url encode
/// @param params 参数
/// @param viewController 上一级页面
+ (void)presentWithUrlString:(NSString *)urlString
                      params:(nullable NSDictionary *)params
        fromViewController:(UIViewController *)viewController;

@end


NS_ASSUME_NONNULL_END
