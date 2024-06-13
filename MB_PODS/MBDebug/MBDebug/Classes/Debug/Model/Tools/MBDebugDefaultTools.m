//
//  MBDebugDefaultTools.m
//  MBDebug
//
//  Created by Lizhao on 2023/6/6.
//

#import "MBDebugDefaultTools.h"
#import "YMMPodFileViewController.h"
#import "MBDebugConfigViewController.h"
@import YMMModuleLib;


@protocol mb_DoraemonHomeWindowProtocol <NSObject>
+ (id)sharedInstance;
- (void)show;
@end


// APP集成组件信息
@serviceEX(MBDebugAPPComponentHandle, MBDebugServiceProtocol)

@synthesize itemTitle;
@synthesize summary;
@synthesize handleBlock;
    
- (NSString *)itemTitle {
    return @"APP组件信息";
}
    
- (NSString *)summary {
    return @"查看Pod组件信息";
}
    
- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        if (vc) {
            YMMPodFileViewController *viewController = [[YMMPodFileViewController alloc] init];
            [vc.navigationController pushViewController:viewController animated:YES];
        }
    };
}

@end

// DIDI工具集合
@serviceEX(MBDebugDIDIToolsHandle, MBDebugServiceProtocol)

@synthesize itemTitle;
@synthesize summary;
@synthesize handleBlock;
    
- (NSString *)itemTitle {
    return @"didi/DoraemonKit";
}
    
- (NSString *)summary {
    return @"DIDI工具集合";
}
    
- (MBDebugHandleBlock)handleBlock {
    Class DoraemonHomeWindowClass = NSClassFromString(@"DoraemonHomeWindow");
    return ^(UIViewController *vc) {
        if (DoraemonHomeWindowClass) {
            [[DoraemonHomeWindowClass shareInstance] show];
        }
    };
}

@end

@serviceEX(MBDebugConfigHandle, MBDebugServiceProtocol)

@synthesize itemTitle;
@synthesize summary;
@synthesize handleBlock;
    
- (NSString *)itemTitle {
    return @"debug面板配置";
}
    
- (NSString *)summary {
    return @"配置显示/隐藏的debug悬浮窗";
}
    
- (MBDebugHandleBlock)handleBlock {
    return ^(UIViewController *vc) {
        [vc.navigationController pushViewController:[[MBDebugConfigViewController alloc] init] animated:YES];
    };
}

@end
