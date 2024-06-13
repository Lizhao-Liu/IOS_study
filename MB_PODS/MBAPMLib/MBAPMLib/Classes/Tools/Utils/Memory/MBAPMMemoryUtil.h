//
//  MBAPMMemoryUtil.h
//  MBAPMLib
//
//  Created by xp on 2020/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMMemoryUtil : NSObject

+ (CGFloat)appMemoryUsage;

+ (CGFloat)totalMemoryUsage;

+ (CGFloat)availableMemory;

+ (NSInteger)totalMemoryForDevice;

@end

NS_ASSUME_NONNULL_END
