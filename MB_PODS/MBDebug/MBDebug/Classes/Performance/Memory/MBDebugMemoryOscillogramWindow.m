//
//  MBDebugMemoryOscillogramWindow.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugMemoryOscillogramWindow.h"
#import "MBDebugMemoryOscillogramViewController.h"

@implementation MBDebugMemoryOscillogramWindow

+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static MBDebugMemoryOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[MBDebugMemoryOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    MBDebugMemoryOscillogramViewController *vc = [[MBDebugMemoryOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}


@end
