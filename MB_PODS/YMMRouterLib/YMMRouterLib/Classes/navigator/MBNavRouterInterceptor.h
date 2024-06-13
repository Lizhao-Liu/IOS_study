//
//  MBNavRouterInterceptor.h
//  YMMRouterLib
//
//  Created by xp on 2023/8/15.
//

#import <Foundation/Foundation.h>
#import "YMMRouterCenter.h"

NS_ASSUME_NONNULL_BEGIN


/// 路由拦截器，在routerDidHandle中将路由request信息与UIViewController进行关联
@interface MBNavRouterInterceptor : NSObject <YMMRouterCenterInterceptorProtocol>

@end

NS_ASSUME_NONNULL_END
