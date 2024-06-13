//
//  MBAdapterTargetProxy.h
//  YMMModuleLib
//
//  Created by Lizhao on 2023/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBAdapterTargetProxy : NSProxy

@property (nonatomic, weak, readonly, nullable) id target;

+ (nonnull instancetype)proxyWithTarget:(nonnull id)target;

@end

NS_ASSUME_NONNULL_END
