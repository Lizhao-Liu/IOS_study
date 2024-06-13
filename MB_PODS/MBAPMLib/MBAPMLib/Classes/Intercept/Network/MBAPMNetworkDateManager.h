//
//  MBAPMNetworkDateManager.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 从当网络请求开始时候落在哪个页面即记为那个页面的网络请求
/// 1、通过缓存上一次的数据不断校正
/// 2、应当在页面完成之后再调用
@interface MBAPMNetworkDateManager : NSObject

+ (MBAPMNetworkDateManager *)sharedInstance;

- (NSArray<NSDictionary *> *)urlsInfoOfThePageName:(NSString *)pageName;

- (double)totalTimeOfThePageName:(NSString *)pageName;

- (double)beginTimeOfThePageName:(NSString *)pageName;

@end

NS_ASSUME_NONNULL_END
