//
//  GasStationHomePageBaseViewController.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/7/6.
//

#import "GasStationHomePageBaseViewController.h"
#import "config.h"
@import YMMRouterLib;
@import YMMModuleLib;
@import MBFoundation;


#import "HttpWithFlutterPlugin.h"

@interface GasStationHomePageBaseViewController ()

@property (nonatomic, strong) UIViewController *homePageVC;
@property (nonatomic, assign) BOOL didAppearBefore;

@end

@implementation GasStationHomePageBaseViewController

- (instancetype)init {
    self = [super init];
    if(self){
        self.didAppearBefore = NO;
        [self.view addSubview:self.homePageVC.view];
        [self addChildViewController:self.homePageVC];
        [self.homePageVC didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if(!self.didAppearBefore){
        self.didAppearBefore = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:YMMAppDidLoadMainPageNotification object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MBModule shared]triggerEvent:MBModuleDidMainPageAppear];
        });
    }
    
}


- (UIViewController *)homePageVC {
    if(!_homePageVC){
        __block UIViewController *flutterHomeVC;
        [[YMMRouterCenter shared] performWithURLString:gasStationFlutterHomePageUrl params:nil completion:^(YMMRouterResponse *response) {
            if (response.result && [response.result isKindOfClass:UIViewController.class]) {
                flutterHomeVC = response.result;
            }
        }];
        _homePageVC = flutterHomeVC;
    }
    return _homePageVC;
}

@end
