//
//  MBDebugPerformanceToolEntryHandler.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugPerformanceToolEntryHandler.h"
#import "MBDebugPerformanceViewController.h"
#import "MBDebugPerformanceEntryView.h"

@import MBUIKit;

@interface MBDebugPerformanceToolEntryHandler()

@property (nonatomic, strong) UIView *performanceEntryView;

@end

@serviceEX(MBDebugPerformanceToolEntryHandler, MBDebugEntryServiceProtocol)


@synthesize entryTitle;
@synthesize entryView;
@synthesize isHidden;
@synthesize handleBlock;

- (NSString *)entryTitle {
    return @"性能检测";
}

- (UIView *)entryView {
    return self.performanceEntryView;
}

- (BOOL)isHidden {
    return NO;
}

- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        UIViewController *performanceVC = [[MBDebugPerformanceViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:performanceVC];
        navVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:navVC animated:YES completion:nil];
    };
}

- (void)entryToolDidLoad {
    
}

- (UIView *)performanceEntryView {
    if(!_performanceEntryView){
        _performanceEntryView = [[MBDebugPerformanceEntryView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    return _performanceEntryView;
}

@end
