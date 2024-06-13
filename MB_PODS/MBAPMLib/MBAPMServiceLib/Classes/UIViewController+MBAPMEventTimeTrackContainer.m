//
//  UIViewController+MBAPMEventTimeTrackContainer.m
//  MBAPMServiceLib
//
//  Created by xp on 2023/6/8.
//

#import "UIViewController+MBAPMEventTimeTrackContainer.h"
#import <Objc/runtime.h>

@implementation UIViewController(MBAPMEventTimeTrackContainer)

- (BOOL)mbapm_isFirstHomePage {
    return [objc_getAssociatedObject(self, @selector(mbapm_isFirstHomePage)) boolValue];
}

- (void)setMbapm_isFirstHomePage:(BOOL)mbapm_isFirstHomePage {
    objc_setAssociatedObject(self, @selector(mbapm_isFirstHomePage), @(mbapm_isFirstHomePage), OBJC_ASSOCIATION_ASSIGN);
}


@end
