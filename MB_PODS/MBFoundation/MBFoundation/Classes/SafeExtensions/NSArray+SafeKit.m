//
//  NSArray+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-2-28.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSArray+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSArray (SafeKit)

- (instancetype)safe_mb_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] != NULL) {
            validObjects[count] = objects[i];
            count++;
        } else {
            SKLog(@"[%@ %@] NULL object or key at index{%lu}.",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  (unsigned long)i);
            SK_CATCHSTACK_TRY
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
            [[NSArray alloc] safe_mb_initWithObjects:objects count:cnt];
#pragma clang diagnostic pop
            SK_CATCHSTACK_CATCH
        }
    }
    return [self safe_mb_initWithObjects:validObjects count:count];
}

- (id)safe_mb_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_objectAtIndex:index];
        SK_CATCHSTACK_CATCH
        return nil;
    }
    return [self safe_mb_objectAtIndex:index];
}

- (id)safe_mb_objectAtIndexForNSArray0:(NSUInteger)index {
    if (index >= [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_objectAtIndexForNSArray0:index];
        SK_CATCHSTACK_CATCH
        return nil;
    }
    return [self safe_mb_objectAtIndexForNSArray0:index];
}

- (id)safe_mb_objectAtIndexedSubscriptForNSSingleObjectArrayI:(NSUInteger)index {
    if (index >= [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_objectAtIndexedSubscriptForNSSingleObjectArrayI:index];
        SK_CATCHSTACK_CATCH
        return nil;
    }
    return [self safe_mb_objectAtIndexedSubscriptForNSSingleObjectArrayI:index];
}

- (id)safe_mb_objectAtIndexedSubscriptForNSArrayI:(NSUInteger)index {
    if (index >= [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_objectAtIndexedSubscriptForNSArrayI:index];
        SK_CATCHSTACK_CATCH
        return nil;
    }
    return [self safe_mb_objectAtIndexedSubscriptForNSArrayI:index];
}

- (NSArray *)safe_mb_arrayByAddingObject:(id)anObject {
    if (!anObject) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_arrayByAddingObject:anObject];
        SK_CATCHSTACK_CATCH
        return self;
    }
    return [self safe_mb_arrayByAddingObject:anObject];
}

+ (id)safe_mb_arrayWithObjects:(const id[])objects count:(NSUInteger)cnt {
    id validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (objects[i] != NULL) {
            validObjects[count] = objects[i];
            count++;
        } else {
            SKLog(@"[%@ %@] NULL object at index {%lu}",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(_cmd),
                  (unsigned long)i);
            SK_CATCHSTACK_TRY
            [self safe_mb_arrayWithObjects:objects count:cnt];
            SK_CATCHSTACK_CATCH
        }
    }
    
    return [self safe_mb_arrayWithObjects:validObjects count:count];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_mb_swizzleMethodSrcClass:[self getMeatclass:[NSArray class]] srcSel:@selector(safe_mb_arrayWithObjects:count:) tarClass:[self getMeatclass:[NSArray class]] tarSel:@selector(arrayWithObjects:count:)];
//        
// #ifdef DEBUG
// #else
//        [self safe_mb_swizzleMethod:@selector(safe_initWithObjects:count:) tarClass:@"__NSPlaceholderArray" tarSel:@selector(initWithObjects:count:)];
//        [self safe_mb_swizzleMethod:@selector(safe_mb_arrayByAddingObject:) tarClass:@"__NSArrayI" tarSel:@selector(arrayByAddingObject:)];
//        [self safe_mb_swizzleMethod:@selector(safe_mb_objectAtIndex:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndex:)];
//        [self safe_mb_swizzleMethod:@selector(safe_mb_objectAtIndexedSubscriptForNSArrayI:) tarClass:@"__NSArrayI" tarSel:@selector(objectAtIndexedSubscript:)];
//        [self safe_mb_swizzleMethod:@selector(safe_mb_objectAtIndexedSubscriptForNSSingleObjectArrayI:) tarClass:@"__NSSingleObjectArrayI" tarSel:@selector(objectAtIndex:)];
//        [self safe_mb_swizzleMethod:@selector(safe_mb_objectAtIndexForNSArray0:) tarClass:@"__NSArray0" tarSel:@selector(objectAtIndex:)];
//#endif
    });
}

@end

