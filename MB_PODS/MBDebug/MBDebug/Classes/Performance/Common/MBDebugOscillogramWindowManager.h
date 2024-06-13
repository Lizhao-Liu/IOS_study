//
//  MBDebugOscillogramWindowManager.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <Foundation/Foundation.h>
#import "MBDebugOscillogramWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugOscillogramWindowManager : NSObject

+ (instancetype)shareInstance;

- (void)resetLayout;

- (NSArray<MBDebugOscillogramWindow *> *)performanceOscillogramWindows;
- (NSArray *)performanceOscillogramWindowTitles;

@end

NS_ASSUME_NONNULL_END
