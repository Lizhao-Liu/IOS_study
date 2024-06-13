//
//  YMMRouterErrorViewController.h
//  AliyunOSSiOS
//
//  Created by Trevor Lee on 2020/9/8.
//

#import <UIKit/UIKit.h>
@import MBUIKit;
@import YMMRouterLib;

NS_ASSUME_NONNULL_BEGIN

@interface YMMRouterErrorViewController : MBBaseViewController

+ (instancetype)pageWithPage:(YMMRouterStatus)responseCode urlString:(NSString *)urlString urlPath:(NSString *)urlPath;

@end

NS_ASSUME_NONNULL_END
