//
//  YMMRouterHandlerFilter.h
//  AFNetworking
//
//  Created by Xiaohui on 2019/3/11.
//

#import <Foundation/Foundation.h>
#import "YMMRouterFilterChain.h"

NS_ASSUME_NONNULL_BEGIN

@class YMMRouterTable;

@interface YMMRouterHandlerFilter : NSObject<YMMRouterFilterProtocol>

@property (nonatomic, strong, readonly) NSArray<YMMRouterTable *> *tables;

- (instancetype)initWithRouterTables: (NSArray<YMMRouterTable *> *)tables;


- (void)routerTableDidMatched:(id<YMMRouterRoutable>)routable response:(YMMRouterResponse *)response table:(YMMRouterTable *)table;
    
@end

NS_ASSUME_NONNULL_END
