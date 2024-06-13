//
//  MBAPMCpuMonitorConfig.h
//  MBAPMLib
//
//  Created by FDW on 2022/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMCpuMonitorConfig : NSObject
/// 设置插件是否启用,默认为 YES  cpu_gather_switch
@property (nonatomic, assign) BOOL isEnable;

/// 正常采样时间间隔,默认为 5s
@property (nonatomic, assign) NSInteger gather_interval;
/// 正常采样频次, 默认为 24 次
@property (nonatomic, assign) NSInteger gather_count;
/// 异常采样单个线程阀值,默认为 5%
@property (nonatomic, assign) NSInteger gather_threshold;
/// 异常采样总线程阀值,默认为 80%
@property (nonatomic, assign) NSInteger total_gather_threshold;
/// 异常采样时间间隔,默认为 1s
@property (nonatomic, assign) NSInteger exception_gather_interval;
/// 异常采样时间次数,默认为 60 次
@property (nonatomic, assign) NSInteger exception_gather_count;

- (instancetype)initWithConfigDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
