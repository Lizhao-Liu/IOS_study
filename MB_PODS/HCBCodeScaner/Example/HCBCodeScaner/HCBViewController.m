//
//  HCBViewController.m
//  HCBCodeScaner
//
//  Created by 张鹏 on 03/19/2018.
//  Copyright (c) 2018 张鹏. All rights reserved.
//

#import "HCBViewController.h"
#import "HCBScanImageViewController.h"
#import <HCBCodeScaner/HCBCodeScaner.h>

@interface HCBViewController ()

@end

@implementation HCBViewController

#pragma mark - Overriding

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"HCBCodeScaner Demo";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    NSLog(@"current code scaner view controller: %@", [HCBCodeScaner getCurrentViewController]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"current code scaner view controller: %@", [HCBCodeScaner getCurrentViewController]);
}

#pragma mark - UITableViewDelegate

@end
