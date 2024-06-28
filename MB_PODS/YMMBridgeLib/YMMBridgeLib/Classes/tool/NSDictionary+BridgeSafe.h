//
//  NSDictionary+BridgeSafe.h
//  Expecta
//
//  Created by yc on 2019/10/31.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (BridgeSafe)

/**
 从字典中获取string类型值

 @param aKey key
 @return key对应value，失败则返回nil
 */
- (NSString *)bridge_stringForKey:(id)aKey;

/**
从字典中获取对象类型值

@param aKey key
@return key对应value，失败则返回nil
*/
- (id)bridge_objectForKey:(id)aKey;

@end

NS_ASSUME_NONNULL_END
