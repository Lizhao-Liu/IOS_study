//
//  NSDictionary+YYAdd.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSDictionary`.
 */
@interface NSDictionary (YYAdd)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the binary plist data, or nil if an error occurs.
 */
+ (nullable NSDictionary *)dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSDictionary *)dictionaryWithPlistString:(NSString *)plist;

/**
 Serialize the dictionary to a binary property list data.
 
 @return A binary plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (nullable NSData *)plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)plistString;

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)jsonPrettyStringEncoded;

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)dictionaryWithXML:(id)xmlDataOrString;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (char)charValueForKey:(NSString *)key default:(char)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (unsigned char)unsignedCharValueForKey:(NSString *)key default:(unsigned char)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (short)shortValueForKey:(NSString *)key default:(short)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (unsigned short)unsignedShortValueForKey:(NSString *)key default:(unsigned short)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (int)intValueForKey:(NSString *)key default:(int)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (unsigned int)unsignedIntValueForKey:(NSString *)key default:(unsigned int)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (long)longValueForKey:(NSString *)key default:(long)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (unsigned long)unsignedLongValueForKey:(NSString *)key default:(unsigned long)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (long long)longLongValueForKey:(NSString *)key default:(long long)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (unsigned long long)unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (float)floatValueForKey:(NSString *)key default:(float)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (double)doubleValueForKey:(NSString *)key default:(double)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (NSInteger)integerValueForKey:(NSString *)key default:(NSInteger)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

- (nullable NSNumber *)numberValueForKey:(NSString *)key default:(nullable NSNumber *)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");
- (nullable NSString *)stringValueForKey:(NSString *)key default:(nullable NSString *)def DEPRECATED_MSG_ATTRIBUTE("Please use + method, it may get nil when self is nil.");

+ (BOOL)boolValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(BOOL)def;

+ (char)charValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(char)def;
+ (unsigned char)unsignedCharValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(unsigned char)def;

+ (short)shortValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(short)def;
+ (unsigned short)unsignedShortValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(unsigned short)def;

+ (int)intValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(int)def;
+ (unsigned int)unsignedIntValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(unsigned int)def;

+ (long)longValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(long)def;
+ (unsigned long)unsignedLongValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(unsigned long)def;

+ (long long)longLongValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(long long)def;
+ (unsigned long long)unsignedLongLongValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(unsigned long long)def;

+ (float)floatValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(float)def;
+ (double)doubleValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(double)def;

+ (NSInteger)integerValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(NSInteger)def;
+ (NSUInteger)unsignedIntegerValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(NSUInteger)def;

+ (nullable NSNumber *)numberValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(nullable NSNumber *)def;
+ (nullable NSString *)stringValueWithDictionary:(NSDictionary *)dic forKey:(NSString *)key default:(nullable NSString *)def;
@end



/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (YYAdd)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the binary plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSMutableDictionary *)dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableDictionary *)dictionaryWithPlistString:(NSString *)plist;


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (nullable id)popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from receiver. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)popEntriesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
