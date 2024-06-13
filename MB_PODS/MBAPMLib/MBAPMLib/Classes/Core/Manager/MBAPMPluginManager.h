//
//  MBAPMPluginManager.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>
#import "MBAPMContext.h"
#import "MBAPMPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMPluginManager : NSObject

+ (instancetype)initWithContext:(MBAPMContext *)context;

+ (instancetype)shared;

- (MBAPMPlugin *)getPlugin:(MBAPMPluginTag)pluginTag;

- (void)enablePlugin:(BOOL)enable withTag:(MBAPMPluginTag)pluginTag;

- (void)startPlugins;

@end

NS_ASSUME_NONNULL_END
