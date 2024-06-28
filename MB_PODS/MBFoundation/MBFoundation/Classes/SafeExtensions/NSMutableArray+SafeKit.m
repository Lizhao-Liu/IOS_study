//
//  NSMutableArray+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSMutableArray+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSMutableArray (SafeKit)
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

- (void)safe_mb_addObject:(id)anObject {
    if (anObject == NULL || !anObject) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_addObject:anObject];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_addObject:anObject];
}

- (void)safe_mb_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_insertObject:anObject atIndex:index];
        SK_CATCHSTACK_CATCH
        return;
    }
    if (anObject == NULL || !anObject) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_insertObject:anObject atIndex:index];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_insertObject:anObject atIndex:index];
}

- (void)safe_mb_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_removeObjectAtIndex:index];
        SK_CATCHSTACK_CATCH
        return;
    }
    return [self safe_mb_removeObjectAtIndex:index];
}

- (void)safe_mb_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.count - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_replaceObjectAtIndex:index withObject:anObject];
        SK_CATCHSTACK_CATCH
        return;
    }
    if (anObject == NULL || !anObject) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_replaceObjectAtIndex:index withObject:anObject];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_replaceObjectAtIndex:index withObject:anObject];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 从RPL迁移过来的保持dev和release都在
        [self safe_mb_swizzleMethod:@selector(safe_mb_addObject:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_replaceObjectAtIndex:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_insertObject:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
       
//#ifdef DEBUG
//#else
//        [self safe_mb_swizzleMethod:@selector(safe_mb_removeObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
//        [self safe_mb_swizzleMethod:@selector(safe_mb_objectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
//#endif

    });
}

@end
