//
//  MBDebugMonitorToolManager.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>
@import MBFoundation;

NS_ASSUME_NONNULL_BEGIN

@class MBDebugMonitorToolModel;

@interface MBDebugMonitorToolManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(MBDebugMonitorToolManager)

- (void)installMonitorTools;

/// 所有monitor面板工具集合
- (NSArray<MBDebugMonitorToolModel *> *)monitorTools;

@end

NS_ASSUME_NONNULL_END
