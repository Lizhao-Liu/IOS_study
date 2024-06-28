//
//  NSMutableString+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSMutableString+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSMutableString (SafeKit)

- (void)safe_mb_appendString:(NSString *)aString {
    if (aString == NULL || !aString) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_appendString:aString];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_appendString:aString];
}

- (void)safe_mb_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    if (format == NULL || !format) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        va_list arguments;
        va_start(arguments, format);
        NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
        formatStr = SK_AUTORELEASE(formatStr);
        [self safe_mb_appendFormat:@"%@",formatStr];
        va_end(arguments);
        SK_CATCHSTACK_CATCH
        return;
    }
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    formatStr = SK_AUTORELEASE(formatStr);
    [self safe_mb_appendFormat:@"%@",formatStr];
    va_end(arguments);
}

- (void)safe_mb_setString:(NSString *)aString {
    if (aString == NULL || !aString) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_setString:aString];
        SK_CATCHSTACK_CATCH
        return;
    }
    [self safe_mb_setString:aString];
}

- (void)safe_mb_insertString:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > [self length]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.length - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_insertString:aString atIndex:index];
        SK_CATCHSTACK_CATCH
        return;
    }
    if (!aString) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_insertString:aString atIndex:index];
        SK_CATCHSTACK_CATCH
        return;
    }
    
    [self safe_mb_insertString:aString atIndex:index];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 在210923版本添加此检查
        [self safe_mb_swizzleMethod:@selector(safe_mb_appendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_appendFormat:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_setString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_insertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
    });
}

@end
