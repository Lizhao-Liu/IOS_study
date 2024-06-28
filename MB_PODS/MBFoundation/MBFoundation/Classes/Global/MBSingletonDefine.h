//
//  MBSingletonDefine.h
//  YMMTestProj
//
//  Created by heng wu on 2020/4/7.
//  Copyright © 2020 heng wu. All rights reserved.
//

#ifndef MBSingletonDefine_h
#define MBSingletonDefine_h

/**
 *  定义单例（Header）
 *
 *  @param className 类名
 *
 *  @return 单例对象
 */
#ifndef DEFINE_SINGLETON_FOR_HEADER

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#endif

/**
 *  定义单例（Implementation）
 *
 *  @param className 类名
 *
 *  @return 单例对象
 */
#ifndef DEFINE_SINGLETON_FOR_CLASS

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

#endif


#endif /* MBSingletonDefine_h */
