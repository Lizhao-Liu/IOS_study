//
//  MBDebugCPUUtil.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugCPUUtil : NSObject


//获取CPU使用率
+ (CGFloat)cpuUsageForApp;

@end

NS_ASSUME_NONNULL_END
