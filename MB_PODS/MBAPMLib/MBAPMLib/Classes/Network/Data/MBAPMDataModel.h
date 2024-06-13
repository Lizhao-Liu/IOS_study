//
//  MBAPMDataModel.h
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMDataModelType) {
    MBAPMDataModelTypeProcess,
    MBAPMDataModelTypeDay,
    MBAPMDataModelTypeMin,
};

@interface MBAPMDataModel : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger sumTraffic;
// 每10分钟流量
@property (nonatomic, assign) NSUInteger TPM;
// 前后台
@property (nonatomic, assign) NSUInteger foregroundSumTraffic;
@property (nonatomic, assign) NSUInteger backgroundSumTraffic;

// 上行
@property (nonatomic, assign) NSUInteger upSumTraffic;
// 下行
@property (nonatomic, assign) NSUInteger downSumTraffic;

// 网络类型
@property (nonatomic, assign) NSUInteger wifiSumTraffic;
@property (nonatomic, assign) NSUInteger mobileSumTraffic;
// 针对未知情况
@property (nonatomic, assign) NSUInteger otherSumTraffic;

// 业务模块,数量不确定
@property (nonatomic, strong) NSMutableDictionary *bundleSumTraffic;

// 技术栈
@property (nonatomic, assign) NSUInteger h5SumTraffic;
@property (nonatomic, assign) NSUInteger threshSumTraffic;
@property (nonatomic, assign) NSUInteger nativeSumTraffic;

@property (nonatomic, copy) NSString *date;// 自然日,用于天计算 yyyyMMdd
@property (nonatomic, assign) MBAPMDataModelType type;
// 每 10 分钟(可配置)算了一个计算周期
@property (nonatomic, assign) NSUInteger calculationPeriod;
@end

NS_ASSUME_NONNULL_END
