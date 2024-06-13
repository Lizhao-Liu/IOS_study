//
//  MBAPMEventTimeTrackRecordProtocol.h
//  MBAPMServiceLib
//
//  Created by xp on 2024/1/24.
//

#ifndef MBAPMEventTimeTrackRecordProtocol_h
#define MBAPMEventTimeTrackRecordProtocol_h

NS_ASSUME_NONNULL_BEGIN


static NSString * const kMBAPM_EVENTTIMETRACK_POINTTAG_BEGIN = @"begin";
static NSString * const kMBAPM_EVENTTIMETRACK_POINTTAG_END = @"last_section";

typedef NS_ENUM(NSInteger, MBAPMEventTimeSectionType) {
    MBAPMEventTimeSectionType_SERIAL = 0,      // 串行分段
    MBAPMEventTimeSectionType_COCURRENT = 1   // 并行分段
};

/// 事件点
@interface MBAPMEventTimePoint : NSObject


/// 事件触发时间戳
@property (nonatomic, assign) UInt64 timestamp;

/// 业务数据
@property (nonatomic, copy, nullable) NSDictionary *extraData;

@end

@interface MBAPMBaseEventTimeSection : NSObject

/// 分段标识
@property (nonatomic, copy, nonnull) NSString *sectionTag;

/// 事件耗时
@property (nonatomic, assign) UInt64 elapsedTime;


/// 事件分段类型
@property (nonatomic, assign) MBAPMEventTimeSectionType type;


@end

/// 事件
@interface MBAPMEventTimeSection : MBAPMBaseEventTimeSection


///事件开始点
@property (nonatomic, strong, nonnull) MBAPMEventTimePoint *beginPoint;

///事件结束点
@property (nonatomic, strong, nonnull) MBAPMEventTimePoint *endPoint;



@end

/// 事件
@interface MBAPMEventNonePointTimeSection : MBAPMBaseEventTimeSection


///事件开始时间戳
@property (nonatomic, assign) UInt64 beginTimestamp;

///事件结束时间戳
@property (nonatomic, assign) UInt64 endTimestamp;

/// 业务数据
@property (nonatomic, copy, nullable) NSDictionary *extraData;


@end

@protocol MBAPMEventTimeTrackRecordProtocol
/// 事件跟踪ID
@property (nonatomic, strong, readonly, nonnull) NSString *trackID;

/// 检验数据是否合法
- (BOOL)validData;

- (UInt64)getTotalElapsedTime;

- (UInt64)getBeginTimestamp;

- (UInt64)getEndTimestamp;

- (UInt64)getPreSectionElapsedTime;

- (NSDictionary<NSString *, NSNumber *> * _Nullable)getSectionsDict;

- (NSDictionary * _Nullable)getSectionsExt;

- (NSDictionary * _Nullable)getWholeExt;

- (void)updateAssociatedData:(NSDictionary * _Nullable)associatedData;

- (void)begin:(NSDictionary * _Nullable)extData beginAt:(UInt64)beginTimestamp;

- (void)end:(NSString * _Nonnull)lastSectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData;

- (void)beginIsolatedSection:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData;

- (void)endIsolatedSection:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData;

- (void)sectionBeginFromLastPoint:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData;

- (void)section:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimestamp withExtra:(NSDictionary * _Nullable)extData;

- (void)section:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData;

- (void)section:(NSString *_Nonnull)sectionTag cost:(UInt64)elapsedTime withExtra:(NSDictionary *_Nullable)extData;

@end

NS_ASSUME_NONNULL_END

#endif /* MBAPMEventTimeTrackRecordProtocol_h */
