//
//  MBDebugToolsManager.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import <Foundation/Foundation.h>
@import MBFoundation;


NS_ASSUME_NONNULL_BEGIN
@class MBDebugToolModel;

@interface MBDebugToolsManager : NSObject

DEFINE_SINGLETON_FOR_HEADER(MBDebugToolsManager)

- (void)installDebugTools;

/// 所有Debug工具集合
- (NSArray<MBDebugToolModel *> *)debugTools;

@end

NS_ASSUME_NONNULL_END
