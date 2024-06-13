//
//  MBAPMLagMetric.h
//  MBAPMLib
//
//  Created by xp on 2020/8/17.
//

#import "MBAPMMetric.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMLagType) {
    MBAPMLagTypeNull, //无卡顿
    MBAPMLagTypeShort, // 短时频繁卡顿
    MBAPMLagTypeLong,   // 长时单次卡顿
    MBAPMLagTypeDead    //卡死
};

@interface MBAPMLagMetric : MBAPMMetric

/// 卡顿类型
@property (nonatomic, assign) MBAPMLagType lagType;

/// 抓取类型
@property (nonatomic, assign) NSInteger dumpType;

/// 报告渠道
@property (nonatomic, assign) MBAPMReportChannel reportChannel;

/// 卡顿所在页面
@property (nonatomic, copy) NSString *pageId;

/// 卡顿时间
@property (nonatomic, assign) NSTimeInterval lagStartTime;


/// 卡顿时长
@property (nonatomic, assign) NSTimeInterval lagTotalTime;


/// 卡顿主线程调用栈
@property (nonatomic, copy) NSString *stack;


/// 卡顿主线程调用栈关键方法
@property (nonatomic, copy) NSString *keyFunction;

/// CPU使用信息，最近2分钟
@property (nonatomic, copy) NSDictionary *cpuInfo;

/// 内存使用信息，最近2分钟
@property (nonatomic, copy) NSDictionary *memoryInfo;

/// 帧率信息，最近2分钟
@property (nonatomic, copy) NSDictionary *fpsInfo;

/// app中涉及的bundle信息，在解析堆栈时用于符号表查找
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *bundles;

/// 其他环境信息
@property (nonatomic, copy) NSDictionary *systemInfo;


// MARK: - Get
/// 堆栈类型信息，上报时候读取，默认值 lag
@property (nonatomic, copy, readonly) NSString *stackType;

/// attr信息，上报时候读取，默认值 @{@"stack_type": self.stackType?:@"", @"stack":self.stack?:@"", @"cpu":self.cpuInfo?:@"", @"fps":self.fpsInfo?:@"", @"bundles":self.bundles?:@[]};
@property (nonatomic, copy, readonly) NSDictionary * attrs;

/// ext信息，上报时候读取，默认值 @{@"lagStartTime":@(self.lagStartTime)?:@(0), @"lagTotalTime":@(self.lagTotalTime)?:@(0)};
@property (nonatomic, copy, readonly) NSDictionary * exts;




@end

NS_ASSUME_NONNULL_END
