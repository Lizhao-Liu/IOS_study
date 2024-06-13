//
//  YMMRouterHandlerFilter.m
//  AFNetworking
//
//  Created by Xiaohui on 2019/3/11.
//

#import "YMMRouterHandlerFilter.h"
#import "YMMRouterFilterChain.h"
#import "YMMRouterResponse.h"
#import "YMMRouterRequest.h"
#import "YMMRouterTable.h"

@interface YMMRouterHandlerFilter ()
@end

@implementation YMMRouterHandlerFilter

- (instancetype)initWithRouterTables: (NSArray<YMMRouterTable *> *)tables {
    self = [super init];
    if (self) {
        _tables = tables;
    }
    return self;
}
    
- (void)doFilter:(id<YMMRouterRoutable>)routable
        response:(YMMRouterResponse *)response
           chain:(id<YMMRouterFilterChainProtocol>)chain {
    for (YMMRouterTable *table in _tables) {
        id<YMMRouterBaseHandlerProtocol> handler = [table matches:routable.path];
        if (handler) {
            response.status = YMMRouterStatusSuccess;
            response.handler = handler;
            [self routerTableDidMatched:routable response:response table:table];
            return;
        }
    }
    response.status = YMMRouterStatusNotFound;
    return;
}


/// 通过重写此方法，实现routerTable匹配到routable后的扩展逻辑，默认为空实现
/// @param routable 路由Request
/// @param response 路由Response
/// @param table  routerbale匹配到的routerTable
- (void)routerTableDidMatched:(id<YMMRouterRoutable>)routable response:(YMMRouterResponse *)response table:(YMMRouterTable *)table {
    
}
    
@end
