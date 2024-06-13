//
//  MBModuleInfo.h
//  YMMModuleLib
//
//  Created by xp on 2021/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBModuleInfo : NSObject

/// 模块类名
@property(nonatomic, copy, nonnull) NSString *moduleClassName;


@property(nonatomic, copy, nonnull) Class moduleClass;

///模块名称
@property (nonatomic, copy, nonnull) NSString *moduleName;


/// 模块优先级
@property (nonatomic, assign)NSUInteger priority;

/// 子模块名称,非必传字段，在需要区分模块中子模块上下文时使用
@property (nonatomic, copy, nullable) NSString *subModuleName;

/// 包名称，非必传字段，在需要区分bundle包上下文时使用
/// bundle与module的区别,module是业务逻辑划分，bundle是代码物理构成划分
/// 取值根据bundleType确定：native类型取app的bundleId，动态库类型取bundleId,其他各种类型jsbundle取info.json中name字段
@property (nonatomic, copy, nullable) NSString *bundleName;

/// 包版本，非必传字段，在需要区分bundle包上下文时使用，与bundleName配合使用
/// 取值根据bundleType确定：native类型取app的CFBundleShortVersionString，动态库类型取CFBundleShortVersionString,其他各种类型jsbundle取info.json中version字段
@property (nonatomic, copy, nullable) NSString *bundleVersion;

/// 包类型，在需要区分bundle包上下文时使用
/// 取值范围：native，h5，rn，flutter，thresh, davinci
@property (nonatomic, copy, nullable) NSString *bundleType;

@end

NS_ASSUME_NONNULL_END
