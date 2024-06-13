//
//  MBAPMStorageMonitor.m
//  Pods
//
//  Created by xp on 2023/8/23.
//

#import "MBAPMStorageMonitor.h"
#import "MBDeviceInfo.h"
@import MBFoundation;
@import MBDoctorService;
#import "MBAPMLogDef.h"
#import "MBAPMStorageUtil.h"
#import "MBAPMServiceContext.h"
#import "MBAPMStorageMonitorConfig.h"

typedef struct MBAPMStorageTotalSize {
    UInt64 totalSize;
    UInt64 filterTotalSize;
    
}MBAPMStorageTotalSize;

@interface MBAPMStorageMonitor()  {
    dispatch_queue_t queue;
}

@end

@implementation MBAPMStorageMonitor



- (void)abort {
    [super abort];
}

- (void)destroy {
    [super destroy];
}

- (BOOL)isSelfStart {
    return NO;
}

+ (BOOL)isSingleton {
    return YES;
}

- (MBAPMPluginTag)pluginTag {
    return MBAPMPluginTagStorage;
}

+ (nonnull id)shareInstance {
    static MBAPMStorageMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MBAPMStorageMonitor alloc]init];
    });
    return instance;
}

- (void)start {
    [super start];
//    if (![MBDeviceInfo canEnableMonitor]) {
//        MBAPMLogInfo(@"storage monitor can't be started on simulator or debugging status");
//        return;
//    }
    MBAPMLogInfo(@"StorageMonitor plugin start");
    NSString *idleNotificationName = @"MBAPMStorageMonitorNotiNSPostWhenIdle";
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(isIdleNoti) name:idleNotificationName object:nil];
    queue = dispatch_queue_create("mb_apm_storagemonitor_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [self getStorgeMonitorPluginConfig].delayTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSNotification *noti = [NSNotification notificationWithName:idleNotificationName object:nil];
        [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostWhenIdle];
    });
}

- (void)stop {
    [super stop];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Private Methods
- (MBAPMStorageTotalSize)traverseDirectory:(NSString *)path fileSizeDict:(NSMutableDictionary<NSString *, NSNumber *> *)fileSizeDict bigFileSizeDict:(NSMutableDictionary<NSString *, NSNumber *> *)bigFileSizeDict bigDirSizeAndFileCountDict:(NSMutableDictionary<NSString *,  NSDictionary<NSString *, NSNumber *> *> *)bigDirSizeAndFileCountDict fileRegExpDict:(NSDictionary<NSString *, NSArray<NSString *> *> *)fileRegExpDict  maxDirLevel:(NSInteger)maxLevel curLevel:(NSInteger)curLevel{
    struct MBAPMStorageTotalSize currentLevelTotalSize;
    currentLevelTotalSize.totalSize = 0;
    currentLevelTotalSize.filterTotalSize = 0;
    if (!path) {
        return currentLevelTotalSize;
    }
    UInt64 curLevelFileSize = 0;
    UInt64 curLevelFileCount = 0;
    UInt64 curLevelFilterFileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    NSString *absolutePath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    BOOL isExist = [fileManager fileExistsAtPath:absolutePath isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:absolutePath error:nil];
            for(NSString *fileName in fileArray) {
                NSString *subFilePath = [path stringByAppendingPathComponent:fileName];
                MBAPMStorageTotalSize dirSizeStruct = [self traverseDirectory:subFilePath fileSizeDict:fileSizeDict  bigFileSizeDict: bigFileSizeDict bigDirSizeAndFileCountDict:bigDirSizeAndFileCountDict fileRegExpDict:fileRegExpDict maxDirLevel:maxLevel curLevel:curLevel + 1];
                curLevelFileSize += dirSizeStruct.totalSize;
                if (![[self getStorgeMonitorPluginConfig].totalSizeFilterList containsObject:subFilePath]) {
                    curLevelFilterFileSize += dirSizeStruct.filterTotalSize;
                }
            }
            curLevelFileCount += fileArray.count;
            if ([[self getStorgeMonitorPluginConfig].dirWhiteList containsObject:path]) {
                [fileSizeDict setValue:@(curLevelFileSize) forKey:path];
            } else {
                if (curLevel <= maxLevel) {
                    if (![NSString mb_isNilOrEmpty:path] && curLevelFileSize > [self getStorgeMonitorPluginConfig].bigDirThreshold) {
                        [fileSizeDict setValue:@(curLevelFileSize) forKey:path];
                        MBAPMLogInfo(@"storageMonitor found big dir path = %@, size = %@", path, [self transferSizeToString:curLevelFileSize]);
                    }
                }
            }
            if (![NSString mb_isNilOrEmpty:path] && curLevelFileSize > [self getStorgeMonitorPluginConfig].bigFileThreshold) {
                NSArray<NSString *> *fileRegExpArray = [fileRegExpDict objectForKey:path];
                NSMutableDictionary<NSString *, NSObject *> *dirInfoDic = [NSMutableDictionary new];
                NSMutableDictionary<NSString *, NSNumber *> *fileNameMatchedCountDict = [NSMutableDictionary new];
                [dirInfoDic setObject:@(curLevelFileSize) forKey:@"dirSize"];
                [dirInfoDic setObject:@(curLevelFileCount) forKey:@"dirFileCount"];
                for(NSString *fileName in fileArray) {
                    if (fileRegExpArray.count > 0) {
                        for(NSString *fileRegExp in fileRegExpArray) {
                            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:fileRegExp options:NSRegularExpressionCaseInsensitive error:nil];
                            if ([regular numberOfMatchesInString:fileName options:0 range:NSMakeRange(0, fileName.length)]) {
                                NSNumber *fileNameMatchedCount = [fileNameMatchedCountDict objectForKey:fileRegExp];
                                if (fileNameMatchedCount) {
                                    [fileNameMatchedCountDict setObject:@(fileNameMatchedCount.integerValue + 1) forKey:fileRegExp];
                                } else {
                                    [fileNameMatchedCountDict setObject:@(1) forKey:fileRegExp];
                                }
                            }
                        }
                    }
                }
                if (fileNameMatchedCountDict.count > 0) {
                    [dirInfoDic setObject:fileNameMatchedCountDict forKey:@"fileRegExpMatchedCount"];
                }
                [bigDirSizeAndFileCountDict setValue:dirInfoDic.copy forKey:path];
            }
        } else {
            //文件
            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:absolutePath error:nil];
            NSInteger size = [dict[@"NSFileSize"] integerValue];
            curLevelFileSize = size;
            if (size > [self getStorgeMonitorPluginConfig].bigFileThreshold) {
                [bigFileSizeDict setValue:@(size) forKey:path];
                MBAPMLogInfo(@"storageMonitor found big file path = %@, size = %@", path, [self transferSizeToString:size]);
            }
            // 只针对白名单路径才放到埋点数据的metric.sections中，避免出现sections中取值数量太多问题
            if ([[self getStorgeMonitorPluginConfig].dirWhiteList containsObject:path]) {
                [fileSizeDict setValue:@(size) forKey:path];
            }
            if (![[self getStorgeMonitorPluginConfig].totalSizeFilterList containsObject:path]) {
                curLevelFilterFileSize = size;
            }
        }
    }
    currentLevelTotalSize.totalSize = curLevelFileSize;
    currentLevelTotalSize.filterTotalSize = curLevelFilterFileSize;
    return currentLevelTotalSize;
}

- (void)isIdleNoti {
    dispatch_async(queue, ^{
        MBAPMLogInfo(@"StorageMonitor start");
        NSMutableDictionary<NSString *, NSNumber *> *fileSizeDict = [NSMutableDictionary new];
        NSMutableDictionary<NSString *, NSNumber *> *bigFileSizeDict = [NSMutableDictionary new];
        NSMutableDictionary<NSString *, NSDictionary<NSString *, NSNumber *> *> *bigDirSizeAndFileCountDict = [NSMutableDictionary new];
        NSInteger maxLevel = [self getStorgeMonitorPluginConfig].uploadDirMaxDepth;
        MBAPMStorageTotalSize totalSizeStruct = [self traverseDirectory:@"" fileSizeDict:fileSizeDict bigFileSizeDict:bigFileSizeDict bigDirSizeAndFileCountDict:bigDirSizeAndFileCountDict fileRegExpDict:[self getStorgeMonitorPluginConfig].fileRegExpDic maxDirLevel:maxLevel curLevel:0];
        [fileSizeDict setValue:@([MBAPMStorageUtil getAvailableStorageBitSize]) forKey:@"storage_available_size"];
        [fileSizeDict setValue:@(totalSizeStruct.filterTotalSize) forKey:@"filter_total_size"];
        MBDoctorEventCustom *event = [[MBDoctorEventCustom alloc]initWithPlatform:MBDoctorPlatformHubble];
        event.metricName = @"app_storage_usage";
        event.metricType = MBDoctorMetricTypeGauge;
        event.metricValue = totalSizeStruct.totalSize;
        event.metricSections = fileSizeDict;
        NSMutableDictionary *attrs = [NSMutableDictionary new];
        [attrs setValue:bigFileSizeDict?:@{} forKey:@"big_files"];
        [attrs setValue:bigDirSizeAndFileCountDict?:@{} forKey:@"big_dirs"];
        event.attrs = attrs.copy;
        MBAPMServiceContext *serviceContext = [[MBAPMServiceContext alloc]init];
        id<MBDoctorServiceProtocol> doctorService = BIND_SERVICE(serviceContext, MBDoctorServiceProtocol);
        [doctorService doctor:event];
        MBAPMLogInfo(@"StorageMonitor end totalSize = %@, filterTotalSize = %@", [self transferSizeToString:totalSizeStruct.totalSize], [self transferSizeToString:totalSizeStruct.filterTotalSize]);
    });
}

- (NSString *)transferSizeToString:(UInt64)size {
    NSString *fileSizeStr = nil;
    if (size > 1024 * 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fM",size / 1024.00f /1024.00f];
        
    }else if (size > 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fKB",size / 1024.00f ];
        
    }else{
        fileSizeStr = [NSString stringWithFormat:@"%.2fB",size / 1.00f];
    }
    return fileSizeStr;
}

- (MBAPMStorageMonitorConfig *)getStorgeMonitorPluginConfig {
    if ([self.config isKindOfClass:MBAPMStorageMonitorConfig.class]) {
        return (MBAPMStorageMonitorConfig *)self.config;
    }
    return nil;
}


@end
