//
//  MBAPMEventTimeTrackMgr.h
//  MBAPMLib
//
//  Created by xp on 2021/6/15.
//

#import <Foundation/Foundation.h>
@protocol MBAPMEventTimeTrack;
@protocol MBAPMEventTimeTrackRecordProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMEventTimeTrackMgr : NSObject

/// 创建MBAPMEventTimeTrack对象
+ (id<MBAPMEventTimeTrack> _Nonnull)createTrack;

+ (id<MBAPMEventTimeTrack>)createTrack:(id<MBAPMEventTimeTrackRecordProtocol>)trackRecord;


/// 保存外部创建的trackTask
/// @param trackTask trackTask对象
+ (void)saveTask:(id<MBAPMEventTimeTrack>)trackTask;

/// 获取MBAPMEventTimeTrack对象
/// @param trackID track唯一标识，通过createTrack可以获得到
+ (id<MBAPMEventTimeTrack> _Nullable)getTrack:(NSString * _Nonnull)trackID;

/// 移除MBAPMEventTimeTrack对象
/// @param trackID track唯一标识，通过createTrack可以获得到
+ (BOOL)removeTrack:(NSString * _Nonnull)trackID;

/// 获取所有task对象
+ (NSArray<id<MBAPMEventTimeTrack>> *)getAllTasks;

@end

NS_ASSUME_NONNULL_END
