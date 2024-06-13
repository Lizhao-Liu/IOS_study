//
//  MBAPMDoctorEventCacheQueue.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/2/22.
//

#import <Foundation/Foundation.h>
#import "MBAPMDoctorEventModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMDoctorEventCacheQueue : NSObject

+ (instancetype)loopQueueWithCapacity:(NSUInteger)capacity;

- (void)enqueue:(MBAPMDoctorEventModel *)model;

- (NSArray *)getAllEvents;

- (MBAPMDoctorEventModel *)getLatestEvent;

- (void)clear;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
