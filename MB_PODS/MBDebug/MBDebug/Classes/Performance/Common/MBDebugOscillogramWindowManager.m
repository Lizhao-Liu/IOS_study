//
//  MBDebugOscillogramWindowManager.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/7.
//

#import "MBDebugOscillogramWindowManager.h"
#import "MBDebugFPSOscillogramWindow.h"
#import "MBDebugCPUOscillogramWindow.h"
#import "MBDebugMemoryOscillogramWindow.h"
@import MBUIKit;

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)

@interface MBDebugOscillogramWindowManager ()

@property (nonatomic, strong) MBDebugFPSOscillogramWindow *fpsWindow;
@property (nonatomic, strong) MBDebugCPUOscillogramWindow *cpuWindow;
@property (nonatomic, strong) MBDebugMemoryOscillogramWindow *memoryWindow;

@end

@implementation MBDebugOscillogramWindowManager

+ (instancetype)shareInstance {
    static dispatch_once_t once;
    static MBDebugOscillogramWindowManager *instance;
    dispatch_once(&once, ^{
        instance = [[MBDebugOscillogramWindowManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _fpsWindow = [MBDebugFPSOscillogramWindow shareInstance];
        _cpuWindow = [MBDebugCPUOscillogramWindow shareInstance];
        _memoryWindow = [MBDebugMemoryOscillogramWindow shareInstance];
    }
    return self;
}

- (NSArray *)performanceOscillogramWindows {
    return @[_cpuWindow, _memoryWindow, _fpsWindow];
}

- (NSArray *)performanceOscillogramWindowTitles {
    return @[@"cpu检测开关", @"内存检测开关", @"fps检测开关"];
}

- (void)resetLayout {
    CGFloat offsetY = 0;
    CGFloat width = 0;
    CGFloat height = 120;
    if (kInterfaceOrientationPortrait){
        width = kScreenWidth;
        offsetY = [MBDebugOscillogramWindowManager isIPhoneXSeries] ? 32 : 0;
    }else{
        width = kScreenHeight;
    }
    if (!_fpsWindow.hidden) {
        _fpsWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _fpsWindow.height+2;
    }
    
    if (!_cpuWindow.hidden) {
        _cpuWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _cpuWindow.height+2;
    }
    
    if (!_memoryWindow.hidden) {
        _memoryWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _memoryWindow.height+2;
    }
}


+ (BOOL)isIPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

@end
