//
//  MBAPMAppLaunchTimeModel.h
//  MBAPMLib
//
//  Created by xp on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMAppLaunchTimeModel : NSObject


/// App进程启动到第一个页面viewDidAppear耗时
@property (nonatomic, assign) UInt64 elapsedTime;

/// 第一个页面viewDidAppear时间戳
@property (nonatomic, assign) UInt64 endTimestamp;

/// 第一个页面是否为TabBarViewController
@property (nonatomic, assign) BOOL isMainPage;

@end

NS_ASSUME_NONNULL_END
