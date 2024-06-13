//
//  MBNavContainerTransitionBuilder.m
//  YMMRouterLib
//
//  Created by xp on 2023/9/12.
//

#import "MBNavContainerTransitionBuilder.h"
#import "MBNavContainerTransition.h"

@implementation MBNavContainerTransitionBuilder

- (MBNavBaseTransition *)build {
    if (!self.transition) {
        self.transition = [MBNavContainerTransition new];
    }
    return self.transition;
}

@end
