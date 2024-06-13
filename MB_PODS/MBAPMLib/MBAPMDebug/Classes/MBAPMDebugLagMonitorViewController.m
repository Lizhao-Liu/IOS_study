//
//  MBAPMDebugLagMonitorViewController.m
//  MBAPMDebug
//
//  Created by xp on 2020/8/18.
//

#import "MBAPMDebugLagMonitorViewController.h"

@interface MBAPMDebugLagMonitorViewController ()

@property (nonatomic, strong) UIButton *lagButton;
@property (nonatomic, strong) UIButton *shortLagButton;
@property (nonatomic, strong) UIButton *deadLockButton;
@property (nonatomic, strong) UIButton *blcokMainThreadButton;


@end

@implementation MBAPMDebugLagMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"卡顿监控";
    #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.view.backgroundColor = [UIColor tertiarySystemBackgroundColor];
        } else {
    #endif
            self.view.backgroundColor = [UIColor whiteColor];
        }
    [self.view addSubview:self.lagButton];
    [self.view addSubview:self.shortLagButton];
    [self.view addSubview:self.deadLockButton];
    [self.view addSubview:self.blcokMainThreadButton];
    [self.lagButton addTarget:self action:@selector(createDeadLag) forControlEvents:UIControlEventTouchUpInside];
    [self.shortLagButton addTarget:self action:@selector(createShortLag) forControlEvents:UIControlEventTouchUpInside];
    [self.deadLockButton addTarget:self action:@selector(createDeadLock) forControlEvents:UIControlEventTouchUpInside];
    [self.blcokMainThreadButton addTarget:self action:@selector(blcokMainThread) forControlEvents:UIControlEventTouchUpInside];
}

- (void)blcokMainThread {
    dispatch_async(dispatch_get_main_queue(), ^{
        int i = 1;
        while (1) {
            i++;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                int i = 1;
                while (1) {
                    i++;
                }
            });
        }
    });
}

- (void)createDeadLock {
    dispatch_sync(dispatch_get_main_queue(), ^{
        
    });
}

- (void)createDeadLag {
    dispatch_async(dispatch_get_main_queue(), ^{
           NSDate *lastDate = [NSDate date];
           int i = 1;
           while (1) {
               i++;
               NSDate *currentDate = [NSDate date];
               if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 6) {
                   break;
               }
           }
       });
}

- (void)createShortLag {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        dispatch_apply(6, dispatch_get_main_queue(), ^(size_t index) {
            NSDate *lastDate = [NSDate date];
            int i = 1;
            while (1) {
                i++;
                NSDate *currentDate = [NSDate date];
                if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 0.12) {
                    break;
                }
            }
        });
    });
}

- (UIButton *)lagButton {
    if(!_lagButton) {
        _lagButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _lagButton.frame = CGRectMake((self.view.bounds.size.width - 200)/2, 100, 100, 100);
        [_lagButton setTitle:@"长卡6s" forState:UIControlStateNormal];
        _lagButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _lagButton.titleLabel.textColor = [UIColor redColor];
    }
    return _lagButton;
}

- (UIButton *)shortLagButton {
    if(!_shortLagButton) {
        _shortLagButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _shortLagButton.frame = CGRectMake((self.view.bounds.size.width - 200)/2, 200, 200, 100);
        [_shortLagButton setTitle:@"连续短卡顿6s" forState:UIControlStateNormal];
        _shortLagButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _shortLagButton.titleLabel.textColor = [UIColor redColor];
    }
    return _shortLagButton;
}

- (UIButton *)deadLockButton {
    if(!_deadLockButton) {
        _deadLockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _deadLockButton.frame = CGRectMake((self.view.bounds.size.width - 200)/2, 300, 200, 100);
        [_deadLockButton setTitle:@"死锁" forState:UIControlStateNormal];
        _deadLockButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _deadLockButton.titleLabel.textColor = [UIColor redColor];
    }
    return _deadLockButton;
}


- (UIButton *)blcokMainThreadButton {
    if(!_blcokMainThreadButton) {
        _blcokMainThreadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _blcokMainThreadButton.frame = CGRectMake((self.view.bounds.size.width - 200)/2, 400, 200, 100);
        [_blcokMainThreadButton setTitle:@"主线程卡死" forState:UIControlStateNormal];
        _blcokMainThreadButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _blcokMainThreadButton.titleLabel.textColor = [UIColor redColor];
    }
    return _blcokMainThreadButton;
}

@end
