//
//  MBAPMZombieProxy.h
//  MBAPMLib
//
//  Created by xp on 2022/10/19.
//

@import Foundation;
@import Matrix;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMZombieProxy : NSProxy

@property (nonatomic, assign) Class originClass;

@property (nonatomic, assign) BOOL throwExceptionWhenDetectZombie;

@property (nonatomic, assign) BOOL reportDeallocStack;


/// 获取僵尸代理对象占用内存大小
+ (size_t)zombieInstanceSize;

@end

NS_ASSUME_NONNULL_END
