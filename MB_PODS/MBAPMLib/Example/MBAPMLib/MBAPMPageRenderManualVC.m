//
//  MBAPMPageRenderManualVC.m
//  MBAPMLib_Example
//
//  Created by xp on 2020/7/28.
//  Copyright © 2020 seal. All rights reserved.
//

#import "MBAPMPageRenderManualVC.h"
@import YMMModuleLib;
@import MBAPMServiceLib;
#import "MBAPMDemoModule.h"
#import <YYModel/YYModel.h>

@interface MBAPMPageRenderManualVC ()<MBAPMViewPageProtocol>

@property (nonatomic, strong) id<MBAPMEventTrack> eventTrack;
@property (nonatomic, weak) id<MBAPMServiceProtocol> apmService;
@property (nonatomic, strong) id<MBAPMEventTimeTrack> eventTimeTrack;

@end

@implementation MBAPMPageRenderManualVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手动埋点检测方案";
    self.apmService = BIND_SERVICE([MBAPMDemoModule getContext], MBAPMServiceProtocol)
    self.eventTrack = [self.apmService startTrack:self];
    self.eventTimeTrack = [self.apmService startPageRenderTrack:self];
    [self.eventTimeTrack begin:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3), dispatch_get_global_queue(0, 0), ^{
        [self.eventTimeTrack beginIsolatedSection:@"dispatch_task" withExtra:nil];
//        [self.eventTimeTrack section:@"dispatch_task" withExtra:nil];
        sleep(3);
        [self.eventTimeTrack endIsolatedSection:@"dispatch_task" withExtra:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.eventTimeTrack end:@"end" withExtra:nil];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [self.eventTimeTrack beginIsolatedSection:@"willAppear" withExtra:@{@"ext_key1":@"ext_value_1"}];
    [super viewWillAppear:animated];
    [self.eventTrack markPoint:@"viewWillAppear"];
//    [self.eventTimeTrack endIsolatedSection:@"willAppear" withExtra:@{@"ext_key2":@"ext_value_2"}];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.eventTimeTrack section:@"viewWillAppear" withExtra:nil];
    [super viewDidAppear:animated];
    [self.eventTrack end:@"viewDidAppear"];
}

- (MBAPMViewPageRenderType)renderTypeForAPM {
    return MBAPMViewPageRenderTypeNative;
}

- (MBAPMViewPageRenderDetectType)renderDetectTypeForAPM {
    return MBAPMViewPageRenderDetectTypeManaul;
}

- (UIView *)detectViewForAPM {
    return self.view;
}

- (NSString *)pageNameForAPM {
    return @"apm_render_manual_test";
}

- (BOOL)enableRenderDetectForAPM {
    return YES;
}

@end
