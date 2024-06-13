//
//  MBAPMTimeTrackModel.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/8.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+MBAPMSort.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kMBAPM_TIMETRACK_POINTTAG_BEGIN = @"begin";
static NSString * const kMBAPM_TIMETRACK_POINTTAG_END = @"end";

@interface MBAPMTimeTrackPoint : NSObject

@property (nonatomic, copy) NSString *pointTag;

@property (nonatomic, assign) UInt64 pointTime;

@end

@interface MBAPMTimeTrackModel : NSObject

@property (nonatomic, assign) UInt64 beginTime;

@property (nonatomic, assign) UInt64 endTime;

@property (nonatomic, strong) NSMutableDictionary<NSString *, MBAPMTimeTrackPoint *> *pointDict;

- (UInt64) getTotalTime;

- (NSArray *) getTimeBetweenPoints:(NSRange)range;

- (NSDictionary *)getTimeDividedByPoints;

@end

NS_ASSUME_NONNULL_END
