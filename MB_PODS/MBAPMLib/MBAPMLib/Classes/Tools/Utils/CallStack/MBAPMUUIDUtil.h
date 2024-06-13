//
//  MBAPMUUIDUtil.h
//  MBAPMLib
//
//  Created by xp on 2020/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMUUIDUtil : NSObject


/// 获取当前Image的UUID
+ (NSString *)getCurrentImageUUID;


/// 获取主Image的UUID
+ (NSString *)getMainImageUUID;


/// 获取所有Image的UUID列表
+ (NSDictionary<NSString *, NSString *> *)getAllImageUUIDs;


+ (NSArray<NSDictionary<NSString *, NSString *> *> *)getUnsystemImageUUIDs;

/// 获取崩溃日志使用的二进制信息
///
///      Binary Images:
///      0x10292c000 - 0x111111fff APMExample arm64  <408324dfd2d43968a63cb4dd289aedca> /placeholder/path
///      0x102c00000 - 0x111111fff libobjc-trampolines.dylib arm64e  <2666fd529ed035d49a64ddaf321f8a31> /placeholder/path
+ (NSString *)getBinaryImagesDescription;


/// 获取主Image名称
+ (NSString *)getMainImageName;

@end

NS_ASSUME_NONNULL_END
