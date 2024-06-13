//
//  MBAPMDataManager.h
//  AAChartKit
//
//  Created by FDW on 2024/2/21.
//

#import <Foundation/Foundation.h>
#import "MBAPMModel.h"
#import "MBAPMDataModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UploadTraffic)(MBAPMDataModel *model);

@interface MBAPMDataManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) UploadTraffic uploadTraffic;


- (void)updateTrafficModel:(MBAPMModel *)model;

// 读取上一天的流量
- (void)readCacheDayData;

// 上次进程流量
- (nullable MBAPMDataModel *)lastProcessData;

// 进程的和天的流量,需要定时储存本地,上传的时候可能是下次进程
- (void)cacheTraffic;

// 上个时间段的分钟流量
- (MBAPMDataModel *)lastMinData;
@end

NS_ASSUME_NONNULL_END
