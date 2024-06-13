//
//  MBMatrixWechatManager.h
//  MBAPMLib
//
//  Created by 别施轩 on 2021/8/10.
//

#import <Foundation/Foundation.h>
@import Matrix;
#import "MBMatrixLagDetectorReportModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MBMatrixLagTimeBlock)(uint64_t lagTime);

typedef void(^MBMatrixLagReportBlock)(MatrixReportModel *reportModel);

typedef void(^MBMatrixFOOMReportBlock)(MatrixIssue *issue);

typedef NSDictionary * _Nullable (^MBMatrixAdditionalInfoBlock)(void);

typedef void(^MBMatrixCrashReportBlock)(MatrixReportModel *reportModel);

typedef void (^MBMatrixCrashHandleStartBlock)(NSString *crashType);

@interface MBMatrixConfig : NSObject

@property (nonatomic, assign) BOOL enableCrashMonitor;

@property (nonatomic, assign) BOOL enableBlockMonitor;

@end

@interface MBMatrixWechatManager : NSObject

@property (nonatomic, copy) MBMatrixAdditionalInfoBlock additionalInfoBlock;

@property (nonatomic, copy)MBMatrixCrashHandleStartBlock crashHandlStartBlock;


+ (MBMatrixWechatManager *)sharedInstance;


- (void)installBlockPlugin:(MBMatrixConfig *)config;

- (void)installMemoryPluginWithConfigDic:(NSDictionary<NSString *, NSNumber *> *)dic;

- (WCCrashBlockMonitorPlugin *)getCrashBlockPlugin;

- (WCMemoryStatPlugin *)getMemoryStatPlugin;


// 以下两个block将在发生lag的时候调用

- (void)setLagTimeBlock:(MBMatrixLagTimeBlock)block;

- (void)setLagReportModelBlock:(MBMatrixLagReportBlock)block;

// 发生前台OMM后，App重新启动会调用
- (void)setFOOMReportBlock:(MBMatrixFOOMReportBlock)block;

// 设置App崩溃回调
- (void)setCrashReportBlock:(MBMatrixCrashReportBlock)block;

// 设置App卡死崩溃回调
- (void)setCrashLagReportBlock:(MBMatrixCrashReportBlock)block;

// 设置App崩溃捕获开始回调
- (void)setCrashHandleStartBlock:(MBMatrixCrashHandleStartBlock)block;

// 获取App启动原因，即上次App关闭的原因
- (NSUInteger)getAppBootType;

@end

NS_ASSUME_NONNULL_END
