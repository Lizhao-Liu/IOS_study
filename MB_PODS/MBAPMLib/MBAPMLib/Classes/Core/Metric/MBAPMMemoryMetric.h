//
//  MBAPMMemoryMetric.h
//  MBAPMLib
//
//  Created by xp on 2021/10/14.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMMemoryExceptionType) {
    MBAPMMemoryExceptionTypeWarning, //低内存告警
    MBAPMMemoryExceptionTypeFOOM, //前台内存溢出
    MBAPMMemoryExceptionTypeUsage, //内存信息上报
    MBAPMMemoryExceptionTypeBigImage, //大图上报
    MBAPMMemoryExceptionTypeBigObject, //大对象上报（暂无）
    MBAPMMemoryExceptionTypeLeak //内存泄漏上报
    /// ......
};

/// MBAPMMemoryExceptionTypeFOOM, //前台内存溢出
@interface MBAPMMemoryMetric : MBAPMMetric

@property (nonatomic, assign) MBAPMMemoryExceptionType exceptionType;

/// 内存分布堆栈
@property (nonatomic, copy) NSString *stack;

/// OOM堆栈url
@property (nonatomic, copy) NSString *stackUrl;

/// 内存使用信息，最近2分钟
@property (nonatomic, copy) NSDictionary *memoryInfo;

/// 内存使用信息，最近一次log
///{"device_total_memory": "4096",
///"app_memory_usage": {"value": 300, "percent": 50},
///"available_memory": {"value": 300, "percent": 50}
///}
@property (nonatomic, copy) NSDictionary *currentMemory;

/// app 运行时间
@property (nonatomic, assign) NSUInteger runTime;

/// memory log 类型，0 固定时间点上报； 1 第一次页面消失上报； 2 10次（10是配置下发的）上报的平均值
@property (nonatomic, assign) NSUInteger logType;

/// apm 版本
@property (nonatomic, copy) NSString *apmVersion;

/// apm 版本
@property (nonatomic, assign) BOOL saveBehaviorLog;

/// 是否越狱
@property (nonatomic, assign) BOOL isJail;

/// 聚合标题
@property (nonatomic, copy) NSString *errorFeature;

/// 附加信息
@property (nonatomic, copy) NSString *errorDetail;

/// 最近的一些事件信息
@property (nonatomic, copy) NSArray *actionEvents;

/// app中涉及的bundle信息，在解析堆栈时用于符号表查找
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *bundles;

// MARK: - Get
/// 堆栈类型信息，上报时候读取，默认值 memory
@property (nonatomic, copy, readonly) NSString *stackType;

/// attr信息，上报时候读取，默认值 @{@"stack_type": self.stackType?:@"", @"stack":self.stack?:@"", @"memory":self.memoryInfo?:@"", @"bundles":self.bundles?:@[]};
@property (nonatomic, copy) NSDictionary * attrs;

@end

NS_ASSUME_NONNULL_END
