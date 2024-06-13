//
//  MBAPMFPSDataManager.h
//  AAChartKit-AAChartKitLib
//
//  Created by 别施轩 on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MBModuleInfo;

@interface MBAPMFPSDataResponse : NSObject
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, copy) NSString *pageClassName;
@property (nonatomic, copy) NSString *pagePath;

@property (nonatomic, assign) CGFloat fpsScore;
@property (nonatomic, assign) CGFloat fpsAvg;
@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, copy) NSString *fpsData;
@property (nonatomic, copy) NSString *cpuData;

@property (nonatomic, strong) MBModuleInfo *moduleInfo;

@end

/// 处理数据按照文档中约定的结果返回：
/// https://wiki.amh-group.com/pages/viewpage.action?pageId=645438978
@interface MBAPMFPSDataManager : NSObject
+ (MBAPMFPSDataManager *)sharedInstance;

- (void)receivePageViewAppear:(NSString *)pageName moduleInfo:(MBModuleInfo *)moduleInfo;
- (void)receivePageViewDisappear:(NSString *)pageName;

//- (void)receivePageViewLaunchBegin:(NSString *)pageName;
//- (void)receivePageViewLaunchEnd:(NSString *)pageName;

- (void)receiveViewScrollBegin:(NSString *)scrollId;
- (void)receiveViewScrollEnd:(NSString *)scrollId;

- (void)receiveFps:(CGFloat)cpu;
- (void)receiveCpu:(CGFloat)cpu;

- (void)didEnterBackground;
- (void)willEnterForeground;

// 建议在异步线程调用
- (MBAPMFPSDataResponse *)pageFps:(NSString *)pageName;
//- (MBAPMFPSDataResponse *)pageLaunchFps:(NSString *)pageName;
- (MBAPMFPSDataResponse *)pageScrollFps:(NSString *)scrollId;
@end

NS_ASSUME_NONNULL_END
