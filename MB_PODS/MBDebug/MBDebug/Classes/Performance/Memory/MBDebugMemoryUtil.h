//
//  MBDebugMemoryUtil.h
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBDebugMemoryUtil : NSObject

//当前app内存使用量
+ (NSInteger)useMemoryForApp;

//设备总的内存
+ (NSInteger)totalMemoryForDevice;

@end

NS_ASSUME_NONNULL_END
