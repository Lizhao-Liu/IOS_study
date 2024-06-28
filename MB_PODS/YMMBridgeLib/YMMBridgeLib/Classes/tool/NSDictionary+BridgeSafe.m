//
//  NSDictionary+BridgeSafe.m
//  Expecta
//
//  Created by yc on 2019/10/31.
//

#import "NSDictionary+BridgeSafe.h"

@implementation NSDictionary (BridgeSafe)

- (NSString *)bridge_stringForKey:(id)aKey {
    id value = [self bridge_objectForKey:aKey];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    }
    return nil;
}

- (id)bridge_objectForKey:(id)aKey {
    if(aKey == nil)
    return nil;
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
