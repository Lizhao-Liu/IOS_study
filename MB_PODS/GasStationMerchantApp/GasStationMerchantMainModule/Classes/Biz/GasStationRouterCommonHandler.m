//
//  GasStationRouterCommonHandler.m
//  GasStationMerchantMainModule
//
//  Created by Lizhao on 2023/5/19.
//

#import "GasStationRouterCommonHandler.h"
@import HCBAppBasis;
@import MBUIKit;
@import UIKit;


@implementation GasStationRouterCommonHandler

- (void)handle:(id<YMMRouterRoutable>)routable callback:(HandlerCallback)callback {
    
    if (!routable.isValid) {
        return;
    }
    
    /**
     20230105版本添加支持 format_type、need_result
     wlqq://activity/rich_scan?format_type=1&need_result=1
     format_type: 支持格式, 空、0 表示二维码；1 表示二维码&条形码
     need_result: 是否需要扫码结果, 空、0 不需要扫码结果 库内部会使用扫码结果自动跳转；1 需要扫码结果, 回调扫码结果给调用者, 库内部不会自动跳转
     need_result=1 则回调 {"result":"xxxxx扫码结果"}, 如果扫码失败/没有结果, 则回调{}
     */
    
    if ([routable.path isEqualToString:@"/codescanner"] ||
        [routable.path isEqualToString:@"/rich_scan"] ||
        [routable.path isEqualToString:@"/scan"]) {
        
        HCBCodeScanerViewController *vc = nil;
        NSDictionary *params = routable.params;
        if (params && params[@"need_result"] && [params[@"need_result"] integerValue] == 1) {
            vc = [[HCBCodeScanerViewController alloc] init];
            vc.noAutoJump = YES;
            vc.resultBlock = ^(NSString *result) {
                if (routable.handleBlock) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    if (result && result.length > 0) {
                        [dic setObject:result forKey:@"result"];
                    }
                    routable.handleBlock(nil, dic);
                }
            };
        } else {
            vc = [[HCBCodeScanerViewController alloc] initWithURLPath:routable.path
                                                                query:routable.params
                                                             complete:routable.handleBlock];
        }
        if (params[@"format_type"]) {
            vc.formatType = [params[@"format_type"] integerValue];
        }
        vc.qrCodeNavigatorLink = [routable.params[@"qrCodeLink"] stringByRemovingPercentEncoding];
        [self.defaultNav pushViewController:vc
                                   animated:YES];
    }
}

- (UINavigationController *)defaultNav {
    return [UIViewController mb_currentViewController].navigationController;
}


@end
