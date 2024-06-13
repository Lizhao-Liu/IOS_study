//
//  MBAPMURLSessionDemux.h
//  AAChartKit
//
//  Created by FDW on 2024/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMURLSessionDemux : NSObject

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration;

@property (atomic, copy,   readonly ) NSURLSessionConfiguration *   configuration;

@property (atomic, strong, readonly ) NSURLSession *                session;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request delegate:(id<NSURLSessionDataDelegate>)delegate modes:(NSArray *)modes;

@end

NS_ASSUME_NONNULL_END
