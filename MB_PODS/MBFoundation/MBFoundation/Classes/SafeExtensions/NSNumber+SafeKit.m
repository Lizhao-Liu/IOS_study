//
//  NSNumber+SafeKit.m
//  JMBFramework
//
//  Created by zhangyu on 14-6-12.
//  Copyright (c) 2014年 jion-cheer. All rights reserved.
//

#import "NSNumber+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSNumber (SafeKit)

- (BOOL)safe_mb_isEqualToNumber:(NSNumber *)number {
    if (number == NULL || !number) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_isEqualToNumber:number];
        SK_CATCHSTACK_CATCH
        return NO;
    }
    return [self safe_mb_isEqualToNumber:number];
}

- (NSComparisonResult)safe_mb_compare:(NSNumber *)number {
    if (number == NULL || !number) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_compare:number];
        SK_CATCHSTACK_CATCH
        return NSOrderedAscending;
    }
    return [self safe_mb_compare:number];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 在210923版本添加此检查
        [self safe_mb_swizzleMethod:@selector(safe_mb_isEqualToNumber:) tarClass:@"__NSCFNumber" tarSel:@selector(isEqualToNumber:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_compare:) tarClass:@"__NSCFNumber" tarSel:@selector(compare:)];
    });
}

@end
