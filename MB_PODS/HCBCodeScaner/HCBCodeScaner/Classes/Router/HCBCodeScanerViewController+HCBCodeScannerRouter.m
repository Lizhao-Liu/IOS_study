//
//  HCBCodeScanerViewController+HCBCodeScannerRouter.m
//  HCBCodeScaner-HCBCodeScaner
//
//  Created by zhaozhao on 2024/3/21.
//

#import "HCBCodeScanerViewController+HCBCodeScannerRouter.h"

@implementation HCBCodeScanerViewController (HCBCodeScannerRouter)

- (instancetype)initWithURLPath:(NSString *)urlPath query:(NSDictionary *)query complete:(HandleBlock)completed {
    self = [self init];
    if (self) {
        self.qrCodeNavigatorLink = [query[@"qrCodeLink"] stringByRemovingPercentEncoding];
        if (completed) {
            completed(nil, nil);
        }
    }
    return self;
}

@end
