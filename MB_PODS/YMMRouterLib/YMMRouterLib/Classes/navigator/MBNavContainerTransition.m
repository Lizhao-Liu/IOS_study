//
//  MBNavContainerTransition.m
//  YMMRouterLib
//
//  Created by xp on 2023/9/12.
//

#import "MBNavContainerTransition.h"
#import "MBNavManager_Private.h"

@implementation MBNavContainerTransition

- (void)executeAction:(MBNavBaseAction *)action complete:(nonnull void (^)(BOOL result, BOOL updateCurrentVC))completion{
    id<MBNavPageContainerStackManagerDelegate> delegate = [MBNavManager shared].navConfig.containerStackManagerDelegate;
    if (delegate) {
        [delegate mbnav_executeAction:action inPageContainer:self.currentVC complete:^(BOOL result) {
            if (completion) {
                completion(result, NO);
            }
        }];
    } else {
        if (completion) {
            completion(NO, NO);
        }
    }
}

@end
