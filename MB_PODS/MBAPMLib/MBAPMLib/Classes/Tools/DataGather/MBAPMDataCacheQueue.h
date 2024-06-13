//
//  MBAPMDataCacheQueue.h
//  MBAPMLib
//
//  Created by xp on 2020/8/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDataCacheQueue : NSObject

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)loopQueueWithCapacity:(NSUInteger)capacity;

- (void)enqueue:(CGFloat)value;

- (NSArray *)getAllItems;

- (NSArray *)getLatestItemsForCount:(NSInteger)count;

- (void)clear;

@end

NS_ASSUME_NONNULL_END
