//
//  YMMRouterRequest+MBNav.h
//  YMMRouterLib
//
//  Created by xp on 2023/11/28.
//

#import <Foundation/Foundation.h>
#import "YMMRouterRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMRouterRequest(MBNav)

/// 初始化request，此方法限于在内部MBNav中使用，直接使用YMMRouterRequest进行路由跳转的使用
/// @param urlString 原始urlString，允许有中文、嵌套
/// @param params 请求参数
/// @param requestId 请求ID
/// @param handleBlock 目标页面返回时调mbrouter_setResult回调此block
- (id)initWithURLString:(NSString *)urlString params:(nullable NSDictionary *)params requestId:(NSString *)requestId navHandleBlock:(nullable MBNavHandleBlock)handleBlock;

@end

NS_ASSUME_NONNULL_END
