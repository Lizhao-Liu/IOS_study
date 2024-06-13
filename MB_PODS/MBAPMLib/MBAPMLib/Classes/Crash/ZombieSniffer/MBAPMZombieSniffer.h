//
//  MBAPMZombieSniffer.h
//  MBAPMLib
//
//  Created by xp on 2022/10/19.
//

@import Foundation;
@import Matrix;
#import "MBAPMZombieConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMZombieSniffer : NSObject

+ (void)startSniffer:(MBAPMZombieConfig *)zombieConfig;

+ (void)stopSniffer;

+ (BOOL)traceDeallocStackEnabled;

+ (void)enableTraceDeallocStack:(BOOL)enable;

+ (void)appendWhiteClassNameList:(NSArray<NSString *> *)classNameArray;

+ (void)appendBlackClassNameList:(NSArray<NSString *> *)classNameArray;

+ (void)deallocStack:(KSStackCursor *)cursor ForObj:(uintptr_t)objAddress;

@end

NS_ASSUME_NONNULL_END
