//
//  MBAPMMemoryLeakProtocol.h
//  Pods
//
//  Created by xp on 2020/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 内存泄漏模型
@protocol MBAPMMemoryLeakProtocol <NSObject>

@required
/// 标题
- (NSString *)title;

/// 消息
- (NSString *)message;

@optional

@end

NS_ASSUME_NONNULL_END
