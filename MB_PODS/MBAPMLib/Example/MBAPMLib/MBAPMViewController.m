//
//  MBAPMViewController.m
//  MBAPMLib
//
//  Created by seal on 07/14/2020.
//  Copyright (c) 2020 seal. All rights reserved.
//

#import "MBAPMViewController.h"
@import MBAPMServiceLib;
@import YMMModuleLib;
#import "MBAPMDemoModule.h"


@interface MBAPMViewController ()

@end

@implementation MBAPMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id<MBAPMServiceProtocol> service = BIND_SERVICE([MBAPMDemoModule getContext], MBAPMServiceProtocol);
//    [service endAppLaunch];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

@end
