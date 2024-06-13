//
//  MBAPMStorageUtil.h
//  MBAPMLib
//
//  Created by xp on 2020/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMStorageUtil : NSObject

+ (CGFloat)getAvailableStorage;

+ (UInt64)getAvailableStorageBitSize;

+ (CGFloat)totalStorageForDevice;

@end

NS_ASSUME_NONNULL_END
