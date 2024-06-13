//
//  MBAPMContext+RenderMonitor.m
//  MBAPMLib
//
//  Created by xp on 2024/1/26.
//

#import "MBAPMContext+RenderMonitor.h"
#import <objc/runtime.h>

@implementation MBAPMContext(RenderMonitor)

- (MBAPMGetAppLaunchTimeForFistPageRenderBlock)getLaunchTimeBlock {
    return objc_getAssociatedObject(self, @selector(getLaunchTimeBlock));
}

- (void)setGetLaunchTimeBlock:(MBAPMGetAppLaunchTimeForFistPageRenderBlock)getLaunchTimeBlock {
    objc_setAssociatedObject(self, @selector(getLaunchTimeBlock), getLaunchTimeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
