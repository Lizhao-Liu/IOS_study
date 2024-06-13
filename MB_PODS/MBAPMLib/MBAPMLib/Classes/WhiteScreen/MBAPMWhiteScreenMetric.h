//
//  MBAPMWhiteScreenMetric.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/7/24.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MBAPMWhiteScreenMetricReportTypeWhiteScreen,
    MBAPMWhiteScreenMetricReportTypeWhiteScreenDetect,
    MBAPMWhiteScreenMetricReportTypeFrequentWhiteScreen,
    MBAPMWhiteScreenMetricReportTypeTechStackFrequentWhiteScreen,
} MBAPMWhiteScreenMetricReportType;

@interface MBAPMWhiteScreenMetric : MBAPMMetric
@property (nonatomic, strong) NSString *apmVersion;
@property (nonatomic, assign) MBAPMWhiteScreenMetricReportType reportType;

@property (nonatomic, strong) NSString* errorFeature;
@property (nonatomic, strong) NSString* exceptionType;
@property (nonatomic, strong) NSString* lastStep;
@property (nonatomic, strong) NSString* source;
@property (nonatomic, strong) NSDictionary* attrs;
@property (nonatomic, strong) MBModuleInfo *moduleInfo;

// 以上是结果指标 -- 以下是白屏性能指标

@property (nonatomic, assign) NSInteger bitmapDtectResult;
@property (nonatomic, assign) BOOL isCaptured;
///是否检测完成，只有最后分析截屏图片得出是否白屏的结果才能判定为检测完成，1：完成，0：未完成
@property (nonatomic, assign) BOOL isFinished;
/// 当is_finished为0时必传
/// 枚举值：page_exit(页面退出)，first_layout（页面完成第一次渲染），dialog_exist(存在弹窗页面)，capture_fail(截图失败)
@property (nonatomic, strong) NSString* interruptType;
@property (nonatomic, assign) BOOL isWhiteScreen;
@property (nonatomic, assign) CGFloat captureCostTime;
@property (nonatomic, assign) CGFloat analysisCostTime;
@property (nonatomic, assign) NSInteger timeoutDuration;
@property (nonatomic, assign) CGFloat captureRatio;
@property (nonatomic, assign) CGFloat whitepixelRatio;
@property (nonatomic, assign) BOOL hasBitMap;

@end

NS_ASSUME_NONNULL_END
