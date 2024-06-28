//
//  MBPluginResponse.h
//  YMMBridgeLib
//
//  Created by admin on 2023/4/5.
//

#import <Foundation/Foundation.h>
#import "YMMPluginDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface MBPluginResponse : NSObject

/**
 * bridge执行结果code
 * 0:成功
 */
@property (nonatomic, assign) NSInteger code;

/**
 * bridge执行结果
 */
@property (nonatomic, copy) NSString *reason;

/**
 * bridge执行返回数据
 * v1，data为有嵌套结构字典, {"code":xx, "reason":"xx", "data":xxx}
 * v2，data为真实业务结果数据
 */
@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
