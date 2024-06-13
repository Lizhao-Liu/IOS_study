//
//  MBCpuDataGatherManager.h
//  MBAPMLib
//
//  Created by FDW on 2022/5/24.
//

#import <Foundation/Foundation.h>
#import "MBThreadStackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBCpuDataGatherManager : NSObject
@property (nonatomic, strong, readonly) NSMutableArray *cpuUsageArray;
@property (nonatomic, strong, readonly) NSMutableArray *cpuRateArray;

@property (nonatomic, strong, readonly) NSMutableArray *exceptionStackArray;
@property (nonatomic, strong, readonly) NSMutableArray *cpuExceptionUsageArray;

+ (instancetype)sharedInstance;
#pragma mark - normal

- (void)addCpuUsageRecord:(CGFloat )usage;
- (void)addCpuRateRecord:(CGFloat )rate;

- (CGFloat )getAverageCPUUsage;
- (CGFloat )getAverageRate;

- (void)clearCpuUsageRecord;
- (void)clearCpuRateRecord;

#pragma mark - exception
- (void)addExceptionModel:(MBThreadStackModel *)model;
- (void)addCpuExceptionUsageRecord:(CGFloat )usage;

- (CGFloat )getAverageCPUExceptionUsage;
- (CGFloat )getSumCPUExceptionUsage;
- (NSArray *)getExceptionModels;

- (void)clearExceptionModelsRecord;
- (void)clearCpuExceptionUsageRecord;

@end

NS_ASSUME_NONNULL_END
