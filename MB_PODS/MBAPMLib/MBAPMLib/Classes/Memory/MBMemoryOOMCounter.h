//
//  MBMemoryOOMDetector.h
//  
//
//  Created by 别施轩 on 2022/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^MemoryOOMCounterCallback)(BOOL isOOM, BOOL isBackground);

@interface MBMemoryOOMCounter : NSObject

@property (nonatomic, copy) MemoryOOMCounterCallback callBack;

@property (nonatomic, assign, readonly) BOOL lastExitWithMemoryWarning;

// 最多记录32次启动，记录是否因为oom退出（memory warning）
- (NSUInteger)storageWarningExitInfo;
- (void)cleanStorageWarningExitInfo;

@end

NS_ASSUME_NONNULL_END
