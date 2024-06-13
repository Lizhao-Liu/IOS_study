//
//  HCBBaseNavigationViewController.m
//  NewDriver4iOS
//
//  Created by yangtianyin on 15/12/9.
//  Copyright © 2015年 苼茹夏花. All rights reserved.
//

#import "HCBBaseNavigationViewController.h"
#import "HCBBaseViewController.h"
#import "UIButton+Extends.h"
#import "config.h"

@interface HCBBaseNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation HCBBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
    [self setupNav];
    [self.interactivePopGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [self.interactivePopGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        if (self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateEnded ||
            self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateCancelled ||
            self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateFailed) {
            self.viewAnimating = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNav {
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.barTintColor = color_yellow;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.notConfig) {
        [self configNavgationController:navigationController willShowViewController:viewController];
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.viewAnimating = NO;
}

- (void)configNavgationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController {
    UIViewController *rootVC = navigationController.viewControllers[0];
    if (rootVC == viewController) {
        rootVC.hidesBottomBarWhenPushed = NO;
    }
    
    if (navigationController.viewControllers.count > 1) {
        id target = self;
        SEL backSel = @selector(backClick);
        if ([viewController respondsToSelector:@selector(clickBackButton:)]) {
            backSel = @selector(clickBackButton:);
            target = viewController;
        }

        UIBarButtonItem *spaceA = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceA.width = -6;
        UIBarButtonItem *leftBarBtnItem = [self barButtonItemWithNormalImage:[UIImage imageNamed:@"back"] highlightImage:nil target:target action:backSel];
        
        viewController.navigationItem.leftBarButtonItems = @[spaceA,leftBarBtnItem];
    }
}

- (void)backClick {
    [self popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)barButtonItemWithNormalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlight target:(id)target action:(SEL)action {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:normalImage forState:UIControlStateNormal];
    if (highlight) {
        [backBtn setImage:highlight forState:UIControlStateHighlighted];
    }
    backBtn.frame = (CGRect){CGPointZero, normalImage.size};
    [backBtn extendResponseAreaWithExtendEdge:UIEdgeInsetsMake(10, 0, 10, 20)];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return barButtonItem;
}

@end
