//
//  MBNativeBridge.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "MBBridgeReuest.h"
#import "MBBridgeResponse.h"

NS_ASSUME_NONNULL_BEGIN

// 一些反向通用操作: 如获取vc
@protocol MBBridgeNativeContainerHandle <NSObject>

@end

/**
 ！建议调用者持有bridge实例, 便于后续扩展
 */
@interface MBNativeBridge : NSObject

- (instancetype)initWithHandle:(nullable id<MBBridgeNativeContainerHandle>)handle;
- (instancetype)init;

/**
 @param bridgeName bridge名字 module.biz.method, 不可为空
 @param params 参数, 可以为空
 @param visitor 调用者模块名, 可以为空. 用来做调用权限管控, 如货源模块自己的bridge可能不让其它业务模块调用
 @param callBack 回调, 大部分是异步的, 且不能保证在主线程回调，可以为空
        返回结构MBBridgeResponse 已经过去壳, 为业务定义数据(yapi文档)
 */
- (void)performBridge:(NSString *)bridgeName
               params:(nullable NSDictionary *)params
              visitor:(nullable NSString *)visitor
             callBack:(nullable MBBridgeNativeBlock)callBack;

/**
 @param request 调用bridge的请求参数, 不可为空
 @param callBack 回调, 大部分是异步的, 且不能保证在主线程回调，可以为空
        返回结构MBBridgeResponse 已经过去壳, 为业务定义数据(yapi文档)
 */
- (void)performBridge:(MBBridgeReuest *)request
             callBack:(MBBridgeNativeBlock)callBack;

@end

NS_ASSUME_NONNULL_END
