//
//  MBXXXViewController.m
//  MBShareModule
//
//  Created by Lizhao on 2023/4/27.
//

#import "MBXXXViewController.h"
#import "MBXXXModule.h"
#import "MBXXXModuleAdapterProtocol.h"
@import YMMModuleLib;

@interface MBXXXViewController ()

@end

@implementation MBXXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 服务发现：
    // 主类 调用adapter的run方法，如果是shipper宿主，返回yes，如果是driver宿主，返回no
//    id<MBXXXModuleAdapterProtocol> adapter = GET_ADAPTER([MBXXXModule getContext], MBXXXModuleAdapterProtocol);
//    // Adapter在shipper宿主下返回实例，并调用对应独有runShipper方法。其他宿主下返回空值，即不会调用方法
//    [adapter run];
}


@end
