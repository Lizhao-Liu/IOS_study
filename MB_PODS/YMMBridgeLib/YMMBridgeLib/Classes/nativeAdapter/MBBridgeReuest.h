//
//  MBBridgeReuest.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBBridgeReuest : NSObject
/// module.biz.method
@property (nonatomic, copy) NSString *bridgeName;
/// 请求者, 用于权限控制
@property (nullable, nonatomic, copy) NSString *visitor;
@property (nullable, nonatomic, strong) NSDictionary *params;

/**
 * @param name bridge名,module.biz.method
 * @param visitor 调用者，用于权限控制
 * @param params 参数字典
 */
+ (instancetype)requestWithName:(NSString *)name
                        visitor:(nullable NSString *)visitor
                         params:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
