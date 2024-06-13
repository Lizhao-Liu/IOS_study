//
//  MBAPMMainThreadStackMgr.h
//  MBAPMLib
//
//  Created by xp on 2020/11/11.
//

#import <Foundation/Foundation.h>
#import "MBAPMBacktraceLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMMainThreadStackMgr : NSObject

- (id)initWithCycleArrayCount:(int)cycleArrayCount;

- (void)addThreadStack:(uintptr_t *)stackArray andStackCount:(size_t)stackCount;

- (size_t)getLastMainThreadStackCount;

- (uintptr_t *)getLastMainThreadStack;

- (MBAPMBacktraceStack *)getPointStack;

- (void)clearThreadStacks;

@end

NS_ASSUME_NONNULL_END
