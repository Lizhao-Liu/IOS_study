//
//  HCBCodeScanerViewController+HCBCodeScannerRouter.h
//  HCBCodeScaner-HCBCodeScaner
//
//  Created by zhaozhao on 2024/3/21.
//

#import "HCBCodeScanerViewController.h"
@import YMMRouterLib;

NS_ASSUME_NONNULL_BEGIN

@interface HCBCodeScanerViewController (HCBCodeScannerRouter)

- (instancetype)initWithURLPath:(NSString *)urlPath query:(NSDictionary *)query complete:(HandleBlock)completed;

@end

NS_ASSUME_NONNULL_END
