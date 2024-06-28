//
//  NSUserDefaults+SafeKit.m
//  SafeKitExample
//
//  Created by 周俊杰 on 2021/11/29.
//

#import "NSUserDefaults+SafeKit.h"
#import "SafeKitCore.h"

@implementation NSUserDefaults (SafeKit)

- (void)safe_mb_setObject:(nullable id)anObject forKey:(NSString *)aKey {
    if (aKey == NULL || !aKey) {
        SKLog(@"[%@ %@], NULL aKey.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    if ([anObject isKindOfClass:[NSArray class]] ||
        [anObject isKindOfClass:[NSDictionary class]]) {
        if (![NSJSONSerialization isValidJSONObject:anObject]) {
            SKLog(@"[%@ %@], anObject cannot serialization.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            SK_CATCHSTACK_TRY
            [self safe_mb_setObject:anObject forKey:aKey];
            SK_CATCHSTACK_CATCH
            return;
        }
    }
    [self safe_mb_setObject:anObject forKey:aKey];
}

- (nullable id)safe_mb_objectForKey:(NSString *)aKey {
    if (aKey == NULL || !aKey) {
        SKLog(@"[%@ %@], NULL aKey.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return nil;
    }
    return [self safe_mb_objectForKey:aKey];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_mb_swizzleMethod:@selector(safe_mb_setObject:forKey:) tarSel:@selector(setObject:forKey:)];
        [self safe_mb_swizzleMethod:@selector(safe_mb_objectForKey:) tarSel:@selector(objectForKey:)];
    });
}

@end
