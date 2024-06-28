//
//  YMMCommonBridge.h
//  YMMBridgeModule
//
//  Created by 尹成 on 2019/2/25.
//  Copyright © 2019 尹成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBBridgeContainer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * response bridge返回值
 * 注意v1 和 v2版本返回值嵌套层级不一致，v1双层结构，v2单层结构
 * v1版本：
 * {
 *    "code":xx,
 *    "reason":"xx",
 *    "data":{
 *       "code":xx,
 *       "reason":"xx",
 *       "data":xx
 *    }
 * }
 * v2版本：
 * {
 *    "code":xx,
 *    "reason":"xx",
 *    "data":xx
 * }
 */
typedef void(^YMMBridgeCallBack)(NSDictionary *response);

@interface YMMCommonBridge : NSObject

/**
 * 调用bridge方法
 * 注1：bridge实现侧以下bridge方法定义视为重复定义
 *   方法a）- (void)uploadImage:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion;
 *   方法b）- (void)uploadImage:(NSDictionary *)params container:(id<MBBridgeContainer>)container callBack:(YMMMethodResponseBlock)completion;
 * 注2：bridge实现侧，bridge方法不可重复定义，若重复定义则优先使用带container参数的方法。
 *    如以上 方法a、方法b，将只会触发 方法b
 *
 * @param bridgeInfo 参数
 * @param callBack 回调
 * 注意v1 和 v2版本返回值嵌套层级不一致，v1双层结构，v2单层结构
 */
- (void)performBridge:(NSDictionary *)bridgeInfo
             callBack:(YMMBridgeCallBack)callBack;

/**
 * 调用bridge方法-可传容器对象
 * 注1：bridge实现侧以下bridge方法定义视为重复定义
 *     方法a）- (void)uploadImage:(NSDictionary *)params callBack:(YMMMethodResponseBlock)completion;
 *     方法b）- (void)uploadImage:(NSDictionary *)params container:(id<MBBridgeContainer>)container callBack:(YMMMethodResponseBlock)completion;
 * 注2：bridge实现侧，bridge方法不可重复定义，若重复定义则优先使用带container参数的方法。
 *     如以上 方法a、方法b，将只会触发 方法b
 *
 * @param bridgeInfo 参数
 * @param container 容器对象
 * @param callBack 回调，注意v1 和 v2版本返回值嵌套层级不一致
 * 注意v1 和 v2版本返回值嵌套层级不一致，v1双层结构，v2单层结构
 */
- (void)performBridge:(NSDictionary *)bridgeInfo
            container:(nullable id<MBBridgeContainer>)container
             callBack:(YMMBridgeCallBack)callBack;

@end

NS_ASSUME_NONNULL_END
