//
//  NSObject+MBExtends.h
//  YMMTestProj
//
//  Created by heng wu on 2020/3/31.
//  Copyright © 2020 heng wu. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef nilForSelector
#define nilForSelector @{@"YMMSWNull":@(0)}
#endif
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MBExtends)

#pragma mark - 
/*
 * swizzle实例方法
 * origSel_: 原方法
 * altSel_:新方法
 */
+ (BOOL)ymm_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_;

/*
 * swizzle类方法
 * origSel_: 原方法
 * altSel_:新方法
 */
+ (BOOL)ymm_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_;

- (BOOL)isKindOfClazz:(Class)aClass;

+ (Class) clazz;

// 传递多个参数的方法，如需要传递 nil 需要使用 nilForSelector 参数
- (id)glt_performSelector:(SEL)selector
               withObject:(id)object,...NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Property

/**
 *  获取所有属性Key
 *
 *  @param includeSuper 是否需要包含父类属性
 *
 *  @return 所有属性Key
 */
+ (NSArray *)ymm_allPropertyKeys:(BOOL)includeSuper;

/**
 *  获取所有属性Key
 *
 *  @param includeSuper   是否需要包含父类属性
 *  @param rootSuperClass 需要包含父类属性根类（此类及往上超类属性将被忽略，默认NSObject）
 *
 *  @return 所有属性Key
 */
+ (NSArray *)ymm_allPropertyKeys:(BOOL)includeSuper rootSuperClass:(Class)rootSuperClass;

/**
 *  获取指定属性类型
 *
 *  @param propertyName 属性名
 *
 *  @return 类型
 */
+ (Class)ymm_classForPropertyName:(NSString *)propertyName;


/**
 获取所有属性key+value，不包含父类属性

 @return 所有属性key+value
 */
- (NSDictionary *)ymm_allProperty;


@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

// 页面埋点协议
@protocol YMMAutoLogPageProtocol <NSObject>
@property (nonatomic, copy) NSString *pageName;  // 页面名称

@optional
@property (nonatomic, copy) NSString *moduleName;   // 模块名称
@property (nonatomic, copy) NSString *referPageName; // 页面来源名称

/**
 额外需要添加的业务字段
 
 @return return value description
 */
- (NSDictionary *)extension;

@end

// 控件埋点协议
@protocol YMMAutoLogViewProtocol <NSObject>
@property (nonatomic, copy) NSString *elementId; // 埋点ID

@optional
@property (nonatomic, copy) NSString *eventType; // 埋点类型
/**
 额外需要添加的业务字段
 
 @return return value description
 */
- (NSDictionary *)extension;
@end

// 埋点分类
@interface NSObject (MBJournal) <YMMAutoLogViewProtocol>
@property (nonatomic, copy) NSString *logElementId;
@property (nonatomic, strong) NSDictionary *eventExtraDic;
@end

NS_ASSUME_NONNULL_END
