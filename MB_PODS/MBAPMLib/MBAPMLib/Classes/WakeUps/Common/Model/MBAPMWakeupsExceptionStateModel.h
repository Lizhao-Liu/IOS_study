//
//  MBAPMWakeupsExceptionCrashModel.h
//  MBAPMLib
//
//  Created by Lizhao on 2024/1/9.
//

#import <Foundation/Foundation.h>
#import "MBAPMDoctorEventModel.h"

#define WakeupsExceptionCacheKey @"MBAPMWakeupsExceptionCacheKey"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBAPMWakeupsExceptionType) {
    MBAPMWakeupsExceptionTypeAvgLimitExceeded,
    MBAPMWakeupsExceptionTypeSuddenIncrease,
    MBAPMWakeupsExceptionTypeContinuousHigh
};

@interface MBAPMWakeupsExceptionStateModel : NSObject

@property (nonatomic, assign) MBAPMWakeupsExceptionType type;

@property (nonatomic, assign) NSInteger continuousExceptionCount; // 异常连续次数

@property (nonatomic, strong) NSArray *continuousExceptionValues; // 连续异常取值

@property (nonatomic, assign) NSInteger exceptionValue; // 异常取值

@property (nonatomic, strong) MBAPMDoctorEventModel *actionModel; // 行为事件 类型为突增时使用

@property (nonatomic, copy) NSString *pageId; // 页面

@end


NS_ASSUME_NONNULL_END
