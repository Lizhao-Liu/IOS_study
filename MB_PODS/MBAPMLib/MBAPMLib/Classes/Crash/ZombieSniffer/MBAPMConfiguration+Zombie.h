//
//  MBAPMConfiguration+Zombie.h
//  MBAPMLib
//
//  Created by xp on 2022/12/9.
//

#import <Foundation/Foundation.h>
#import "MBAPMZombieConfig.h"
@import MBAPMServiceLib;

NS_ASSUME_NONNULL_BEGIN

@interface MBAPMConfiguration(Zombie)

@property (nonatomic, assign) BOOL enableZombieMonitor;
@property (nonatomic, strong) MBAPMZombieConfig *zombieConfig;

@end

NS_ASSUME_NONNULL_END
