//
//  MBAPMDataExportManager.h
//  MBAPMLib
//
//  Created by xp on 2020/7/23.
//

#import <Foundation/Foundation.h>
#import "MBAPMContext.h"
#import "MBAPMPageRenderMetricStatistic.h"

NS_ASSUME_NONNULL_BEGIN

@class MBAPMMetric;

@protocol MBAPMDataExportProtocol <NSObject>

- (void)exportMetricData:(MBAPMMetric *)metric;



@end

@interface MBAPMDataExportManager : NSObject <MBAPMDataExportProtocol>

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithContext:(MBAPMContext *)context;

@end

NS_ASSUME_NONNULL_END
