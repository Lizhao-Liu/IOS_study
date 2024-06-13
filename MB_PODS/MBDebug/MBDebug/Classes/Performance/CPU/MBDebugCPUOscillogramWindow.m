//
//  MBDebugCPUOscillogramWindow.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugCPUOscillogramWindow.h"
#import "MBDebugCPUOscillogramViewController.h"

@implementation MBDebugCPUOscillogramWindow

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static MBDebugCPUOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[MBDebugCPUOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    MBDebugCPUOscillogramViewController *vc = [[MBDebugCPUOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}

@end
