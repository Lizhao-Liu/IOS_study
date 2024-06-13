//
//  MBAPMDebugService.m
//  MBAPMLib
//
//  Created by xp on 2020/7/29.
//

#import "MBAPMDebugService.h"
#import "MBAPMDebugViewController.h"

@import YMMModuleLib;

@serviceEX(MBAPMDebugService, MBDebugServiceProtocol)

- (NSString *)itemTitle {
    return [NSString stringWithFormat:@"MBAPM-APP性能监控"];
}

- (NSString *)summary {
    return [NSString stringWithFormat:@"点击查看MBAPM系统配置、采集的性能数据和性能报告"];
}

- (MBDebugHandleBlock)handleBlock {
    MBDebugHandleBlock block = ^(UIViewController *vc) {
        MBAPMDebugViewController *viewController = [[MBAPMDebugViewController alloc]init];
        [vc.navigationController pushViewController:viewController animated:YES];
        viewController;
    };
    return block;
}

@end
