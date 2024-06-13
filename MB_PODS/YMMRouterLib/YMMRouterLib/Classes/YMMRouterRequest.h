//
//  YMMRouterRequest.h
//  Pods-YMMRouterLib_Tests
//
//  Created by Xiaohui on 2019/2/17.
//

#import <Foundation/Foundation.h>
#import "YMMRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMRouterRequest : NSObject<YMMRouterRoutable>

- (id)initWithURL:(NSURL *)url;
- (id)initWithURLString:(NSString *)urlString;
- (id)initWithURL:(NSURL *)url params:(nullable NSDictionary *)params;
- (id)initWithURLString:(NSString *)urlString params:(nullable NSDictionary *)params;

/// 初始化request
/// @param url 处理后的NSURL，需遵循NSURL规则
/// @param params 参数
/// @param handleBlock 业务回调
- (id)initWithURL:(NSURL *)url params:(nullable NSDictionary *)params handleBlock:(nullable HandleBlock)handleBlock;

/// 初始化request
/// @param urlString 原始urlString，允许有中文、嵌套
/// @param params 请求参数
/// @param handleBlock 业务回调
- (id)initWithURLString:(NSString *)urlString params:(nullable NSDictionary *)params handleBlock:(nullable HandleBlock)handleBlock;



/// 初始化request
/// @param url url 处理后的NSURL，需遵循NSURL规则
/// @param params 参数
/// @param handleBlock 目标页面回调
/// @param navHandleBlock 目标页面通过mbrouter_setresutl回调
- (id)initWithURL:(NSURL *)url params:(NSDictionary *)params handleBlock:(nullable HandleBlock)handleBlock navHandleBlock:(nullable MBNavHandleBlock) navHandleBlock;


/// 初始化request
/// @param url url 处理后的NSURL，需遵循NSURL规则
/// @param params 参数
///  @param requestId   请求ID
/// @param handleBlock 目标页面回调
/// @param navHandleBlock 目标页面通过mbrouter_setresutl回调
- (id)initWithURL:(NSURL *)url params:(NSDictionary *)params requestId: (nullable NSString *)requestId handleBlock:(nullable HandleBlock)handleBlock navHandleBlock:(nullable MBNavHandleBlock) navHandleBlock;


/// url字符串转化为NSURL对象
/// @param urlString url字符串
+ (NSURL *)transferToURL:(NSString *) urlString;

@end

NS_ASSUME_NONNULL_END
