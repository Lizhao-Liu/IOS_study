//
//  TMSColdLaunchManger.h
//  MBTMSModule
//
//  Created by ymm_lzz on 2022/9/5.
//

#import <Foundation/Foundation.h>
@import MBFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface TMSColdLaunchManger : NSObject

// 是否调用过冷启动弹框的接口。保证登录后只调用一次。
@property (nonatomic, assign) BOOL hasLoadCommonPopupRequest;

DEFINE_SINGLETON_FOR_HEADER(TMSColdLaunchManger)

// 处理冷启动弹框接口请求
- (void)handleClodLaunchTaskRequest;

@end

NS_ASSUME_NONNULL_END
