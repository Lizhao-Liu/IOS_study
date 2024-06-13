//
//  MBAPMTimeTrackTask.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/8.
//

#import <Foundation/Foundation.h>
#import "MBAPMTimeTrackModel.h"

@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMTimeTrackTaskStatus) {
    MBAPMTimeTrackTaskStatusInit,
    MBAPMTimeTrackTaskStatusStarted,
    MBAPMTimeTrackTaskStatusStopped
};

typedef void(^TimeTrackTotalBlock)(UInt64 totalTime);
typedef void(^TimeTrackDividedBlock)(UInt64 totalTime, NSDictionary<NSString *, NSNumber *> *timeDic);
typedef void(^TimeTrackRangeBlock)(UInt64 totalTime, NSArray *timeArray);

@interface MBAPMTimeTrackTask : NSObject <MBAPMEventTrack>

@property (nonatomic, copy) NSString *trackID;
@property (nonatomic, copy) NSString *eventID;

/// 事件分段耗时计算
/// @param range 事件埋点区间
/// @param result 结果回调
- (void)caculateWithRange:(NSRange)range withResultBlock:(TimeTrackRangeBlock)result;


/// 使用tags分段，计算分段耗时
/// @param result 结果回调
- (void)caculateDividedByPoints:(TimeTrackDividedBlock)result;


/// 事件总耗时计算
/// @param result 结果回调
- (void)caculateTotal:(TimeTrackTotalBlock)result;

@end

NS_ASSUME_NONNULL_END
