//
//  HCBRouterCommonHandler.m
//  AliyunOSSiOS
//
//  Created by yc on 2019/11/22.
//

#import "HCBRouterCommonHandler.h"
@import HCBAppBasis;
@import MBUIKit;
@import UIKit;

@implementation HCBRouterCommonHandler

- (void)handle:(id<YMMRouterRoutable>)routable callback:(HandlerCallback)callback {
    
    if (!routable.isValid) {
        return;
    }
    
    if ([routable.path isEqualToString:@"/codescanner"] ||
        [routable.path isEqualToString:@"/rich_scan"] ||
        [routable.path isEqualToString:@"/scan"]) {
        HCBCodeScanerViewController *vc = [[HCBCodeScanerViewController alloc] initWithURLPath:routable.path
                                                                                         query:routable.params
                                                                                      complete:routable.handleBlock];
        vc.qrCodeNavigatorLink = [routable.params[@"qrCodeLink"] stringByRemovingPercentEncoding];
        [self.defaultNav pushViewController:vc
                                   animated:YES];
    }
}

- (UINavigationController *)defaultNav {
    return [UIViewController mb_currentViewController].navigationController;
}

@end
