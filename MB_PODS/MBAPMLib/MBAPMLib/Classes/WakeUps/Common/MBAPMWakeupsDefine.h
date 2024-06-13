//
//  MBAPMWakeupsDefine.h
//  Pods
//
//  Created by zhaozhao on 2024/3/14.
//

#import "MBAPMMetric.h"
#import "MBAPMWakeupsExceptionStateModel.h"
@import MBDoctorService;

#ifndef MBAPMWakeupsDefine_h
#define MBAPMWakeupsDefine_h


#define MBAPMWakeupsContinuousHighExceptionCacheKey @"MBAPMWakeupsContinuousHighExceptionCacheKey"
#define MBAPMWakeupsSuddenIncreaseCacheKey @"MBAPMWakeupsSuddenIncreaseCacheKey"
#define MBAPMWakeupsExceedLimitCacheKey @"MBAPMWakeupsExceedLimitCacheKey"

typedef void(^MBAPMWakeupsExceptionReportBlock)(MBAPMMetric *metric);

#endif /* MBAPMWakeupsDefine_h */
