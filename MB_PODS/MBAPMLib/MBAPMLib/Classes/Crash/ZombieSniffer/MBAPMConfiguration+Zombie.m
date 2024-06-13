//
//  MBAPMConfiguration+Zombie.m
//  MBAPMLib
//
//  Created by xp on 2022/12/9.
//

#import "MBAPMConfiguration+Zombie.h"
#import <objc/runtime.h>

@implementation MBAPMConfiguration(Zombie)

- (MBAPMZombieConfig *)zombieConfig {
    return objc_getAssociatedObject(self, @selector(zombieConfig));
}

- (void)setZombieConfig:(MBAPMZombieConfig *)zombieConfig {
    objc_setAssociatedObject(self, @selector(zombieConfig), zombieConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enableZombieMonitor {
    return ((NSNumber *)objc_getAssociatedObject(self, @selector(enableZombieMonitor))).boolValue;
}

- (void)setEnableZombieMonitor:(BOOL)enableZombieMonitor {
    objc_setAssociatedObject(self, @selector(enableZombieMonitor), @(enableZombieMonitor), OBJC_ASSOCIATION_ASSIGN);
}

@end
