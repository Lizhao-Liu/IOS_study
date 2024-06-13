//
//  MBAPMStorageMonitorConfig.h
//  Pods
//
//  Created by xp on 2023/8/23.
//

#import <Foundation/Foundation.h>

@import MBAPMServiceLib;

#import "MBAPMPluginConfig.h"


NS_ASSUME_NONNULL_BEGIN

@interface MBAPMStorageMonitorConfig : MBAPMPluginConfig

/// 上报文件路径的最大深度
@property (nonatomic, assign) NSInteger uploadDirMaxDepth;


/// 检测延迟时间
@property (nonatomic, assign) NSTimeInterval delayTime;

/// 判定为大文件的文件大小阈值
@property (nonatomic, assign) UInt64 bigFileThreshold;

/// 判定为大文件目录的文件大小阈值
@property (nonatomic, assign) UInt64 bigDirThreshold;


/// 目录白名单，没有最低文件大小和最大深度限制限制，目录占用空间大小都会上报
@property (nonatomic, strong) NSArray<NSString *> *dirWhiteList;

/// 计算总大小时需要过滤的目录
@property (nonatomic, strong) NSArray<NSString *> *totalSizeFilterList;


///  在做文件数量统计时，除了统计目录文件总数以外，还可以通过正则表达式统计符合特定规则的文件数量
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *fileRegExpDic;

@end

@interface MBAPMConfiguration(StorageMonitor)

@property (nonatomic, strong) MBAPMStorageMonitorConfig *storageMonitorConfig;

@end

NS_ASSUME_NONNULL_END
