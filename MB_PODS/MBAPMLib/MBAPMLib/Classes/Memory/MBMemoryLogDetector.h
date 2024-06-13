//
//  MBMemoryLogDetector.h
//
//
//  Created by seal on 2022/5/30.
//

#import <Foundation/Foundation.h>
#import "MBAPMViewPageContext.h"

NS_ASSUME_NONNULL_BEGIN

//# 单个存储类：单个页面对象的单个事件（page_load, page_apper, page_disappear, page_deinit等事件）
@interface MBMemoryLogModel : NSObject

@property (nonatomic, assign) NSUInteger runTime;
@property (nonatomic, assign) CGFloat deviceTotalMemory;
@property (nonatomic, assign) CGFloat appMemoryUsage;
@property (nonatomic, assign) CGFloat appMemoryUsagePercent;
@property (nonatomic, assign) CGFloat availableMemory;
@property (nonatomic, assign) CGFloat availableMemoryPercent;
@property (nonatomic, copy) NSString *pageEvent; // page_load, page_apper, page_disappear, page_deinit
@property (nonatomic, strong) NSString *objcetPointer; // 页面指针地址，用于区分不同对象
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, assign) CGFloat peakMemory;

- (NSDictionary *)jsonMessage; // 上报时候在history json_arr的单个json数据

@end

typedef void(^MemonryIncrement)(CGFloat increment, CGFloat peakIncrement, MBMemoryLogModel* loadMemory, MBMemoryLogModel* current);
typedef void(^MemonryAvgIncrement)(CGFloat increment, CGFloat peakIncrement, CGFloat avgPeakIncrement, NSArray *memorys, MBMemoryLogModel *current);

//# list存储类/处理类：单个页面对象的所有事件进入此类处理
@interface MBMemoryLogListModel : NSObject
@property (nonatomic, strong) NSString *pageName;

//# 追加页面事件
- (void)appendMemoryLogViewDidLoad:(MBMemoryLogModel *)memory;
- (void)appendMemoryLogViewAppear:(MBMemoryLogModel *)memory;
- (void)appendMemoryLogViewDisappear:(MBMemoryLogModel *)memory;
- (void)appendMemoryLogViewDealloc:(MBMemoryLogModel *)memory;

// 求平均的个数配置
- (void)setAvgMemoryTimes:(NSUInteger)times;

//# 回调，在合适时机回调 首次内存上报 和 平均值内存上报
@property (nonatomic, copy) MemonryIncrement firstDisappearMemoryIncrementBlock;
@property (nonatomic, copy) MemonryAvgIncrement avgMemoryIncrementBlock;

@end

typedef void(^MemoryLogCallback)(MBMemoryLogModel * model);

/// 内存使用统计
@interface MBMemoryLogDetector : NSObject

+ (MBMemoryLogModel *)lastMemoryLog;

+ (CGFloat)appLaunchMBLastMemoryPercent;

+ (CGFloat)appLaunchMBLastFreeMemoryPercent;

//# 回调，三种内存log的回调，灰度
- (void)startMemoryLogDetectorWithCallBack:(MemoryLogCallback)callback;
- (void)startFirstDisappearMemoryLogDetectorWithCallBack:(MemonryIncrement)callback;
- (void)startMemonryAvgIncrementDetectorWithCallBack:(MemonryAvgIncrement)callback;
// 上述第一种log增加了一个上报情况，每增5%上报一次，全量
- (void)begainRefreshMemoryLogWithCallBack:(MemoryLogCallback)callback;

- (void)stopMemoryLogDetector;

// 类型一、基于固定时间间隔的内存log
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) NSString *timeIntervals;

@property (nonatomic, assign) NSUInteger avgTotalTimes;

// 类型二、基于页面的内存记录，第一次退出以及销毁上报
// 类型三、基于页面的去第一次之后的，页面平均差值
//# 对接页面事件 *原始调用是从 UIViewController+MBAPMRenderMonitor
- (void)didPageLoad:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)didPageIn:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)didPageOut:(MBAPMViewPageContext * _Nonnull)pageContext;

- (void)didPageDealloc:(MBAPMViewPageContext *)pageContext;

@end

NS_ASSUME_NONNULL_END
