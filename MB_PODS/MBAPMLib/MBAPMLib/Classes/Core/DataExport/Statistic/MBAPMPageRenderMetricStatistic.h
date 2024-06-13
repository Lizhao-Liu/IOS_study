//
//  MBAPMPageRenderMetricStatistic.h
//  MBAPMLib
//
//  Created by xp on 2020/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMPageRenderMetricStatistic : NSObject

@property (nonatomic, strong) NSString *pageName;

@property (nonatomic, assign) float successRate;

@property (nonatomic, assign) long long avgTime;

@end

NS_ASSUME_NONNULL_END
