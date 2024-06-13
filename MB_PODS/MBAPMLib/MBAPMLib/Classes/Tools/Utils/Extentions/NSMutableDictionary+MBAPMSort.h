//
//  NSMutableDictionary+MBAPMSort.h
//  MBAPMLib
//
//  Created by xp on 2020/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary(MBAPMSort)

@property (nonatomic, strong) NSMutableArray *sortedKeyArray;

- (void)MBAPMSort_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (void)MBAPMSort_removeObjectForKey:(id)aKey;

- (void)MBAPMSort_removeAllObjects;

- (void)MBAPMSort_enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))block;

- (NSMutableArray *)MBAPMSort_getAllValue;

@end

NS_ASSUME_NONNULL_END
