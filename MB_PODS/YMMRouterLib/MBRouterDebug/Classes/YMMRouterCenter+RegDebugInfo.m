//
//  YMMRouterCenter+RegDebugInfo.m
//  YMMRouterDebug
//
//  Created by 周刚涛 on 2020/4/8.
//

#import "YMMRouterCenter+RegDebugInfo.h"
@import MBBuildPreLib;

@implementation YMMRouterCenter (RegDebugInfo)

+ (NSArray*) registRouterDebugInfo {
    NSMutableArray *ret = @[].mutableCopy;
    if ([MBFMacro ymm_buildDebug] || [MBFMacro ymm_buildAdhoc]) {
        NSArray<YMMRouter *> *routers = [[[YMMRouterCenter shared] valueForKey:@"_routers"] copy];
        for (YMMRouter *item in routers) {
            NSLog(@"item %@",item.hostPattern);
            
            NSArray *_schemes = [item valueForKey:@"_schemes"] ? : @[];
            NSArray *_tables = [item valueForKey:@"_tables"] ? : @[];
            NSArray *_map = @[];
            
            if ([_tables respondsToSelector:@selector(count)] && _tables.count >= 1) {
                id routab = _tables[1];
                NSDictionary *map = [routab valueForKey:@"_map"];
                _map = map ? map.allKeys : @[];
            }
            
            NSDictionary *dictItems = @{@"_schemes":_schemes,@"_map":_map};
            NSDictionary *dict = @{item.hostPattern:dictItems};
            [ret addObject:dict];
        }
    }
    return ret.copy;
}

@end
