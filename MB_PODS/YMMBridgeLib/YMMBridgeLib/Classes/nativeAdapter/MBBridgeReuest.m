//
//  MBBridgeReuest.m
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import "MBBridgeReuest.h"

@implementation MBBridgeReuest

+ (instancetype)requestWithName:(NSString *)name
                        visitor:(nullable NSString *)visitor
                         params:(nullable NSDictionary *)params {
    MBBridgeReuest *request = [[MBBridgeReuest alloc] init];
    request.bridgeName = name;
    request.visitor = visitor;
    request.params = params;
    return request;
}

@end
