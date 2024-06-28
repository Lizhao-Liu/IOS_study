//
//  MBMutistackCommunicate.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/6.
//

/**
 事件和容器绑定
 */
#import <Foundation/Foundation.h>
#import "MBBridgeContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBMutistackCommunicate : NSObject

+ (instancetype)shared;

- (void)subscribe:(NSString *)eventName forContainer:(id<MBBridgeContainer>)container;
- (void)unsubscribe:(NSString *)eventName forContainer:(id<MBBridgeContainer>)container;

- (void)publishEvent:(NSString *)eventName data:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
