//
//  NSString+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSString+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSString (SafeKit)

- (unichar)safe_mb_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        SKLog(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)index,
              MAX((unsigned long)self.length - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_characterAtIndex:index];
        SK_CATCHSTACK_CATCH
        return 0;
    }
    return [self safe_mb_characterAtIndex:index];
}

- (NSString *)safe_mb_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        SKLog(@"[%@ %@] range {%lu...%lu} beyond bounds [0...%lu]",
              NSStringFromClass([self class]),
              NSStringFromSelector(_cmd),
              (unsigned long)range.location, (unsigned long)range.length,
              MAX((unsigned long)self.length - 1, 0));
        SK_CATCHSTACK_TRY
        [self safe_mb_substringWithRange:range];
        SK_CATCHSTACK_CATCH
        return nil;
    }
    return [self safe_mb_substringWithRange:range];
}

- (NSString *)safe_mb_stringByAppendingString:(NSString *)string {
    if (string == NULL || !string) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_stringByAppendingString:string];
        SK_CATCHSTACK_CATCH
        return self;
    }
    return [self safe_mb_stringByAppendingString:string];
}

- (NSString *)safe_mb_stringByAppendingStringForNSCFConstantString:(NSString *)string {
    if (string == NULL || !string) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_stringByAppendingStringForNSCFConstantString:string];
        SK_CATCHSTACK_CATCH
        return self;
    }
    return [self safe_mb_stringByAppendingStringForNSCFConstantString:string];
}

+ (instancetype)safe_mb_stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc {
    if (cString == NULL || !cString) {
        SKLog(@"[%@ %@], NULL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        SK_CATCHSTACK_TRY
        [self safe_mb_stringWithCString:cString encoding:enc];
        SK_CATCHSTACK_CATCH
        return nil;
    }
    return [self safe_mb_stringWithCString:cString encoding:enc];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 在210923版本添加此检查
        [self safe_mb_swizzleMethod:@selector(safe_mb_characterAtIndex:) tarClass:@"__NSCFString" tarSel:@selector(characterAtIndex:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_substringWithRange:) tarClass:@"__NSCFString" tarSel:@selector(substringWithRange:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_stringByAppendingString:) tarClass:@"__NSCFString" tarSel:@selector(stringByAppendingString:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_stringByAppendingStringForNSCFConstantString:) tarClass:@"__NSCFConstantString" tarSel:@selector(stringByAppendingString:)];
        [self safe_mb_swizzleMethodSrcClass:[self getMeatclass:[NSString class]] srcSel:@selector(safe_mb_stringWithCString:encoding:) tarClass:[self getMeatclass:[NSString class]] tarSel:@selector(stringWithCString:encoding:)];
    });
}

@end
