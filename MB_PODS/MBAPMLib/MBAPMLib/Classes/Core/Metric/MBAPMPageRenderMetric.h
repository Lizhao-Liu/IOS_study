//
//  MBAPMPageRenderMetric.h
//  MBAPMLib
//
//  Created by xp on 2020/7/22.
//

#import <Foundation/Foundation.h>
#import "MBAPMMetric.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAPMRenderDetectStatus) {
    MBAPMRenderDetectSuccess,
    MBAPMRenderDetectTimeOut
};

@interface MBAPMPageRenderMetric : MBAPMMetric



/// 页面渲染方式
@property (nonatomic, assign) MBAPMViewPageRenderType pageType;


/// 页面渲染耗时检测方式
@property (nonatomic, assign) MBAPMViewPageRenderDetectType detectType;


/// 页面渲染结果
@property (nonatomic, assign) BOOL renderResult;


/// 页面检测状态
@property (nonatomic, assign) MBAPMRenderDetectStatus detectStatus;


/// 检测次数
@property (nonatomic, assign) int detectTimes;


/// 检测耗时
@property (nonatomic, assign) UInt64 detectDuration;


/// 分段时间
@property (nonatomic, copy) NSDictionary<NSString *, NSNumber *> *timeSections;


@end

NS_ASSUME_NONNULL_END
