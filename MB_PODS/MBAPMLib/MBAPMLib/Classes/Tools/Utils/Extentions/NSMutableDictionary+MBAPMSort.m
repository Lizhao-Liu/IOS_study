//
//  NSMutableDictionary+MBAPMSort.m
//  MBAPMLib
//
//  Created by xp on 2020/7/13.
//
#import <objc/runtime.h>
#import "NSMutableDictionary+MBAPMSort.h"

static NSString * const kPropertyName_MBAPM_SortedKeyArray = @"sortedKeyArray"; //有序key数组属性名

@implementation NSMutableDictionary(MBAPMSort)

- (void)setSortedKeyArray:(NSMutableArray *)sortedKeyArray {
    objc_setAssociatedObject(self, &kPropertyName_MBAPM_SortedKeyArray, sortedKeyArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)sortedKeyArray {
    NSMutableArray *array = objc_getAssociatedObject(self, &kPropertyName_MBAPM_SortedKeyArray);
    if(!array) {
        array = [[NSMutableArray alloc]init];
        objc_setAssociatedObject(self, &kPropertyName_MBAPM_SortedKeyArray, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}


- (void)MBAPMSort_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    [self setObject:anObject forKey:aKey];
    [self.sortedKeyArray removeObject:aKey];
    [self.sortedKeyArray addObject:aKey];
}

- (void)MBAPMSort_removeObjectForKey:(id)aKey {
    [self removeObjectForKey:aKey];
    [self.sortedKeyArray removeObject:aKey];
}

- (void)MBAPMSort_removeAllObjects {
    [self removeAllObjects];
    [self.sortedKeyArray removeAllObjects];
}

- (void)MBAPMSort_enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key,
                                                                          id obj,
                                                                          BOOL *stop))block {
    BOOL stop = NO;
    if(self.sortedKeyArray) {
        for(int i = 0; i < self.sortedKeyArray.count; i++) {
            if(stop) {
                break;
            }
            id key = self.sortedKeyArray[i];
            if(key) {
                id obj = [self objectForKey:key];
                if(block) {
                    block(key, obj, &stop);
                }
            }
        }
    }
}

- (NSMutableArray *)MBAPMSort_getAllValue {
    if(self.sortedKeyArray) {
        NSMutableArray *allValueArray = [[NSMutableArray alloc]init];
        for(int i = 0; i < self.sortedKeyArray.count; i++) {
            id key = self.sortedKeyArray[i];
            if(key) {
                id obj = [self objectForKey:key];
                [allValueArray addObject:obj];
            }
        }
        return allValueArray;
    }
    return nil;
}

@end
