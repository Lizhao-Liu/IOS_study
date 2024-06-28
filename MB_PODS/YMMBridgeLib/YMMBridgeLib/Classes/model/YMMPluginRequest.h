//
//  YMMPluginRequest.h
//  GoodTransport
//
//  Created by 尹成 on 2019/2/24.
//  Copyright © 2019 Yunmanman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBBridgeContainer.h"
#import "YMMPluginDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMMPluginRequest : NSObject

/**
 * 版本，可为nil
 * 1表示v1版本bridge
 * 2表示调用原子bridge
 */
@property (nonatomic, assign) MBPluginRequestProtocol protocol;

/**
 * 标记来源，用于打点
 * 如：fluter、rn、h5
 * 不可为nil
 */
@property (nonatomic, copy) NSString *source;

/**
 * 模块名，不可为nil
 */
@property (nonatomic, copy) NSString *module;

/**
 * 业务bundle名
 */
@property (nonatomic, copy, nullable) NSString *bundleName;

/**
 * 业务bundle版本号
 */
@property (nonatomic, copy, nullable) NSString *bundleVersion;

/**
 * 业务名，可为nil
 */
@property (nullable, nonatomic, copy) NSString *business;
/**
 * 方法名，不可为nil
 */
@property (nonatomic, copy) NSString *method;
/**
 * 参数，可为nil
 */
@property (nullable, nonatomic, strong) NSDictionary *params;
/**
 * 调用者，用来做权限控制，可为nil
 * 格式： a(模块名) 或 a.x(模块名.子模块名)
 */
@property (nullable, nonatomic, strong) NSString *visitor;
/**
 * 容器对象，可为nil
 */
@property (nullable, nonatomic, weak) id<MBBridgeContainer> container;


- (BOOL)avaliableRequest;

//- (MBBridgeVisitor *)visitorInfo;

@end

NS_ASSUME_NONNULL_END
