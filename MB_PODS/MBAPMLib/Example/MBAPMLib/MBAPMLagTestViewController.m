//
//  MBAPMLagTestViewController.m
//  MBAPMLib_Example
//
//  Created by xp on 2020/8/16.
//  Copyright © 2020 seal. All rights reserved.
//

#import "MBAPMLagTestViewController.h"

@interface MBAPMLagTestViewController ()

@end

@implementation MBAPMLagTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"卡顿检测";
    [self mockLag];
}

- (void)mockLag {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate *lastDate = [NSDate date];
        int i = 1;
        while (1) {
            i++;
            NSDate *currentDate = [NSDate date];
            if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 10) {
                break;
            }
        }
    });
    dispatch_async(dispatch_get_main_queue(), ^{
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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDate *lastDate = [NSDate date];
//        int i = 1;
//        while (1) {
//            i++;
//            NSDate *currentDate = [NSDate date];
//            if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 0.12) {
//                break;
//            }
//        }
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSDate *lastDate = [NSDate date];
//        int i = 1;
//        while (1) {
//            i++;
//            NSDate *currentDate = [NSDate date];
//            if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 0.12) {
//                break;
//            }
//        }
//    });
}

@end
