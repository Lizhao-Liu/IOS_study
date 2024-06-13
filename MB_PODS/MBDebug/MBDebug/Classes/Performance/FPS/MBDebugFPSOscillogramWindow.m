//
//  MBDebugFPSOscillogramWindow.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugFPSOscillogramWindow.h"
#import "MBDebugFPSOscillogramViewController.h"

@implementation MBDebugFPSOscillogramWindow

+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static MBDebugFPSOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[MBDebugFPSOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    MBDebugFPSOscillogramViewController *vc = [[MBDebugFPSOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}

@end
