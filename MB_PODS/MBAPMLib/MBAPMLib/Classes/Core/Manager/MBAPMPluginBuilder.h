//
//  MBAPMPluginBuilder.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>
#import "MBAPMPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMPluginBuilder : NSObject

@property (nonatomic, weak) id<MBAPMPluginListenerDelegate> pluginListener;

- (void)addPlugin:(MBAPMPlugin *)plugin;

- (MBAPMPlugin *)getPlugin:(MBAPMPluginTag)tag;

- (NSArray<MBAPMPlugin *> *)getPlugins;

@end

NS_ASSUME_NONNULL_END
