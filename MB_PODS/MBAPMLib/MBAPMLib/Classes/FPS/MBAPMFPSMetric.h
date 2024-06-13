//
//  MBAPMFPSMetric.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/7/17.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MBAPMFPSMetricTypePageAvg,
    MBAPMFPSMetricTypeScroll,
} MBAPMFPSMetricType;

@interface MBAPMFPSMetric : MBAPMMetric

@property (nonatomic, assign) MBAPMFPSMetricType type;
@property (nonatomic, strong) NSString *deviceLevel;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *fpsDetail;
@property (nonatomic, strong) NSString *cpuDetail;
@property (nonatomic, strong) NSString *apmVersion;
@property (nonatomic, assign) BOOL isHighFps;

@property (nonatomic, strong) MBModuleInfo *moduleInfo;
@end

NS_ASSUME_NONNULL_END
