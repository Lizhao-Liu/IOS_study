//
//  MBAPMCrashMetric.h
//  MBAPMLib
//
//  Created by xp on 2020/8/17.
//

#import "MBAPMMetric.h"

NS_ASSUME_NONNULL_BEGIN
@class MBMemoryLogModel;

@interface MBAPMCrashMetric : MBAPMMetric


@property (nonatomic, copy) NSString *crashType;

/// 崩溃类型
@property (nonatomic, strong) NSString *crashTag;

/// 是否开启memorylog
@property (nonatomic, assign) BOOL isMemoryLog;

/// 是否开启有堆栈信息
@property (nonatomic, assign) BOOL isOOMStack;

/// 崩溃场景，枚举值：default,launch
@property (nonatomic, copy) NSString *crashScene;

/// 崩溃栈
@property (nonatomic, copy) NSString *stack;

/// 关联堆栈
@property (nonatomic, copy) NSArray<NSString *> *related_stacks;

/// 崩溃栈上传地址
@property (nonatomic, copy) NSString *stackUrl;

/// CPU使用信息，最近2分钟
@property (nonatomic, copy) NSDictionary *cpuInfo;


/// 内存使用信息，最近2分钟
@property (nonatomic, copy) NSDictionary *memoryInfo;


/// 内存使用信息
@property (nonatomic, strong) MBMemoryLogModel *currentMemory;


/// 是否是前台
@property (nonatomic, assign) BOOL isForeground;


/// 是否越狱
@property (nonatomic, assign) BOOL isJail;


/// 剩余磁盘空间
@property (nonatomic, assign) NSInteger availableStorage;


/// 附加信息
@property (nonatomic, copy) NSDictionary *extInfo;


/// app中涉及的bundle信息，在解析堆栈时用于符号表查找
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *bundles;


// MARK: - Get
/// 堆栈类型信息，上报时候读取，默认值 crash
@property (nonatomic, copy) NSString *stackType;

/// attrs信息
@property (nonatomic, copy) NSDictionary * attrs;

// 业务参数，需要在统计中作为算子维度的字段
@property (nonatomic, copy) NSDictionary *bizTags;


@end

NS_ASSUME_NONNULL_END
