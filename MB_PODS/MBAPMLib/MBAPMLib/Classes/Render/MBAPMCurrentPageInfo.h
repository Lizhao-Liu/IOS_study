//
//  MBAPMCurrentPageInfo.h
//  MBAPMLib
//
//  Created by 别施轩 on 2023/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMCurrentPageInfo : NSObject
+ (MBAPMCurrentPageInfo *)sharedInstance;

+ (NSString * _Nullable)currentPageName;
+ (NSString * _Nullable)currentPageClassName;
+ (NSString * _Nullable)currentPagePath;

/// xxxx 腾讯地图主线程加锁，等待子线程image加载，mbhook大图，获取pageName
/// 注意：前置有hook系统方法过来的，调用这个，这么没有主线程提交任务块。不会死锁。虽然不精准，但是可用
+ (NSString * _Nullable)noMainThreadCurrentPageName;

// 若未命中apm内部灰度，返回NO；若在页面加载判断过程中，返回YES，直至判断结束。
+ (BOOL)currentPageIsLoading;

@end

NS_ASSUME_NONNULL_END
