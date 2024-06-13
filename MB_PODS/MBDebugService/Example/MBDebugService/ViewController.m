//
//  ViewController.m
//  MBDebugService
//
//  Created by billows on 12/26/2019.
//  Copyright (c) 2019 billows. All rights reserved.
//

#import "ViewController.h"
#import "MBDebugServiceProtocol.h"

typedef void(^MBDebugHandleBlock)(UIViewController *vc);

@interface ViewController ()

@property (nonatomic, copy) MBDebugHandleBlock handBlock;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(0, 100, 150, 50);
    testButton.backgroundColor = [UIColor orangeColor];
    [testButton setTitle:@"Protocol Test" forState:UIControlStateNormal];
    testButton.titleLabel.textColor = [UIColor whiteColor];
    [testButton addTarget:self action:@selector(debugProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    NSArray<id<MBDebugServiceProtocol>> *serviceList = FIND_SERVICE_LIST(MBDebugServiceProtocol);
    if (serviceList) {
        for (id<MBDebugServiceProtocol> service in serviceList) {
            NSLog(@"%@\n", service.itemTitle);
            NSLog(@"%@\n", service.summary);
            NSLog(@"%@\n", service.handleBlock);
            self.handBlock = service.handleBlock;
        }
    }
}
    
- (void)debugProtocolAction:(id)sender {
    self.handBlock(self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
