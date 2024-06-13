//
//  MBDebugCircularQueue.h
//  MBDebug
//
//  Created by Lizhao on 2023/8/1.
//

#import <Foundation/Foundation.h>
#import "MBDebugMonitorDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugMonitorLogQueue : NSObject

@property (nonatomic, assign, readonly) NSInteger capacity;
@property (nonatomic, assign, readonly) NSInteger size;
@property (nonatomic, assign, readonly) NSInteger errorObjectCount;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)loopQueueWithCapacity:(NSUInteger)capacity;

- (instancetype)initWithCapacity:(NSInteger)capacity;

- (void)enqueue:(id<MBDebugMonitorLogObject>)value;

- (void)removeObjects:(NSArray<id<MBDebugMonitorLogObject>> *)objects;

- (void)clear;

- (NSArray<id<MBDebugMonitorLogObject>> *)allLogObjects;

- (NSArray<id<MBDebugMonitorLogObject>> *)allErrorObjects;


@end

NS_ASSUME_NONNULL_END
