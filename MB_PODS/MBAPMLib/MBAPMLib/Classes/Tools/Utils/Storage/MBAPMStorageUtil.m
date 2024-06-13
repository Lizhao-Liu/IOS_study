//
//  MBAPMStorageUtil.m
//  MBAPMLib
//
//  Created by xp on 2020/8/19.
//

#import "MBAPMStorageUtil.h"

@implementation MBAPMStorageUtil

+ (CGFloat)getAvailableStorage {
    return [self getAvailableStorageBitSize] / (1024.0*1024.0);
}

+ (CGFloat)totalStorageForDevice {
    CGFloat totalSize = 0.0f;
    if (@available(iOS 11.0, *)) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:@"/"];
        NSError *error = nil;
        NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeTotalCapacityKey] error:&error];
        if (results) {
            NSNumber *totalCapacity = [results objectForKey:NSURLVolumeTotalCapacityKey];
            totalSize = [totalCapacity unsignedLongLongValue];
        }
    } else {
        NSError *error = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                             , YES);
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
        if(dictionary) {
            NSNumber *totalCapacity = [dictionary objectForKey:NSFileSystemSize];
            totalSize = [totalCapacity unsignedLongLongValue];
        }
    }
    return totalSize / (1024.0 * 1024.0);
}


+ (UInt64)getAvailableStorageBitSize {
    CGFloat freeSize = 0.0f;
    if (@available(iOS 11.0, *)) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:@"/"];
        NSError *error = nil;
        NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityKey] error:&error];
        if (results) {
            NSNumber *availableCapacity = [results objectForKey:NSURLVolumeAvailableCapacityKey];
            freeSize = [availableCapacity unsignedLongLongValue];
        }
    } else {
        NSError *error = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                             , YES);
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
        if(dictionary) {
            NSNumber *availableCapacity = [dictionary objectForKey:NSFileSystemFreeSize];
            freeSize = [availableCapacity unsignedLongLongValue];
        }
    }
    return freeSize;
}

@end
