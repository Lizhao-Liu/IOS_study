//
//  MBDebugMonitorLogDataSource.h
//  MBDebug
//
//  Created by Lizhao on 2023/7/10.
//

#import <Foundation/Foundation.h>
#import "MBDebugMonitorDefine.h"

NS_ASSUME_NONNULL_BEGIN


@interface MBDebugMonitorLogDataSource : NSObject <MBDebugMonitorLogDataSourceProtocol>

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMonitorTitle:(NSString *)title;

- (NSArray<MBDebugMonitorPageInfoModel *> *)pageInfosWithPageVC:(UIViewController *)pageVC;

@end

NS_ASSUME_NONNULL_END
