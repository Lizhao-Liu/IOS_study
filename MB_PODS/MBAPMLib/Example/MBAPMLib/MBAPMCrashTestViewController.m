//
//  MBAPMCrashTestViewController.m
//  MBAPMLib_Example
//
//  Created by xp on 2020/8/17.
//  Copyright © 2020 seal. All rights reserved.
//

#import "MBAPMCrashTestViewController.h"

@implementation MBAPMCrashTestViewController

- (IBAction)mockCrash:(id)sender {
    NSArray *array = [NSArray new];
    NSLog(@"crash %@", array[0]);
}
@end
