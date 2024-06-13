//
//  MBAPMMetric.h
//  YMMPerformanceModule
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Metric计算类型
typedef NS_ENUM(NSUInteger, MBAPMMetricType) {
    MBAPMMetricTypeCounter,      /// 计数类
    MBAPMMetricTypeGauge         /// 耗时类
};

/// 性能指标分类
typedef NS_ENUM(NSUInteger, MBAPMPerformanceType) {
    MBAPMPerformanceTypePageRender,     /// 页面渲染耗时
    MBAPMPerformanceTypeAppLaunch,       /// App启动耗时
    MBAPMPerformanceTypeLag,             /// 卡顿
    MBAPMPerformanceTypeCrash,            /// 崩溃
    MBAPMPerformanceTypePageCPUUsage,     /// 页面CPU占用
    MBAPMPerformanceTypeMemory,           /// 前台OOM
    MBAPMPerformanceTypeCPU,              /// CPU
    MBAPMPerformanceTypeError,            /// 苹果 metric 收集的异常
    MBAPMPerformanceTypeFPS,              /// 帧率
    MBAPMPerformanceTypeWhiteScreen,       /// 白屏
    MBAPMPerformanceTypeWakeups,
    MBAPMPerformanceTypeTrffic             /// 流量
    /// ......
};

@interface MBAPMMetric : NSObject

/// 性能指标分类
@property (nonatomic, assign) MBAPMPerformanceType performanceType;
/// 性能指标计算类型
@property (nonatomic, assign) MBAPMMetricType metricType;
/// 性能指标名称
@property (nonatomic, copy) NSString *metricName;
/// 性能指标值
@property (nonatomic, assign) UInt64 metricValue;
/// metric - sections - 性能指标分段数据
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *metricSections;
/// 使用方传入的额外数据
@property (nonatomic, copy) NSDictionary *extraData;
/// 页面名称
@property (nonatomic, copy) NSString *pageName;
/// 页面路由
@property (nonatomic, copy) NSString *pagePath;
/// 页面类名
@property (nonatomic, copy) NSString *pageClassName;

// 发生异常的页面是否在处于开屏加载状态
@property (nonatomic, assign) NSInteger isPageLoading;

/// 公共参数 - App前后台状态
@property (nonatomic, assign) NSInteger appForeground;

/// 公共参数 - app 评级（目前根据内存）
@property (nonatomic, strong) NSString *deviceLeval;

/// 获取崩溃日志使用的二进制信息
@property (nonatomic, copy, readonly) NSString *binaryImagesDescription;

@end

NS_ASSUME_NONNULL_END
