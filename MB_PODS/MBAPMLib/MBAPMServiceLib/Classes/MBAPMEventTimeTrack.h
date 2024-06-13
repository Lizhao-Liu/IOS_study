//
//  MBAPMEventTimeTrack.h
//  Pods
//
//  Created by xp on 2021/6/15.
//

#ifndef MBAPMEventTimeTrack_h
#define MBAPMEventTimeTrack_h

#import "MBAPMEventTimeTrackRecordProtocol.h"

@class MBModuleInfo;

typedef NS_ENUM(NSUInteger, MBAPMEventTimeTrackTaskExternalEnv) {
    MBAPMEventTimeTrackTaskExternalEnv_enterBackground = 1 << 0,
};

@protocol MBAPMEventTimeTrackContainerProtocol;

/// 事件耗时统计结果回调

typedef void(^MBAPMEventTimeTrackCommonCompleteBlock)(BOOL result, NSString * _Nullable msg,  id<MBAPMEventTimeTrackRecordProtocol>  _Nonnull timeTrackResult);


// section 保留参数 page_view_prepare，page_native_load，page_runtime_init，page_load，page_first_layout，page_second_layout，page_interactive_prepare，page_network，page_appear
// 埋点时机看 https://wiki.amh-group.com/pages/viewpage.action?pageId=575957498 ，相关参数如下。
// 1. start 调用begin:即可
// 2. 其他使用如下sectionTag调用 section:withExtra:，
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_View_Prepare           = @"page_view_prepare";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Native_Load            = @"page_native_load";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Runtime_Init           = @"page_runtime_init";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Load                   = @"page_load";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_First_Layout           = @"page_first_layout";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Second_Layout          = @"page_second_layout";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Interactive_Prepare    = @"page_interactive_prepare"; // end阶段，看下一行注释
// 3. 调用end end:withExtra: 将线性生命周期的最后一步填上， 附加传入 sectionTag名，page_interactive_prepare

// 其他的section使用带时间戳的分段调用 section:beginAt:endAt:withExtra:
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Network                = @"page_network";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Appear                 = @"page_appear";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Duration_First_Layout  = @"page_duration_first_layout";
static NSString * _Nonnull kMBAPMEventTimeTrack_Page_Duration_Second_Layout = @"page_duration_second_layout";

/* 事件耗时跟踪
事件耗时分为：总耗时和分段耗时，都包含起始点和结束点；
事件中断：事件可能因为页面退出、App退到后台等因素被中断，此时要中断中断事件耗时统计。
*/
@protocol MBAPMEventTimeTrack <NSObject>

/// 数据回调block, apm内部进行数据上报的，接入方不需要设置
@property (nonatomic, copy, nullable) MBAPMEventTimeTrackCommonCompleteBlock  completeBlock;

/// track 绑定的容器，一般是vc容器
@property (nonatomic, weak, nullable) id<MBAPMEventTimeTrackContainerProtocol> container;

/// track 绑定的path，加上绑定的容器 可以确定唯一id
@property (nonatomic, copy, nullable) NSString *path;

/// 透传数据, tags 会合并保留，其他覆盖
@property (nonatomic, copy, nullable) NSDictionary *associatedData;

/// ModuleInfo, 会覆盖使用最后一个，若无，上报时候取当前
@property (nonatomic, strong, nullable) MBModuleInfo *moduleInfo;

/// 外部环境状态，例如enterBackground
@property (nonatomic, assign, readonly) MBAPMEventTimeTrackTaskExternalEnv env;

/// 更新App外部环境状态
/// @param evn 外部环境状态，例如enterBackground
- (void)updateExternalEnv:(MBAPMEventTimeTrackTaskExternalEnv)env;

/// 事件开始
/// @param extData 事件相关业务数据
- (BOOL)begin:(NSDictionary * _Nullable)extData;

/// 事件开始
/// @param extData 事件相关业务数据
/// @param beginTimestamp 事件开始时间戳
- (BOOL)begin:(NSDictionary * _Nullable)extData beginAt:(UInt64)beginTimestamp;

/// 事件结束
/// @param extData 事件相关业务数据
- (BOOL)end:(NSDictionary * _Nullable)extData;


/// 事件结束，自定义最后一个section名称
/// @param lastSectionTag 最后一个section名称
/// @param extData 事件相关业务数据，在使用section方法对串行分段结束进行标记时，end方法中的extData作为整个事件的业务数据，不会放到最后一个section中
- (BOOL)end:(NSString * _Nonnull)lastSectionTag withExtra:(NSDictionary * _Nullable)extData;
- (BOOL)end:(NSString * _Nonnull)lastSectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData;

/// 事件分段标记，针对串行事件，标记事件分段结束点
/// @param sectionTag 事件分段标识
/// @param extData 事件相关业务数据
- (BOOL)section:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData;


/// 事件分段标记，直接传入分段的开始和结束时间
/// @param sectionTag 事件分段标识
/// @param endTimeStamp 事件结束时间戳
/// @param extData 事件相关业务数据
- (BOOL)section:(NSString * _Nonnull)sectionTag endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData;

/// 事件分段标记，直接传入分段的开始和结束时间
/// @param sectionTag 事件分段标识
/// @param beginTimestamp 事件开始时间戳
/// @param endTimeStamp 事件结束时间戳
/// @param extData 事件相关业务数据
- (BOOL)section:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp withExtra:(NSDictionary * _Nullable)extData;


/// 事件分段标记，直接传入分段的开始和结束时间
/// @param sectionTag 事件分段标识
/// @param beginTimestamp 事件开始时间戳
/// @param endTimeStamp 事件结束时间戳
/// @param type 事件分段类型
/// @param extData 事件相关业务数据
- (BOOL)section:(NSString * _Nonnull)sectionTag beginAt:(UInt64)beginTimestamp endAt:(UInt64)endTimeStamp sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData;

/// 事件分段标记，直接传入分段耗时
/// @param sectionTag 事件分段标识
/// @param elapsedTime 事件分段耗时
/// @param extData 事件相关业务数据
- (BOOL)section:(NSString * _Nonnull)sectionTag cost:(UInt64)elapsedTime withExtra:(NSDictionary * _Nullable)extData;


/// 事件分段开始
/// @param sectionTag 事件分段标识
/// @param extData 事件分段相关业务数据
- (BOOL)beginIsolatedSection:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData;

/// 事件分段开始
/// @param sectionTag 事件分段标识
/// @param type 事件分段类型
/// @param extData 事件分段相关业务数据
- (BOOL)beginIsolatedSection:(NSString * _Nonnull)sectionTag sectionType:(MBAPMEventTimeSectionType)type withExtra:(NSDictionary * _Nullable)extData;


/// 事件分段结束
/// @param sectionTag 事件分段标识
/// @param extData 事件分段业务数据
- (BOOL)endIsolatedSection:(NSString * _Nonnull)sectionTag withExtra:(NSDictionary * _Nullable)extData;


/// 中断事件
- (BOOL)abort;

/// 获取trackId
- (NSString * _Nonnull)getTrackId;

@end


#endif /* MBAPMEventTimeTrack_h */
