//
//  MBBridgeAccessModel.h
//  YMMBridgeLib
//
//  Created by 常贤明 on 2021/12/29.
//

/**
 权限控制model
 */
#import <Foundation/Foundation.h>
#import "YMMPluginDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBBridgeAccessModel : NSObject

/**
 格式限定为 a(模块名) 或 a.x(模块名.子模块名)
 如果定义是：a(模块名) 则表示模块级别权控
 如果定义是：a.x(模块名.子模块名) 则表示子模块级权控
 
 // 对于设置侧，a, a.x, a.y 那么x,y都算作a的submodule，如果存在a,则a.x,a.y没有存在意义。
 // 假设业务侧传过来caller是 a.x; 实现侧设置的a，可以调通
 // 假设业务侧传过来caller是 a.x; 实现侧设置的a.x，可以调通
 // 假设业务侧传过来caller是 a.x; 实现侧设置的a.y，调不通
 // 假设业务侧传过来caller是 a; 实现侧设置的a.y，调不通
 */
@property (nonatomic, strong) NSArray<NSString *> *list;

/**
 MBMBBridgeAccessLevelWarning: 以 Toast 形式提示警告
 MBMBBridgeAccessLevelError: 直接返回“无权限”错误码。
 默认：MBMBBridgeAccessLevelWarning
 */
@property (nonatomic, assign) MBBridgeAccessLevel level;

/**
 不限制访问，默认NO，YES：不限制
 */
@property (nonatomic, assign) BOOL nolimit;

- (instancetype)initWithAccess:(NSArray *)list level:(MBBridgeAccessLevel)level;


- (BOOL)matchAccess:(NSString *)visitor;

@end

NS_ASSUME_NONNULL_END
