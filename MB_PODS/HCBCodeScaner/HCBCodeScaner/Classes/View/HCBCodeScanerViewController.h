//
//  HCBCodeScanerViewController.h
//  ios4driver
//
//  Created by yangtianyin on 16/1/4.
//  Copyright © 2016年 苼茹夏花. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScanResultBlock)(NSString *result);

typedef NS_ENUM(NSInteger, MBCodeScanFormatType) {
    MBCodeScanFormatTypeQR = 0,         // 二维码
    MBCodeScanFormatTypeQRAndBar = 1    // 二维码、条形码
};

@interface HCBCodeScanerViewController : UIViewController

/**
 位于扫码框上端的Label，提供给外部配置
 */
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) NSString *qrCodeNavigatorLink;


@property (nonatomic, assign) MBCodeScanFormatType formatType;

/**
 noAutoJump 默认NO 会自动跳转目标页
 YES: 不自动跳转目标页，仅resultBlock 返回扫码结果
 */
@property (nonatomic, assign) BOOL noAutoJump;

@property (nonatomic, copy) ScanResultBlock resultBlock;

/**
 重新激活扫码
 */
- (void)reActive;

@end
