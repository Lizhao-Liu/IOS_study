//
//  YMMRouterRequest+MBNav.m
//  YMMRouterLib
//
//  Created by xp on 2023/11/28.
//

#import "YMMRouterRequest+MBNav.h"

@implementation YMMRouterRequest(MBNav)

- (id)initWithURLString:(NSString *)urlString params:(NSDictionary *)params requestId:(NSString *)requestId navHandleBlock:(MBNavHandleBlock)handleBlock {
    NSURL *url = [YMMRouterRequest transferToURL:urlString];
    return [self initWithURL:url params:params requestId:requestId handleBlock:nil navHandleBlock:handleBlock];
 }

@end
