//
//  NSDictionary+SafeKit.m
//  SafeKitExample
//
//  Created by 张宇 on 16/2/19.
//  Copyright © 2016年 zhangyu. All rights reserved.
//

#import "NSDictionary+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSDictionary (SafeKit)

- (instancetype)safe_mb_initWithObjects:(id _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    id validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] != NULL && keys[i]) {
            validObjects[count] = objects[i];
            validKeys[count] = keys[i];
            count++;
        } else {
            SKLog(@"[%@ %@] NULL object or key at index{%lu}.",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  (unsigned long)i);
            
            SK_CATCHSTACK_TRY
#pragma clang diagnostic ignored "-Wunused-value"
            [[NSDictionary alloc] safe_mb_initWithObjects:objects forKeys:keys count:cnt];
#pragma clang diagnostic pop
            SK_CATCHSTACK_CATCH
        }
    }
    return [self safe_mb_initWithObjects:validObjects forKeys:validKeys count:count];
}

+ (instancetype)safe_mb_dictionaryWithObjects:(const id[])objects forKeys:(const id<NSCopying>[])keys count:(NSUInteger)cnt {
    id validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] != NULL && keys[i]) {
            validObjects[count] = objects[i];
            validKeys[count] = keys[i];
            count++;
        } else {
            SKLog(@"[%@ %@] NULL object or key at index{%lu}.",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  (unsigned long)i);
            SK_CATCHSTACK_TRY
            [self safe_mb_dictionaryWithObjects:objects forKeys:keys count:cnt];
            SK_CATCHSTACK_CATCH
        }
    }
    
    return [self safe_mb_dictionaryWithObjects:validObjects forKeys:validKeys count:count];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_mb_swizzleMethod:@selector(safe_mb_initWithObjects:forKeys:count:) tarClass:@"__NSPlaceholderDictionary" tarSel:@selector(initWithObjects:forKeys:count:)];
        [self safe_mb_swizzleMethodSrcClass:[self getMeatclass:[NSDictionary class]] srcSel:@selector(safe_mb_dictionaryWithObjects:forKeys:count:) tarClass:[self getMeatclass:[NSDictionary class]] tarSel:@selector(dictionaryWithObjects:forKeys:count:)];
    });
}

@end
