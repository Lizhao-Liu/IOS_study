//
//  MBAPMStorageMonitorConfig.m
//  Pods
//
//  Created by xp on 2023/8/23.
//

#import "MBAPMStorageMonitorConfig.h"

#import <objc/runtime.h>



@implementation MBAPMStorageMonitorConfig

- (instancetype)init {
    if (self = [super init]) {
        _uploadDirMaxDepth = 2;
        _delayTime = 5;
        _bigFileThreshold = 10 * 1024 * 1024;
        _bigDirThreshold = 100 * 1024 * 1024;
    }
    return self;
}

@end

@implementation MBAPMConfiguration(StorageMonitor)

- (MBAPMStorageMonitorConfig *)storageMonitorConfig {
    return objc_getAssociatedObject(self, @selector(storageMonitorConfig));
}

- (void)setStorageMonitorConfig:(MBAPMStorageMonitorConfig *)storageMonitorConfig {
    objc_setAssociatedObject(self, @selector(storageMonitorConfig), storageMonitorConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

