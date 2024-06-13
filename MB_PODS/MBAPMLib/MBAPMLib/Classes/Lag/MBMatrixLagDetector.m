//
//  MBAPMPluginManager.m
//  YMMPerformanceModule
//
//  Created by 别施轩 on 2021/8/6.
//

#import "MBMatrixLagDetector.h"
#import "MBMatrixLagDetectorReportModel.h"
#import "MBMatrixWechatManager.h"
#import <UIKit/UIKit.h>

static const int kDeadLagThreadshold = 5 * 1000; //卡死时长阀值
static const int kLongLagThreadshold = 3 * 1000; //长卡顿时长阀值
static const int kReoprtDelayThreadshold = 3; // 延迟发reprot的时间

@interface MBMatrixLagDetector () <WCCrashBlockMonitorDelegate>
{
    uint64_t _blockTime;
}

@property (nonatomic, strong) MBAPMLagDetectCallback callback;

@end

@implementation MBMatrixLagDetector

- (void)keep
{
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}

- (void)startLagDetector:(MBAPMLagDetectCallback)callback {
    __weak typeof(self) weakSelf = self;
    [[MBMatrixWechatManager sharedInstance] setLagTimeBlock:^(uint64_t lagTime) {
        [weakSelf onLagWithBlockTime:lagTime];
    }];
    [[MBMatrixWechatManager sharedInstance] setLagReportModelBlock:^(MatrixReportModel * _Nonnull reportModel) {
        [weakSelf onLagWithReportModel:reportModel];
    }];
    self.callback = callback;
}

- (void)stopLagDetector {
    
}


// 报告report，根据卡顿发生的时间间隔判断卡顿类型，尽量跟自研策略保持一致
- (void)reportLag:(MatrixReportModel *)reportModel {
    double blockTime = _blockTime / 1000.0;
    MBAPMLagType lagType;
    if (blockTime > kDeadLagThreadshold) {
        lagType = MBAPMLagTypeDead;
    }
    else if (blockTime > kLongLagThreadshold) {
        lagType = MBAPMLagTypeLong;
    }
    else {
        lagType = MBAPMLagTypeShort;
    }
    id systemInfo = [reportModel.system yy_modelToJSONObject];
    NSDictionary * systemDic;
    if ([systemInfo isKindOfClass:[NSDictionary class]]) {
        systemDic = (NSDictionary *)systemInfo;
    }
    // 返回两个String。第一个是栈信息，第二个是关键栈。
    NSArray<NSString *> *reportTexts = reportModel.reportTexts;
    if(self.callback != nil && reportTexts.firstObject.length > 0 && reportTexts.lastObject.length > 0) {
        NSString *name = [NSString stringWithFormat:@"matrix %ld: %@", reportModel.dumpType, reportTexts.lastObject];
        self.callback(MBAPMReportChannelMatrix, lagType, reportTexts.firstObject, name,  reportModel.report.timestamp, blockTime, systemDic ?: @{}, reportModel.dumpType);
    }
}

// ============================================================================
#pragma mark - WCCrashBlockMonitorDelegate
// ============================================================================

- (void)onLagWithBlockTime:(uint64_t)blockTime
{
    // 会返回卡顿总时间
    _blockTime = blockTime;
}

- (void)onLagWithReportModel:(MatrixReportModel *)reportModel {
    [self reportLag:reportModel];
}

@end
