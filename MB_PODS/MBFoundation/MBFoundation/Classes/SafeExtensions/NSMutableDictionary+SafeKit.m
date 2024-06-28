//
//  NSMutableDictionary+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSMutableDictionary+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSMutableDictionary (SafeKit)

- (void)safe_mb_removeObjectForKey:(id)aKey {
    if (!aKey) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_removeObjectForKey:aKey];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_removeObjectForKey:aKey];
}

- (void)safe_mb_setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (aKey == NULL || !aKey) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_setObject:anObject forKey:aKey];
        SK_CATCHSTACK_CATCH
        return;
    }
    if (anObject == NULL || !anObject) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_setObject:anObject forKey:aKey];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_setObject:anObject forKey:aKey];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_mb_swizzleMethod:@selector(safe_mb_setObject:forKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(setObject:forKey:)];
        
        // 在210923版本添加此检查
        [self safe_mb_swizzleMethod:@selector(safe_mb_removeObjectForKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(removeObjectForKey:)];
    });
}

@end
