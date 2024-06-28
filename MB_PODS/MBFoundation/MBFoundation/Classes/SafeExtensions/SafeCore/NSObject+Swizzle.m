//
//  NSObject+swizzle.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "SafeKitMacro.h"

@implementation NSObject(Swizzle)

+ (Class)getMeatclass:(Class)srcClass {
    Class objectMeatClass = object_getClass(srcClass); ///> 元类对象
    return objectMeatClass;
}

+ (void)safe_mb_swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel{
    Class clazz = [self class];
    [self safe_mb_swizzleMethodSrcClass:clazz srcSel:srcSel tarClass:clazz tarSel:tarSel];
}

+ (void)safe_mb_swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel{
    if (!tarClassName) {
        return;
    }
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    [self safe_mb_swizzleMethodSrcClass:srcClass srcSel:srcSel tarClass:tarClass tarSel:tarSel];
}

+ (void)safe_mb_swizzleMethodSrcClass:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel{
    if (!srcClass) {
        return;
    }
    if (!srcSel) {
        return;
    }
    if (!tarClass) {
        return;
    }
    if (!tarSel) {
        return;
    }
    Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
    Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
    method_exchangeImplementations(srcMethod, tarMethod);
}

@end
