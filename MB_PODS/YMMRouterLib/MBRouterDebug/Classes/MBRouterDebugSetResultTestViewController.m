//
//  MBRouterDebugSetResultTestViewController.m
//  MBRouterDebug
//
//  Created by xp on 2022/11/10.
//

#import "MBRouterDebugSetResultTestViewController.h"
@import YMMRouterLib;

@interface MBRouterDebugSetResultTestViewController ()

@property (nonatomic, strong) UIButton *setResultBtn;

@end

@implementation MBRouterDebugSetResultTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"路由SetResult测试页面";
   #if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
       if (@available(iOS 13.0, *)) {
           self.view.backgroundColor = [UIColor tertiarySystemBackgroundColor];
       } else {
   #endif
           self.view.backgroundColor = [UIColor whiteColor];
       }

    [self.view addSubview:self.setResultBtn];
}

- (void)setResultForRouter {
    [self mbrouter_setResult:@"test result data" withError:nil];
}

- (UIButton *)setResultBtn {
    if (!_setResultBtn) {
        _setResultBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_setResultBtn setTitle:@"回传数据" forState:UIControlStateNormal];
        [_setResultBtn setBackgroundColor: [UIColor blueColor]];
        _setResultBtn.frame = CGRectMake(100, 200, 200, 100);
        [_setResultBtn addTarget:self action:@selector(setResultForRouter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setResultBtn;
}

@end
