//
//  MBAPMTimeTrack.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/8.
//

#import <Foundation/Foundation.h>
#import "MBAPMTimeTrackTask.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN



/// MBAPMTimeTrack是用来跟踪流程耗时的工具
@interface MBAPMTimeTrack : NSObject

/// 单例方法
+ (instancetype)shared;


/// 单独创建MBAPMTimeTrackTask,内部不维护Task与EventID的映射，事件埋点直接调用Task方法
/// @param eventID 事件ID
- (MBAPMTimeTrackTask *)createTask:(NSString *)eventID;


/// 事件开始，内部维护MBAPMTimeTrackTask对象
/// @param eventID 事件ID
- (void)begin:(NSString *)eventID;


/// 事件中间过程埋点，可以按埋点进行分段统计耗时
/// @param eventID 事件ID
/// @param tag 埋点标记
- (void)markPoint:(NSString *)eventID withPointTag:(NSString *)tag;


/// 事件结束，内部会销毁对应的MBAPMTimeTrackTask对象
/// @param eventID 事件ID
- (void)end:(NSString *)eventID;


/// 事件结束，内部会销毁对应的MBAPMTimeTrackTask对象
/// @param eventID 事件ID
/// @param endTag 结束埋点标记
- (void)end:(NSString *)eventID withEndTag:(NSString *)endTag;


/// 事件分段耗时计算
/// @param eventID 事件ID
/// @param range 事件分段区间
/// @param result 回调block
- (void)caculate:(NSString *)eventID withRange:(NSRange)range withResultBlock:(TimeTrackRangeBlock)result;


/// 使用tag对事件分段并计算分段耗时
/// @param eventID 事件ID
/// @param result 回调block
- (void)caculateDividedByPoints:(NSString *)eventID withResultBlock:(TimeTrackDividedBlock)result;


/// 事件总耗时计算
/// @param eventID 事件ID
/// @param result 回调block
- (void)caculateTotal:(NSString *)eventID withResultBlock:(TimeTrackTotalBlock)result;

@end

NS_ASSUME_NONNULL_END
