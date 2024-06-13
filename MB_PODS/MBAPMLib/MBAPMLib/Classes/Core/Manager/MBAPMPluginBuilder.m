//
//  MBAPMPluginBuilder.m
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import "MBAPMPluginBuilder.h"
#import "NSMutableDictionary+MBAPMSort.h"

@interface MBAPMPluginBuilder()

@property (nonatomic, strong) NSMutableDictionary *plugins;

@end

@implementation MBAPMPluginBuilder

- (instancetype)init {
    if(self = [super init]) {
        self.pluginListener = nil;
        self.plugins = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)addPlugin:(MBAPMPlugin *)plugin {
    if(plugin) {
        [plugin setListenerDelegate:self.pluginListener];
        [self.plugins MBAPMSort_setObject:plugin forKey:@([plugin pluginTag])];
    }
}

- (MBAPMPlugin *)getPlugin:(MBAPMPluginTag)tag {
    return [self.plugins objectForKey:@(tag)];
}

- (NSArray<MBAPMPlugin *> *)getPlugins {
    return [_plugins MBAPMSort_getAllValue];
}

#pragma mark - property method

- (NSMutableDictionary *)plugins {
    if(!_plugins) {
        _plugins = [[NSMutableDictionary alloc]init];
    }
    return _plugins;
}

@end
